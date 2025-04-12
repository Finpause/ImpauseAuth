require('dotenv').config();

const express = require('express');
const mongoose = require('mongoose');
const passport = require('passport');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');
const connectDB = require('./config/database');
const { passportConfig } = require('./config/passport');
const { errorHandler } = require('./utils/errorHandler');

const app = express();

// Connect to MongoDB
connectDB();

// Middleware
app.use(cors());
app.use(express.json());
app.use(passport.initialize());
passportConfig(passport);

// Routes
app.use('/api/auth', authRoutes);

// Error handler middleware
app.use(errorHandler);

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

// Handle unhandled promise rejections
process.on('unhandledRejection', (err) => {
    console.log(`Error: ${err.message}`);
    // Close server & exit process
    process.exit(1);
});