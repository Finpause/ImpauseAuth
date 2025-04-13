require('dotenv').config();

const express = require('express');
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
app.use('', authRoutes);

// Error handler middleware
app.use(errorHandler);

// Start the server
const PORT = process.env.PORT || 5000;
const HOST = process.env.NODE_ENV === 'development' ? '127.0.0.1' : '0.0.0.0';

app.listen(PORT, HOST, () => {
    console.log(`Server is running on http://${HOST}:${PORT}`);
});

// Handle unhandled promise rejections
process.on('unhandledRejection', (err) => {
    console.log(`Error: ${err.message}`);
    process.exit(1);
});
