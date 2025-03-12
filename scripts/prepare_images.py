#!/usr/bin/env python3
"""
Script to prepare images of handwritten notes for LLM processing.
This script:
1. Detects notebook/paper edges
2. Crops to the detected edges
3. Enhances contrast and reduces blur
4. Performs OCR to extract text
5. Saves processed images and extracted text
"""

import os
import argparse
import cv2
import numpy as np
import easyocr
from pathlib import Path
from tqdm import tqdm
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

def detect_and_crop_edges(image):
    """Detect edges of notebook/paper and crop the image."""
    # Convert to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    # Apply Gaussian blur to reduce noise
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)
    
    # Apply edge detection
    edges = cv2.Canny(blurred, 75, 200)
    
    # Find contours
    contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    
    # Find the largest contour (assuming it's the paper)
    if contours:
        largest_contour = max(contours, key=cv2.contourArea)
        
        # Approximate the contour to get a polygon
        epsilon = 0.02 * cv2.arcLength(largest_contour, True)
        approx = cv2.approxPolyDP(largest_contour, epsilon, True)
        
        # If we have a quadrilateral (4 points), we can apply perspective transform
        if len(approx) == 4:
            # Order points in top-left, top-right, bottom-right, bottom-left order
            pts = np.array([pt[0] for pt in approx], dtype=np.float32)
            rect = order_points(pts)
            
            # Get width and height of the new image
            width = max(
                int(np.linalg.norm(rect[1] - rect[0])),  # Top edge
                int(np.linalg.norm(rect[3] - rect[2]))   # Bottom edge
            )
            height = max(
                int(np.linalg.norm(rect[3] - rect[0])),  # Left edge
                int(np.linalg.norm(rect[2] - rect[1]))   # Right edge
            )
            
            # Define destination points
            dst = np.array([
                [0, 0],
                [width - 1, 0],
                [width - 1, height - 1],
                [0, height - 1]
            ], dtype=np.float32)
            
            # Apply perspective transform
            M = cv2.getPerspectiveTransform(rect, dst)
            warped = cv2.warpPerspective(image, M, (width, height))
            
            return warped
    
    # If no proper quadrilateral is found, return the original image
    return image

def order_points(pts):
    """Order points in top-left, top-right, bottom-right, bottom-left order."""
    # Initialize ordered points
    rect = np.zeros((4, 2), dtype=np.float32)
    
    # Top-left will have the smallest sum, bottom-right will have the largest sum
    s = pts.sum(axis=1)
    rect[0] = pts[np.argmin(s)]
    rect[2] = pts[np.argmax(s)]
    
    # Top-right will have the smallest difference, bottom-left will have the largest difference
    diff = np.diff(pts, axis=1)
    rect[1] = pts[np.argmin(diff)]
    rect[3] = pts[np.argmax(diff)]
    
    return rect

def enhance_image(image):
    """Enhance image for better LLM processing."""
    # Keep the color information (don't convert to grayscale)
    
    # Apply denoising while preserving edges
    denoised = cv2.fastNlMeansDenoisingColored(image, None, 10, 10, 7, 21)
    
    # Convert to LAB color space for better color enhancement
    lab = cv2.cvtColor(denoised, cv2.COLOR_BGR2LAB)
    
    # Split the LAB image into L, A, and B channels
    l, a, b = cv2.split(lab)
    
    # Apply CLAHE to L channel to enhance contrast without affecting color
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
    cl = clahe.apply(l)
    
    # Merge the CLAHE enhanced L channel with the original A and B channels
    merged = cv2.merge((cl, a, b))
    
    # Convert back to BGR color space
    enhanced = cv2.cvtColor(merged, cv2.COLOR_LAB2BGR)
    
    # Apply subtle sharpening to make text more readable
    kernel = np.array([[-0.5,-0.5,-0.5], 
                       [-0.5, 5,-0.5],
                       [-0.5,-0.5,-0.5]])
    sharpened = cv2.filter2D(enhanced, -1, kernel)
    
    return sharpened

def enhance_visual(image):
    """Enhance image for visual appeal (not for OCR)."""
    # Apply subtle improvements for visual appeal
    
    # Convert to LAB color space
    if len(image.shape) == 3:
        lab = cv2.cvtColor(image, cv2.COLOR_BGR2LAB)
        
        # Split the LAB image into L, A, and B channels
        l, a, b = cv2.split(lab)
        
        # Apply CLAHE to L channel
        clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
        cl = clahe.apply(l)
        
        # Merge the CLAHE enhanced L channel with the original A and B channels
        merged = cv2.merge((cl, a, b))
        
        # Convert back to BGR color space
        enhanced = cv2.cvtColor(merged, cv2.COLOR_LAB2BGR)
        
        # Apply subtle sharpening
        kernel = np.array([[-1,-1,-1], 
                           [-1, 9,-1],
                           [-1,-1,-1]])
        enhanced = cv2.filter2D(enhanced, -1, kernel)
        
        return enhanced
    else:
        # If already grayscale, just apply CLAHE
        clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
        enhanced = clahe.apply(image)
        return enhanced

