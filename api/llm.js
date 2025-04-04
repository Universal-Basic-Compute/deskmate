const axios = require('axios');
const fs = require('fs');
const path = require('path');
const { handleCors, validateMethod } = require('./common');

module.exports = async function handler(req, res) {
  console.log('LLM API handler called');
  
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
    console.log('Processing LLM request');
    const { prompt, system, messages, images } = req.body;
    
    // Get API key from environment variable
    const apiKey = process.env.ANTHROPIC_API_KEY;
    if (!apiKey) {
      return res.status(500).json({ error: 'Anthropic API key not configured' });
    }

    // Load the base system prompt if not overridden
    let systemPrompt = system;
    if (!systemPrompt) {
      try {
        // Load base prompt
        const basePromptPath = path.join(process.cwd(), 'api', 'prompts', 'base_prompt.txt');
        const basePrompt = fs.readFileSync(basePromptPath, 'utf8');
        
        // No character-specific prompts
        
        // Get a random mode from the modes directory
        let modePrompt = '';
        try {
          const modesDir = path.join(process.cwd(), 'api', 'prompts', 'modes');
          // Read all files in the modes directory
          const modeFiles = fs.readdirSync(modesDir);
          if (modeFiles.length > 0) {
            // Select a random mode file
            const randomModeFile = modeFiles[Math.floor(Math.random() * modeFiles.length)];
            const modePath = path.join(modesDir, randomModeFile);
            modePrompt = fs.readFileSync(modePath, 'utf8');
            console.log(`Using mode: ${randomModeFile}`);
          }
        } catch (modeErr) {
          console.warn('Could not load mode prompt:', modeErr.message);
        }
        
        // Combine prompts
        systemPrompt = basePrompt + '\n\n' + modePrompt;
      } catch (err) {
        console.warn('Could not load base prompt:', err.message);
      }
    }

    // Prepare the request payload
    const payload = {
      model: "claude-3-5-haiku-latest",
      max_tokens: 1000,
      temperature: 0.7,
    };

    // Add system prompt if available
    if (systemPrompt) {
      payload.system = systemPrompt;
    }

    // Handle different input formats
    if (messages && Array.isArray(messages) && messages.length > 0) {
      // Filter out any system messages and use the first one as the system parameter
      const systemMessages = messages.filter(msg => msg.role === 'system');
      const nonSystemMessages = messages.filter(msg => msg.role !== 'system');
      
      // If there's a system message, use it as the system parameter
      if (systemMessages.length > 0 && !payload.system) {
        payload.system = systemMessages[0].content;
      }
      
      // Use only non-system messages in the messages array
      payload.messages = nonSystemMessages;
      
      // Check if any message has empty or undefined content
      if (payload.messages.length > 0) {
        for (let i = 0; i < payload.messages.length; i++) {
          const msg = payload.messages[i];
          
          // If content is undefined or empty string, provide a default
          if (!msg.content || (typeof msg.content === 'string' && msg.content.trim() === '')) {
            console.warn(`Message at index ${i} has empty content, setting default content`);
            msg.content = "I don't have any specific question, just looking for general help.";
          }
          
          // If content is an empty array, add a default text item
          if (Array.isArray(msg.content) && msg.content.length === 0) {
            console.warn(`Message at index ${i} has empty content array, adding default content`);
            msg.content.push({
              type: 'text',
              text: "I don't have any specific question, just looking for general help."
            });
          }
        }
      }
      
      // Log if we have images
      console.log('Request body contains images:', !!images);
      if (images) {
        console.log('Images count:', images.length);
        console.log('First image data length:', images[0]?.data?.length || 0);
      }
      
      // Add images to the last user message if provided
      if (images && Array.isArray(images) && images.length > 0) {
        // Find the last user message
        const lastUserMessageIndex = nonSystemMessages.findLastIndex(msg => msg.role === 'user');
        
        if (lastUserMessageIndex !== -1) {
          const lastUserMessage = nonSystemMessages[lastUserMessageIndex];
          
          console.log('Found last user message at index:', lastUserMessageIndex);
          console.log('Last user message content type:', typeof lastUserMessage.content);
          
          // Convert the content to array format if it's a string
          if (typeof lastUserMessage.content === 'string') {
            const textContent = lastUserMessage.content;
            lastUserMessage.content = [{ type: 'text', text: textContent }];
          } else if (!Array.isArray(lastUserMessage.content)) {
            // If content is neither string nor array, initialize as empty array
            lastUserMessage.content = [];
          }
          
          // Add each image to the content array
          for (const imageData of images) {
            if (imageData && imageData.data) {
              console.log('Adding image to message, data length:', imageData.data.length);
              lastUserMessage.content.push({
                type: 'image',
                source: {
                  type: 'base64',
                  media_type: imageData.media_type || 'image/jpeg',
                  data: imageData.data
                }
              });
            } else {
              console.warn('Skipping invalid image data');
            }
          }
          
          console.log('Updated last user message content:', 
            Array.isArray(lastUserMessage.content) 
              ? `Array with ${lastUserMessage.content.length} items` 
              : typeof lastUserMessage.content);
        } else {
          console.warn('No user message found to attach images to');
        }
      }
    } else if (prompt) {
      // Use simple prompt format
      payload.messages = [
        { role: 'user', content: prompt }
      ];
      
      // Add images if provided
      if (images && Array.isArray(images) && images.length > 0) {
        const content = [];
        content.push({ type: 'text', text: prompt });
        
        for (const imageData of images) {
          content.push({
            type: 'image',
            source: {
              type: 'base64',
              media_type: imageData.media_type || 'image/jpeg',
              data: imageData.data
            }
          });
        }
        
        payload.messages[0].content = content;
      }
    } else {
      return res.status(400).json({ error: 'Either prompt or messages must be provided' });
    }

    // Log payload structure for debugging
    console.log('Payload structure:', JSON.stringify({
      model: payload.model,
      max_tokens: payload.max_tokens,
      temperature: payload.temperature,
      system: payload.system ? 'Present (length: ' + payload.system.length + ')' : 'Not present',
      messages: payload.messages.map(m => ({
        role: m.role,
        content: Array.isArray(m.content) 
          ? m.content.map(c => {
              if (c.type === 'text') {
                return { type: 'text', length: c.text?.length || 0 };
              } else {
                return { 
                  type: c.type || 'unknown', 
                  source_type: c.source?.type || 'unknown', 
                  data_length: (c.source?.data?.length) || 0 
                };
              }
            })
          : { type: 'string', length: (typeof m.content === 'string' ? m.content.length : 0) }
      })),
      hasImages: !!images
    }, null, 2));

    // Validate that we have valid content in all messages
    let hasInvalidContent = false;
    for (let i = 0; i < payload.messages.length; i++) {
      const msg = payload.messages[i];
      if (!msg.content || 
          (typeof msg.content === 'string' && msg.content.trim() === '') ||
          (Array.isArray(msg.content) && msg.content.length === 0)) {
        hasInvalidContent = true;
        console.error(`Invalid content in message at index ${i}:`, msg);
      }
    }

    if (hasInvalidContent) {
      return res.status(400).json({ 
        error: 'Invalid message content',
        details: 'One or more messages has empty or invalid content'
      });
    }

    // Make request to Anthropic API
    const response = await axios({
      method: 'POST',
      url: 'https://api.anthropic.com/v1/messages',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01'
      },
      data: payload
    });

    // Return the response
    return res.status(200).json(response.data);
  } catch (error) {
    console.error('Anthropic API error:', error.response?.data || error.message);
    return res.status(error.response?.status || 500).json({ 
      error: 'Error generating response',
      details: error.response?.data || error.message
    });
  }
}
