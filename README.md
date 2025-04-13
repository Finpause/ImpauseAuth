# Authentication Backend

This project is a full authentication backend built with Node.js, Express, MongoDB Atlas, Passport.js, and JWT. It provides user registration, login, and authentication functionalities.

## Features

- User registration with email/password
- User login with JWT token generation
- Token-based authentication
- Password hashing with bcrypt
- Role-based authorization
- Password reset capabilities
- Secure route protection

## Technologies Used

- Node.js
- Express
- MongoDB Atlas
- Mongoose
- Passport.js
- JSON Web Tokens (JWT)
- bcryptjs (for password hashing)
- Express-validator (for request validation)

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

3. Create a `.env` file in the project root with the following variables:
   ```
   DATABASE_URL=mongodb+srv://<username>:<password>@<cluster>.mongodb.net/<dbname>?retryWrites=true&w=majority
   JWT_SECRET=your_jwt_secret_key
   JWT_EXPIRES_IN=30d
   PORT=5050
   NODE_ENV=development
   ```

### Running the Application

1. Start the server:
   ```
   npm start
   ```
   
   Or for development with auto-reload:
   ```
   npm run dev
   ```

2. The server will run on `http://localhost:5050` (or the port specified in your environment variables).

### API Endpoints

#### Authentication
- **POST /register**: Register a new user
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```

- **POST /login**: Log in an existing user
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```

- **GET /me**: Get authenticated user profile (requires auth token)

- **POST /update-password**: Update user password (requires auth token)
  ```json
  {
    "currentPassword": "oldPassword",
    "newPassword": "newPassword"
  }
  ```

- **POST /logout**: Log out user (requires auth token)

### Testing the API

You can test the API using the included test script:

```bash
# Make the script executable
chmod +x test_api.sh

# Run the test script
./test_api.sh
```

### Deployment

This project can be deployed to Heroku:

1. Create a Heroku account and install the Heroku CLI
2. Login to Heroku: `heroku login`
3. Create a new Heroku app: `heroku create`
4. Configure environment variables on Heroku
5. Deploy the application: `git push heroku main`

### License

This project is licensed under the MIT License.
