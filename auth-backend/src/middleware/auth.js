const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { createError } = require('../utils/errorHandler');

const authMiddleware = async (req, res, next) => {
    try {
        // Get token from header
        const authHeader = req.headers.authorization;
        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return next(createError(401, 'No token provided, authorization denied'));
        }

        const token = authHeader.split(' ')[1];

        // Verify token
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        
        // Check if user exists
        const user = await User.findById(decoded.id);
        if (!user) {
            return next(createError(401, 'User not found'));
        }

        // Set user in request
        req.user = {
            id: user._id,
            email: user.email,
            role: user.role
        };
        
        next();
    } catch (error) {
        if (error.name === 'JsonWebTokenError') {
            return next(createError(401, 'Invalid token'));
        }
        if (error.name === 'TokenExpiredError') {
            return next(createError(401, 'Token expired'));
        }
        next(error);
    }
};

module.exports = authMiddleware;