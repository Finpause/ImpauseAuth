#!/bin/bash
# filepath: /Users/Ethan_1/Python/ImpauseAuth/test_api.sh

# Set the base URL
BASE_URL="http://localhost:5050/api/auth"
EMAIL="test@example.com"
PASSWORD="password123"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Testing Authentication API ===${NC}"
echo ""

# 1. Test register endpoint
echo -e "${BLUE}1. Registering a new user${NC}"
# Register with first and last name
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/register" \
  -H "Content-Type: application/json" \
  -d "{\"firstName\":\"John\",\"lastName\":\"Doe\",\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")
echo "Response: $REGISTER_RESPONSE"
echo ""

# Check if registration was successful and extract token
if [[ "$REGISTER_RESPONSE" == *"success\":true"* ]]; then
  echo -e "${GREEN}Registration successful${NC}"
  REGISTER_TOKEN=$(echo $REGISTER_RESPONSE | grep -o '"token":"[^"]*' | grep -o '[^"]*$')
  echo "Token: ${REGISTER_TOKEN:0:20}... (truncated)"
else
  echo -e "${YELLOW}Registration failed - user may already exist${NC}"
fi
echo ""

# 2. Test login endpoint
echo -e "${BLUE}2. Logging in with registered user${NC}"
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

echo "Response: $LOGIN_RESPONSE"
echo ""

# Check if login was successful
if [[ "$LOGIN_RESPONSE" == *"success\":true"* ]]; then
  echo -e "${GREEN}Login successful${NC}"
  # Extract token from response
  TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*' | grep -o '[^"]*$')
  echo "Token: ${TOKEN:0:20}... (truncated)"
else
  echo -e "${RED}Login failed${NC}"
  # Try to use register token if login failed
  if [[ -n "$REGISTER_TOKEN" ]]; then
    echo -e "${YELLOW}Using registration token instead${NC}"
    TOKEN=$REGISTER_TOKEN
  else
    echo -e "${RED}No token available, some tests will be skipped${NC}"
  fi
fi
echo ""

# 3. Test token authentication with /me endpoint
if [[ -n "$TOKEN" ]]; then
  echo -e "${BLUE}3. Verifying token authentication with /me endpoint${NC}"
  USER_RESPONSE=$(curl -s -X GET "$BASE_URL/me" \
    -H "Authorization: Bearer $TOKEN")

  echo "Response: $USER_RESPONSE"
  echo ""

  # Check if get user was successful
  if [[ "$USER_RESPONSE" == *"success\":true"* ]]; then
    echo -e "${GREEN}Token authentication successful${NC}"
    # Extract user details to verify
    USER_EMAIL=$(echo $USER_RESPONSE | grep -o '"email":"[^"]*' | grep -o '[^"]*$')
    USER_ROLE=$(echo $USER_RESPONSE | grep -o '"role":"[^"]*' | grep -o '[^"]*$')
    echo "Authenticated as: $USER_EMAIL (Role: $USER_ROLE)"
  else
    echo -e "${RED}Token authentication failed${NC}"
  fi
else
  echo -e "${RED}Skipping token authentication test - no token available${NC}"
fi
echo ""

# 4. Test login with incorrect password
echo -e "${BLUE}4. Attempting login with incorrect password${NC}"
FAILED_LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"wrongpassword\"}")

echo "Response: $FAILED_LOGIN_RESPONSE"
echo ""

# Check if login failed as expected
if [[ "$FAILED_LOGIN_RESPONSE" == *"Invalid credentials"* ]]; then
  echo -e "${GREEN}Test passed: Login correctly rejected invalid credentials${NC}"
else
  echo -e "${RED}Test failed: Login should have rejected invalid credentials${NC}"
fi
echo ""

# 5. Test accessing protected route without token
echo -e "${BLUE}5. Attempting to access protected route without token${NC}"
UNAUTH_RESPONSE=$(curl -s -X GET "$BASE_URL/me")

echo "Response: $UNAUTH_RESPONSE"
echo ""

# Check if access was denied as expected
if [[ "$UNAUTH_RESPONSE" == *"Not authorized"* || "$UNAUTH_RESPONSE" == *"token"* ]]; then
  echo -e "${GREEN}Test passed: Protected route correctly rejected unauthenticated access${NC}"
else
  echo -e "${RED}Test failed: Protected route should reject unauthenticated access${NC}"
fi
echo ""

# 6. Test logout
if [[ -n "$TOKEN" ]]; then
  echo -e "${BLUE}6. Testing logout${NC}"
  LOGOUT_RESPONSE=$(curl -s -X POST "$BASE_URL/logout" \
    -H "Authorization: Bearer $TOKEN")

  echo "Response: $LOGOUT_RESPONSE"
  echo ""

  # Check if logout was successful
  if [[ "$LOGOUT_RESPONSE" == *"success\":true"* ]]; then
    echo -e "${GREEN}Logout successful${NC}"
    
    # Test that token is no longer valid after logout
    echo -e "${BLUE}7. Verifying token is invalidated after logout${NC}"
    AFTER_LOGOUT_RESPONSE=$(curl -s -X GET "$BASE_URL/me" \
      -H "Authorization: Bearer $TOKEN")
    
    echo "Response: $AFTER_LOGOUT_RESPONSE"
    echo ""
    
    # Note: This may still work with JWTs unless you've implemented token blacklisting
    if [[ "$AFTER_LOGOUT_RESPONSE" == *"success\":true"* ]]; then
      echo -e "${YELLOW}Note: Token still works after logout - this is expected with stateless JWTs${NC}"
      echo -e "${YELLOW}For full security, implement token blacklisting or use short expiration times${NC}"
    else
      echo -e "${GREEN}Token has been invalidated after logout${NC}"
    fi
  else
    echo -e "${RED}Logout failed${NC}"
  fi
else
  echo -e "${RED}Skipping logout test - no token available${NC}"
fi
echo ""

echo -e "${BLUE}=== API Tests Completed ===${NC}"