const setCorsHeaders = (res, req) => {
  console.log('Setting CORS headers');
  
  // Always set these headers for all responses
  res.setHeader('Access-Control-Allow-Credentials', true);
  
  // Get the origin from the request headers if req exists
  const origin = req?.headers?.origin;
  if (origin) {
    console.log(`Request origin: ${origin}`);
    // Allow the specific origin that made the request
    res.setHeader('Access-Control-Allow-Origin', origin);
  } else {
    // Fallback to allow all origins if no origin header
    res.setHeader('Access-Control-Allow-Origin', '*');
  }
  
  // Allow all common methods
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  
  // Allow all common headers
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version, Origin'
  );
  
  // Add max age to reduce preflight requests
  res.setHeader('Access-Control-Max-Age', '86400'); // 24 hours
};

const handleCors = (req, res) => {
  console.log(`Handling CORS for ${req.method} request to ${req.url}`);
  
  // Set CORS headers for all requests
  setCorsHeaders(res, req);
  
  // Handle OPTIONS request for CORS preflight
  if (req.method === 'OPTIONS') {
    console.log('Responding to OPTIONS request with 200 OK');
    // Important: Return 200 status immediately for OPTIONS requests
    // without any redirects
    res.writeHead(200);
    res.end();
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
