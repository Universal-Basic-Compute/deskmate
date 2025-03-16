const Airtable = require('airtable');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { handleCors } = require('./common');

// Initialize Airtable
const base = new Airtable({
  apiKey: process.env.AIRTABLE_API_KEY
}).base(process.env.AIRTABLE_BASE_ID);

const usersTable = base('USERS');

module.exports = async function handler(req, res) {
  console.log('Login API handler called');
  
  // Check for required environment variables
  if (!process.env.AIRTABLE_API_KEY || !process.env.AIRTABLE_BASE_ID || !process.env.JWT_SECRET) {
    console.error('Missing required environment variables: AIRTABLE_API_KEY, AIRTABLE_BASE_ID, or JWT_SECRET');
    return res.status(500).json({
      success: false,
      error: 'Server configuration error'
    });
  }
  
  // Handle CORS - this must be first!
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
    console.log('Processing login request');
    
    // Get login credentials from request body
    const { email, password } = req.body;

    // Validate required fields
    if (!email || !password) {
      console.log('Missing required fields');
      return res.status(400).json({
        success: false,
        error: 'Email and password are required'
      });
    }

    // Find user by email
    console.log(`Looking up user: ${email}`);
    const records = await usersTable.select({
      filterByFormula: `{Email} = '${email}'`
    }).firstPage();

    // Check if user exists
    if (records.length === 0) {
      console.log('User not found');
      return res.status(401).json({
        success: false,
        error: 'Invalid email or password'
      });
    }

    const user = records[0];
    const userData = user.fields;

    // Verify password
    console.log('Verifying password');
    const isMatch = await bcrypt.compare(password, userData.PasswordHash);

    if (!isMatch) {
      console.log('Password does not match');
      return res.status(401).json({
        success: false,
        error: 'Invalid email or password'
      });
    }

    // Generate JWT token
    console.log('Generating JWT token');
    const token = jwt.sign(
      { 
        userId: user.id,
        email: userData.Email,
        firstName: userData.FirstName,
        lastName: userData.LastName
      },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    // Return success with token and user data
    return res.status(200).json({
      success: true,
      token,
      user: {
        id: user.id,
        email: userData.Email,
        firstName: userData.FirstName,
        lastName: userData.LastName
      }
    });

  } catch (error) {
    console.error('Error during login:', error);
    return res.status(500).json({
      success: false,
      error: 'Server error during login'
    });
  }
};