def check_google_credentials():
    """Check if Google Cloud credentials are properly set up."""
    try:
        # Check if GOOGLE_API_KEY environment variable is set
        api_key = os.getenv('GOOGLE_API_KEY')
        if not api_key:
            print("\nWARNING: GOOGLE_API_KEY not found in environment or .env file.")
            print("You need to set up a Google Cloud API key to use the Vision API.")
            print("Instructions:")
            print("1. Create a Google Cloud project: https://console.cloud.google.com/")
            print("2. Enable the Vision API for your project")
            print("3. Create an API key in the Google Cloud Console")
            print("4. Create a .env file in the same directory as this script with:")
            print("   GOOGLE_API_KEY=your_api_key_here")
            return False
        return True
    except Exception as e:
        print(f"\nError with Google Cloud credentials: {e}")
        return False

def perform_ocr(image):
    """Extract text from image using Google Cloud Vision API with API key."""
    try:
        # Get API key from environment
        api_key = os.getenv('GOOGLE_API_KEY')
        if not api_key:
            return "No API key found"
        
        # Convert the image to base64
        success, encoded_image = cv2.imencode('.jpg', image)
        if not success:
            return "Error encoding image"
        
        import base64
        import requests
        import json
        
        # Encode image to base64
        image_content = base64.b64encode(encoded_image.tobytes()).decode('utf-8')
        
        # Prepare request to Vision API
        request_body = {
            "requests": [
                {
                    "image": {
                        "content": image_content
                    },
                    "features": [
                        {
                            "type": "TEXT_DETECTION"
                        }
                    ]
                }
            ]
        }
        
        # Make request to Vision API
        response = requests.post(
            f'https://vision.googleapis.com/v1/images:annotate?key={api_key}',
            json=request_body
        )
        
        # Parse response
        if response.status_code != 200:
            return f"API Error: {response.status_code} - {response.text}"
        
        result = response.json()
        
        # Extract text from response
        try:
            text_annotations = result['responses'][0]['textAnnotations']
            if text_annotations:
                # The first annotation contains all the text
                full_text = text_annotations[0]['description']
                return full_text
            else:
                return "No text detected"
        except KeyError:
            if 'error' in result['responses'][0]:
                return f"API Error: {result['responses'][0]['error']['message']}"
            return "No text found in response"
            
    except Exception as e:
        print(f"OCR Error: {e}")
        return f"OCR ERROR: {str(e)}"

def process_image(image_path, output_dir, skip_ocr=False):
    """Process a single image and save results."""
    # Read the image
    image = cv2.imread(str(image_path))
    if image is None:
        print(f"Error: Could not read image {image_path}")
        return
    
    # Create output paths
    filename = image_path.stem
    processed_image_path = output_dir / f"{filename}_processed.jpg"
    text_path = output_dir / f"{filename}_text.txt"
    
    # Process the image
    cropped = detect_and_crop_edges(image)
    enhanced = enhance_image(cropped)
    
    # Save the processed image
    cv2.imwrite(str(processed_image_path), enhanced)
    
    # Perform OCR if not skipped
    if not skip_ocr and check_google_credentials():
        text = perform_ocr(enhanced)
        with open(text_path, 'w', encoding='utf-8') as f:
            f.write(text)
        return processed_image_path, text_path
    else:
        return processed_image_path, None

def main():
    parser = argparse.ArgumentParser(description='Process images of handwritten notes for LLM processing.')
    parser.add_argument('input_dir', help='Directory containing images to process')
    parser.add_argument('--output_dir', help='Directory to save processed images and text (defaults to input_dir)')
    parser.add_argument('--no-ocr', action='store_true', help='Skip OCR processing')
    args = parser.parse_args()
    
    # Check Google credentials if OCR is not skipped
    if not args.no_ocr and not check_google_credentials():
        print("Warning: Proceeding without valid Google Cloud credentials. OCR will be skipped.")
        args.no_ocr = True
    
    input_dir = Path(args.input_dir)
    output_dir = Path(args.output_dir) if args.output_dir else input_dir
    
    # Create output directory if it doesn't exist
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Get all image files
    image_extensions = ['.jpg', '.jpeg', '.png', '.bmp', '.tiff']
    image_files = [f for f in input_dir.iterdir() if f.suffix.lower() in image_extensions]
    
    if not image_files:
        print(f"No image files found in {input_dir}")
        return
    
    print(f"Found {len(image_files)} images to process")
    
    # Process each image
    for image_path in tqdm(image_files, desc="Processing images"):
        try:
            processed_path, text_path = process_image(image_path, output_dir, args.no_ocr)
            if text_path:
                print(f"Processed {image_path.name} -> {processed_path.name}, {text_path.name}")
            else:
                print(f"Processed {image_path.name} -> {processed_path.name} (OCR skipped)")
        except Exception as e:
            print(f"Error processing {image_path.name}: {e}")
    
    print("Processing complete!")

if __name__ == "__main__":
    main()
