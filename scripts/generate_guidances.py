#!/usr/bin/env python3
"""
Script to generate guidances for images using Claude AI.
For each image in a folder (in order), this script:
1. Makes a call to Claude Haiku with:
   - System prompt from api/prompts/guidance.md
   - The 2 most recent images
   - The 10 previous guidances
2. Saves the answers in a file
3. Optionally converts guidances to speech using ElevenLabs TTS API
"""

import os
import argparse
import base64
import json
import requests
import time
from pathlib import Path
from dotenv import load_dotenv
from tqdm import tqdm

# Load environment variables from .env file
load_dotenv()

def read_system_prompt(prompt_path):
    """Read the system prompt from a file."""
    try:
        with open(prompt_path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        print(f"Error reading system prompt: {e}")
        return "You are DeskMate, an educational AI assistant. Provide guidance for the student's work."

def encode_image_to_base64(image_path):
    """Encode an image to base64."""
    try:
        with open(image_path, 'rb') as image_file:
            encoded_string = base64.b64encode(image_file.read()).decode('utf-8')
            
            # Add the appropriate data URL prefix based on file extension
            ext = image_path.suffix.lower()
            if ext == '.png':
                return f"data:image/png;base64,{encoded_string}"
            elif ext in ['.jpg', '.jpeg']:
                return f"data:image/jpeg;base64,{encoded_string}"
            else:
                # Default to JPEG if unknown
                return f"data:image/jpeg;base64,{encoded_string}"
    except Exception as e:
        print(f"Error encoding image {image_path}: {e}")
        return None

def read_previous_guidances(guidance_file, max_guidances=10):
    """Read previous guidances from a file."""
    try:
        if not os.path.exists(guidance_file):
            return []
        
        with open(guidance_file, 'r', encoding='utf-8') as f:
            guidances = f.read().strip().split('\n\n---\n\n')
            # Return the most recent guidances (up to max_guidances)
            return guidances[-max_guidances:] if guidances else []
    except Exception as e:
        print(f"Error reading previous guidances: {e}")
        return []

def call_claude_api(system_prompt, images, previous_guidances):
    """Call Claude API with the given prompt, images, and previous guidances."""
    api_key = os.getenv('ANTHROPIC_API_KEY')
    if not api_key:
        raise ValueError("ANTHROPIC_API_KEY not found in environment variables or .env file")
    
    # Prepare the messages
    messages = []
    
    # Add previous guidances as context
    if previous_guidances:
        context_message = "Previous guidances:\n\n" + "\n\n---\n\n".join(previous_guidances)
        messages.append({
            "role": "user",
            "content": [{"type": "text", "text": context_message}]
        })
        
        # Add a system message to acknowledge the context
        messages.append({
            "role": "assistant",
            "content": "I've reviewed the previous guidances and will continue helping the student."
        })
    
    # Create the user message with images
    user_content = []
    
    # Add text prompt with explicit instruction to only provide guidance
    user_content.append({
        "type": "text", 
        "text": "Here are the latest images of the student's work. Please provide guidance. Respond ONLY with the guidance itself, no additional text or explanations about what you're doing."
    })
    
    # Add images
    for image_base64 in images:
        if image_base64:
            # Determine media type from base64 string
            media_type = "image/jpeg"  # Default
            if "data:image/png;base64," in image_base64:
                media_type = "image/png"
            
            # Clean the base64 string
            clean_base64 = image_base64.replace("data:image/png;base64,", "").replace("data:image/jpeg;base64,", "")
            
            user_content.append({
                "type": "image",
                "source": {
                    "type": "base64",
                    "media_type": media_type,
                    "data": clean_base64
                }
            })
    
    # Add the user message with images
    messages.append({
        "role": "user",
        "content": user_content
    })
    
    # Prepare the API request
    url = "https://api.anthropic.com/v1/messages"
    headers = {
        "Content-Type": "application/json",
        "x-api-key": api_key,
        "anthropic-version": "2023-06-01"
    }
    
    data = {
        "model": "claude-3-7-sonnet-latest",  # Updated to use Claude 3.7 Sonnet
        "max_tokens": 1024,
        "temperature": 0.7,
        "system": system_prompt,
        "messages": messages
    }
    
    # Make the API request
    try:
        response = requests.post(url, headers=headers, json=data)
        response.raise_for_status()  # Raise an exception for HTTP errors
        
        result = response.json()
        return result["content"][0]["text"]
    except Exception as e:
        print(f"Error calling Claude API: {e}")
        if response:
            print(f"Response status: {response.status_code}")
            print(f"Response body: {response.text}")
        return f"Error generating guidance: {str(e)}"

def process_images(input_dir, output_file, system_prompt_path, max_previous=10):
    """Process images in a directory and generate guidances."""
    # Read system prompt
    system_prompt = read_system_prompt(system_prompt_path)
    
    # Get all image files and sort them
    image_extensions = ['.jpg', '.jpeg', '.png', '.bmp', '.tiff']
    image_files = sorted([
        f for f in Path(input_dir).iterdir() 
        if f.suffix.lower() in image_extensions and not f.name.endswith('_processed.jpg')
    ])
    
    if not image_files:
        print(f"No image files found in {input_dir}")
        return
    
    print(f"Found {len(image_files)} images to process")
    
    # Create output directory if it doesn't exist
    output_file = Path(output_file)
    output_file.parent.mkdir(parents=True, exist_ok=True)
    
    # Get the reference image path
    reference_image_path = Path("deskmate-website/public/homeworks/subject.png")
    if not reference_image_path.exists():
        print(f"Warning: Reference image {reference_image_path} not found")
        reference_image = None
    else:
        reference_image = encode_image_to_base64(reference_image_path)
        print(f"Using reference image: {reference_image_path}")
    
    # Process each image
    for i, image_path in enumerate(tqdm(image_files, desc="Processing images")):
        try:
            # Read previous guidances
            previous_guidances = read_previous_guidances(output_file, max_previous)
            
            # Get the current image and the previous image (if available)
            current_images = []
            
            # Always add the reference image first if available
            if reference_image:
                current_images.append(reference_image)
            
            # Add the previous image if available
            if i > 0:
                prev_image = encode_image_to_base64(image_files[i-1])
                if prev_image:
                    current_images.append(prev_image)
            
            # Add the current image
            current_image = encode_image_to_base64(image_path)
            if current_image:
                current_images.append(current_image)
            
            # Skip if no images are available
            if not current_images:
                print(f"Skipping {image_path.name}: Could not encode image")
                continue
            
            # Call Claude API
            print(f"Generating guidance for {image_path.name}...")
            guidance = call_claude_api(system_prompt, current_images, previous_guidances)
            
            # Save the guidance
            with open(output_file, 'a', encoding='utf-8') as f:
                if os.path.getsize(output_file) > 0:
                    f.write("\n\n---\n\n")
                f.write(f"Image: {image_path.name}\n\n{guidance}")
            
            print(f"Guidance saved for {image_path.name}")
            
            # Add a small delay to avoid rate limiting
            time.sleep(1)
            
        except Exception as e:
            print(f"Error processing {image_path.name}: {e}")
    
    print("Processing complete!")

def text_to_speech(text, output_file, voice_id="JBFqnCBsd6RMkjVDRZzb", model_id="eleven_multilingual_v2"):
    """Convert text to speech using ElevenLabs API and save to file."""
    api_key = os.getenv('ELEVENLABS_API_KEY')
    if not api_key:
        print("Error: ELEVENLABS_API_KEY not found in environment variables or .env file")
        return False
    
    url = f"https://api.elevenlabs.io/v1/text-to-speech/{voice_id}"
    
    headers = {
        "xi-api-key": api_key,
        "Content-Type": "application/json"
    }
    
    data = {
        "text": text,
        "model_id": model_id,
        "voice_settings": {
            "stability": 0.5,
            "similarity_boost": 0.75
        }
    }
    
    try:
        print(f"Converting text to speech...")
        response = requests.post(url, json=data, headers=headers)
        
        if response.status_code == 200:
            # Save the audio content to a file
            with open(output_file, 'wb') as f:
                f.write(response.content)
            print(f"Speech saved to {output_file}")
            return True
        else:
            print(f"Error: {response.status_code} - {response.text}")
            return False
    except Exception as e:
        print(f"Error in text-to-speech conversion: {e}")
        return False

def process_guidances_to_speech(guidance_file, output_dir):
    """Process all guidances in a file and convert them to speech."""
    try:
        # Create output directory if it doesn't exist
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Read guidances from file
        with open(guidance_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Split into individual guidances
        guidances = content.split('\n\n---\n\n')
        
        print(f"Found {len(guidances)} guidances to process")
        
        # Process each guidance
        for i, guidance in enumerate(tqdm(guidances, desc="Converting to speech")):
            # Extract the image name and guidance text
            parts = guidance.split('\n\n', 1)
            if len(parts) < 2:
                print(f"Skipping guidance {i+1}: Invalid format")
                continue
            
            image_info = parts[0]
            guidance_text = parts[1]
            
            # Extract image name from the image info line
            image_name = image_info.replace('Image: ', '').strip()
            
            # Create output filename based on the image name
            output_file = output_dir / f"{Path(image_name).stem}_speech.mp3"
            
            # Convert to speech
            text_to_speech(guidance_text, output_file)
            
        print("Speech conversion complete!")
        return True
    except Exception as e:
        print(f"Error processing guidances to speech: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description='Generate guidances for images using Claude AI.')
    parser.add_argument('input_dir', help='Directory containing images to process')
    parser.add_argument('--output_file', default='guidances.txt', help='File to save guidances (defaults to guidances.txt)')
    parser.add_argument('--system_prompt', default='api/prompts/guidance.md', help='Path to system prompt file')
    parser.add_argument('--max_previous', type=int, default=10, help='Maximum number of previous guidances to include')
    parser.add_argument('--tts', action='store_true', help='Convert guidances to speech using ElevenLabs')
    parser.add_argument('--tts_only', action='store_true', help='Only convert existing guidances to speech, skip image processing')
    parser.add_argument('--tts_output_dir', default='speech', help='Directory to save speech files (defaults to "speech")')
    args = parser.parse_args()
    
    # If only converting to speech, skip the image processing
    if args.tts_only:
        if not os.path.exists(args.output_file):
            print(f"Error: Guidance file {args.output_file} not found")
            return
        process_guidances_to_speech(args.output_file, args.tts_output_dir)
        return
    
    # Check if ANTHROPIC_API_KEY is set
    if not os.getenv('ANTHROPIC_API_KEY'):
        print("Error: ANTHROPIC_API_KEY not found in environment variables or .env file")
        print("Please set the ANTHROPIC_API_KEY environment variable or add it to your .env file")
        return
    
    # Process images
    process_images(args.input_dir, args.output_file, args.system_prompt, args.max_previous)
    
    # Convert to speech if requested
    if args.tts:
        if not os.getenv('ELEVENLABS_API_KEY'):
            print("Error: ELEVENLABS_API_KEY not found in environment variables or .env file")
            print("Please set the ELEVENLABS_API_KEY environment variable or add it to your .env file")
            return
        process_guidances_to_speech(args.output_file, args.tts_output_dir)

if __name__ == "__main__":
    main()
