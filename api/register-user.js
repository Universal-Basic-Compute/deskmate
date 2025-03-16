const Airtable = require('airtable');
const bcrypt = require('bcryptjs');
const { handleCors } = require('./common');

// Initialize Airtable
const base = new Airtable({
  apiKey: process.env.AIRTABLE_API_KEY
}).base(process.env.AIRTABLE_BASE_ID);

const usersTable = base('USERS');

module.exports = async function handler(req, res) {
  console.log('Register User API handler called');
  
  // Check for required environment variables
  if (!process.env.AIRTABLE_API_KEY || !process.env.AIRTABLE_BASE_ID) {
    console.error('Missing required environment variables: AIRTABLE_API_KEY or AIRTABLE_BASE_ID');
    return res.status(500).json({
      success: false,
      error: 'Server configuration error'
    });
  }
  
  // Handle CORS - this must be first!
  // If it's an OPTIONS request, this will end the response
  if (handleCors(req, res)) {
    console.log('CORS handled, returning early for OPTIONS request');
    return;
  }

  // Only accept POST requests
  if (req.method !== 'POST') {
    console.log(`Method not allowed: ${req.method}`);
    return res.status(405).json({ 
      success: false,
      error: 'Method not allowed' 
    });
  }

  try {
    console.log('Processing registration request');
    
    // Get user data from request body
    const { email, firstName, lastName, password } = req.body;

    // Validate required fields
    if (!email || !firstName || !lastName || !password) {
      console.log('Missing required fields');
      return res.status(400).json({
        success: false,
        error: 'Missing required fields'
      });
    }

    // Check if user already exists
    console.log(`Checking if user exists: ${email}`);
    const existingRecords = await usersTable.select({
      filterByFormula: `{Email} = '${email}'`
    }).firstPage();

    if (existingRecords.length > 0) {
      console.log('User already exists');
      return res.status(409).json({
        success: false,
        error: 'User with this email already exists'
      });
    }

    // Generate salt and hash password
    console.log('Hashing password');
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    // Create user in Airtable
    console.log('Creating user in Airtable');
    const createdRecords = await usersTable.create([
      {
        fields: {
          Email: email,
          FirstName: firstName,
          LastName: lastName,
          PasswordHash: passwordHash,
          PasswordSalt: salt,
          CreatedAt: new Date().toISOString()
        }
      }
    ]);

    console.log('User registered successfully');
    
    // Return success response
    return res.status(201).json({
      success: true,
      message: 'User registered successfully',
      userId: createdRecords[0].id
    });

  } catch (error) {
    console.error('Error registering user:', error);
    return res.status(500).json({
      success: false,
      error: 'Server error during registration'
    });
  }
};
