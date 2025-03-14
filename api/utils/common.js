const setCorsHeaders = (res, req) => {
  console.log('Setting CORS headers');
  res.setHeader('Access-Control-Allow-Credentials', true);
  
  // Allow specific origins or use the requesting origin
  const allowedOrigins = ['http://localhost:58542', 'http://localhost:3000', 'https://mydeskmate.ai'];
  const origin = req.headers.origin;
  if (origin && allowedOrigins.includes(origin)) {
    res.setHeader('Access-Control-Allow-Origin', origin);
  } else {
    res.setHeader('Access-Control-Allow-Origin', '*');
  }
  
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  );
};

const handleCors = (req, res) => {
  console.log(`Handling CORS for ${req.method} request to ${req.url}`);
  setCorsHeaders(res, req);
  
  // Handle OPTIONS request for CORS preflight
  if (req.method === 'OPTIONS') {
    console.log('Responding to OPTIONS request');
    res.status(200).end();
    return true;
  }
  return false;
};

const validateMethod = (req, res, method = 'POST') => {
  console.log(`Validating method: ${req.method} against expected: ${method}`);
  if (req.method !== method) {
    console.log('Method not allowed');
    res.status(405).json({ error: 'Method not allowed' });
    return false;
  }
  return true;
};

module.exports = {
  setCorsHeaders,
  handleCors,
  validateMethod
};
