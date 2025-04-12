const User = require('../models/User');
const jwt = require('jsonwebtoken');
const { createError } = require('../utils/errorHandler');

class AuthController {
    async registerUser(req, res, next) {
        try {
            const { email, password } = req.body;

            // Check if user already exists
            const existingUser = await User.findOne({ email });
            if (existingUser) {
                return next(createError(400, 'Email already in use'));
            }

            // Create new user
            const user = new User({
                email,
                password
            });

            await user.save();

            // Generate JWT token
            const token = jwt.sign(
                { id: user._id, email: user.email, role: user.role },
                process.env.JWT_SECRET,
                { expiresIn: process.env.JWT_EXPIRES_IN }
            );

            // Return success response without password
            res.status(201).json({
                success: true,
                token,
                user: {
                    id: user._id,
                    email: user.email,
                    role: user.role,
                    isVerified: user.isVerified
                }
            });
        } catch (error) {
            next(error);
        }
    }

    async loginUser(req, res, next) {
        try {
            const { email, password } = req.body;

            // Check if user exists and include password field for comparison
            const user = await User.findOne({ email }).select('+password');
            if (!user) {
                return next(createError(401, 'Invalid credentials'));
            }

            // Verify password
            const isMatch = await user.comparePassword(password);
            if (!isMatch) {
                return next(createError(401, 'Invalid credentials'));
            }

            // Generate JWT token
            const token = jwt.sign(
                { id: user._id, email: user.email, role: user.role },
                process.env.JWT_SECRET,
                { expiresIn: process.env.JWT_EXPIRES_IN }
            );

            // Return success response without password
            res.status(200).json({
                success: true,
                token,
                user: {
                    id: user._id,
                    email: user.email,
                    role: user.role,
                    isVerified: user.isVerified
                }
            });
        } catch (error) {
            next(error);
        }
    }

    async getUser(req, res, next) {
        try {
            // User ID is available from auth middleware in req.user
            const user = await User.findById(req.user.id);
            
            if (!user) {
                return next(createError(404, 'User not found'));
            }

            res.status(200).json({
                success: true,
                user: {
                    id: user._id,
                    email: user.email,
                    role: user.role,
                    isVerified: user.isVerified,
                    createdAt: user.createdAt
                }
            });
        } catch (error) {
            next(error);
        }
    }

    async updatePassword(req, res, next) {
        try {
            const { currentPassword, newPassword } = req.body;

            // Get user with password
            const user = await User.findById(req.user.id).select('+password');
            
            // Verify current password
            const isMatch = await user.comparePassword(currentPassword);
            if (!isMatch) {
                return next(createError(401, 'Current password is incorrect'));
            }

            // Update password
            user.password = newPassword;
            await user.save();

            res.status(200).json({
                success: true,
                message: 'Password updated successfully'
            });
        } catch (error) {
            next(error);
        }
    }

    async logoutUser(req, res) {
        // JWT is stateless, so we just tell the client to delete the token
        res.status(200).json({
            success: true,
            message: 'Logged out successfully'
        });
    }
}

// Export a single instance instead of the class
module.exports = new AuthController();