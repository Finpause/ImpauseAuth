module.exports = {
  generateToken: (user) => {
    const jwt = require('jsonwebtoken');
    const secret = process.env.JWT_SECRET || 'your_jwt_secret';
    const token = jwt.sign({ id: user._id }, secret, { expiresIn: '1h' });
    return token;
  },

  verifyToken: (token) => {
    const jwt = require('jsonwebtoken');
    const secret = process.env.JWT_SECRET || 'your_jwt_secret';
    try {
      const decoded = jwt.verify(token, secret);
      return decoded;
    } catch (error) {
      return null;
    }
  }
};