const { handleCors } = require('./utils/common');

module.exports = function handler(req, res) {
  // Handle CORS
  if (handleCors(req, res)) {
    return;
  }
  
  res.status(200).json({ status: 'API is running' });
}
