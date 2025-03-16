const { setCorsHeaders } = require('./utils/common');

module.exports = function handler(req, res) {
  setCorsHeaders(res, req);  // Pass req as the second parameter
  res.status(200).json({ status: 'API is running' });
}
