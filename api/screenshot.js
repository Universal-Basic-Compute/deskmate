const axios = require('axios');
const { handleCors, validateMethod } = require('./common');

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
    
    // Check if we have screenshot data
    if (!req.body || !req.body.screenshot) {
      console.error('No screenshot data found in request');
      return res.status(400).json({ error: 'Screenshot data is required' });
    }

    // Extract data from request
    const { screenshot, username = 'anonymous', message = "I've sent you a picture. Can you help me with this?" } = req.body;
    
    console.log('Screenshot received, data length:', screenshot.length);
    console.log('Username:', username);
    console.log('Message:', message);

    // Call the LLM API with the screenshot
    const llmResponse = await axios({
      method: 'POST',
      url: `https://${req.headers.host}/api/llm`,
      headers: {
        'Content-Type': 'application/json'
      },
      data: {
        messages: [
          {
            role: 'user',
            content: message
          }
        ],
        images: [
          {
            data: screenshot,
            media_type: 'image/jpeg'
          }
        ]
      }
    });

    console.log('LLM API response status:', llmResponse.status);
    
    // Extract bot response
    let botResponse = "I'm sorry, I couldn't analyze the image at this time.";
    if (llmResponse.data.content && Array.isArray(llmResponse.data.content) && llmResponse.data.content.length > 0) {
      botResponse = llmResponse.data.content[0].text;
    }

    // Return the LLM response
    return res.status(200).json({ 
      success: true,
      response: botResponse
    });
  } catch (error) {
    console.error('Screenshot API error:', error.message);
    return res.status(500).json({ 
      error: 'Error processing screenshot',
      details: error.message
    });
  }
}
