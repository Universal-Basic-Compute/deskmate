const { handleCors, validateMethod } = require('./common');
const formidable = require('formidable');

module.exports = async function handler(req, res) {
  console.log('Screenshot API handler called');
  
  // Handle CORS - this must be first!
  // If it's an OPTIONS request, this will end the response
  if (handleCors(req, res)) {
    console.log('CORS handled, returning early for OPTIONS request');
    return;
  }
  
  // Only proceed with validation after handling OPTIONS
  if (!validateMethod(req, res)) {
    console.log('Method validation failed, returning early');
    return;
  }

  try {
    console.log('Processing screenshot request');
    
    // Use formidable to parse multipart form data
    const form = new formidable.IncomingForm();
    
    form.parse(req, (err, fields, files) => {
      if (err) {
        console.error('Error parsing form data:', err);
        return res.status(500).json({ error: 'Error processing form data' });
      }
      
      // Check if we have screenshot data
      if (!files || !files.screenshot) {
        console.error('No screenshot file found in request');
        return res.status(400).json({ error: 'Screenshot data is required' });
      }
      
      // Process the image and return a response
      console.log('Screenshot received successfully');
      
      // For now, just return a mock response
      return res.status(200).json({ 
        response: "I've analyzed your image. This appears to be a math problem involving quadratic equations. Would you like me to help you solve it step by step?",
        success: true 
      });
    });
  } catch (error) {
    console.error('Screenshot API error:', error.message);
    return res.status(500).json({ 
      error: 'Error processing screenshot',
      details: error.message
    });
  }
}
