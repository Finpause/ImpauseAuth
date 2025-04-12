const express = require('express');
const authController = require('../controllers/authController');
const { validateRegistration, validateLogin } = require('../middleware/validation');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

// User registration route
router.post('/register', validateRegistration, authController.registerUser);

// User login route
router.post('/login', validateLogin, authController.loginUser);

// Get user details route
router.get('/me', authMiddleware, authController.getUser);

// Update password route
router.post('/update-password', authMiddleware, authController.updatePassword);

// Logout route
router.post('/logout', authController.logoutUser);

module.exports = router;