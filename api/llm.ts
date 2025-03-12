import { NextRequest, NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';
import Anthropic from '@anthropic-ai/sdk';

// Initialize Anthropic client
const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY || '',
});

// Define types for our request
interface Message {
  role: 'user' | 'assistant' | 'system';
  content: string | MessageContent[];
}

interface MessageContent {
  type: 'text' | 'image';
  text?: string;
  source?: {
    type: 'base64';
    media_type: string;
    data: string;
  };
}

interface LLMRequest {
  prompt: string;
  systemPrompt?: string;
  messages?: Message[];
  images?: string[]; // Base64 encoded images
  model?: string;
  temperature?: number;
  maxTokens?: number;
}

export async function POST(req: NextRequest) {
  try {
    // Parse the request body
    const body: LLMRequest = await req.json();

    // Get system prompt from file if not provided
    let systemPrompt = body.systemPrompt;
    if (!systemPrompt) {
      try {
        const promptPath = path.join(process.cwd(), 'api', 'prompts', 'answer.md');
        systemPrompt = fs.readFileSync(promptPath, 'utf8');
      } catch (error) {
        console.error('Error reading system prompt file:', error);
        systemPrompt = "You are DeskMate, an educational AI assistant. Be concise and helpful.";
      }
    }

    // Prepare messages array
    let messages: Message[] = body.messages || [];

    // If no messages provided, create a new conversation with the system prompt
    if (messages.length === 0) {
      messages = [
        {
          role: 'system',
          content: systemPrompt
        }
      ];
    }

    // Add user prompt with images if provided
    if (body.prompt || body.images?.length) {
      const userMessage: Message = {
        role: 'user',
        content: []
      };

      // Add text content if provided
      if (body.prompt) {
        userMessage.content.push({
          type: 'text',
          text: body.prompt
        });
      }

      // Add images if provided
      if (body.images && body.images.length > 0) {
        for (const imageBase64 of body.images) {
          // Determine media type from base64 string
          let mediaType = 'image/jpeg'; // Default
          if (imageBase64.startsWith('data:image/png;base64,')) {
            mediaType = 'image/png';
          } else if (imageBase64.startsWith('data:image/jpeg;base64,') || 
                     imageBase64.startsWith('data:image/jpg;base64,')) {
            mediaType = 'image/jpeg';
          }

          // Clean the base64 string (remove data URL prefix if present)
          const cleanBase64 = imageBase64.replace(/^data:image\/\w+;base64,/, '');

          userMessage.content.push({
            type: 'image',
            source: {
              type: 'base64',
              media_type: mediaType,
              data: cleanBase64
            }
          });
        }
      }

      // Add the user message to the messages array
      messages.push(userMessage);
    }

    // Call Claude API
    const response = await anthropic.messages.create({
      model: body.model || 'claude-3-5-haiku-latest',
      max_tokens: body.maxTokens || 1024,
      temperature: body.temperature || 0.7,
      system: systemPrompt,
      messages: messages.filter(msg => msg.role !== 'system') // System message is passed separately
    });

    // Return the response
    return NextResponse.json({
      response: response.content[0].text,
      usage: {
        input_tokens: response.usage.input_tokens,
        output_tokens: response.usage.output_tokens
      }
    });
  } catch (error: any) {
    console.error('Error calling Claude API:', error);
    return NextResponse.json(
      { error: error.message || 'An error occurred while processing your request' },
      { status: 500 }
    );
  }
}

export const config = {
  runtime: 'edge',
};
