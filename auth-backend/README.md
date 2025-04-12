# Authentication Backend

This project is a full authentication backend built with Node.js, Express, MongoDB Atlas, Passport.js, and JWT. It provides user registration, login, and authentication functionalities.

## Features

- User registration
- User login
- JWT-based authentication
- Middleware for request validation
- MongoDB Atlas for data storage

## Technologies Used

- Node.js
- Express
- MongoDB Atlas
- Mongoose
- Passport.js
- JSON Web Tokens (JWT)
- Joi (for validation)

## Getting Started

### Prerequisites

- Node.js and npm installed
- MongoDB Atlas account
- Postman or any API testing tool

### Installation

1. Clone the repository:
   ```
   git clone <repository-url>
   cd auth-backend
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Create a `.env` file based on the `.env.example` file and fill in your MongoDB Atlas connection string and JWT secret.

### Running the Application

1. Start the server:
   ```
   npm start
   ```

2. The server will run on `http://localhost:5000` (or the port specified in your environment variables).

### API Endpoints

- **POST /api/auth/register**: Register a new user
- **POST /api/auth/login**: Log in an existing user
- **GET /api/auth/user**: Get details of the authenticated user (requires JWT)

### License

This project is licensed under the MIT License.