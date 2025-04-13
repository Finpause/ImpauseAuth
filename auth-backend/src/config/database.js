const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    // Add debugging to see if environment variables are loaded
    console.log('Connecting to MongoDB with URL:', process.env.DATABASE_URL);
    
    // For Mongoose 8.x, many connection options are now default
    // and useNewUrlParser, useUnifiedTopology, etc. are no longer needed
    const conn = await mongoose.connect(process.env.DATABASE_URL);
    
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error(`Error connecting to MongoDB: ${error.message}`);
    process.exit(1);
  }
};

module.exports = connectDB;