#!/bin/bash
# filepath: /Users/Ethan_1/Python/ImpauseAuth/auth-backend/test-api.sh

# Set the base URL
BASE_URL="http://localhost:5050/api/auth"
EMAIL="test@example.com"
PASSWORD="password123"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Testing Authentication API ===${NC}"
echo ""

# 1. Test register endpoint
echo -e "${BLUE}1. Registering a new user${NC}"
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

echo "Response: $REGISTER_RESPONSE"
echo ""

# Check if registration was successful
if [[ "$REGISTER_RESPONSE" == *"success\":true"* ]]; then
  echo -e "${GREEN}Registration successful${NC}"
  # Extract token from response
  TOKEN=$(echo $REGISTER_RESPONSE | grep -o '"token":"[^"]*' | grep -o '[^"]*$')
  echo "Token: $TOKEN"
else
  echo -e "${RED}Registration failed${NC}"
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
  echo "Token: $TOKEN"
else
  echo -e "${RED}Login failed${NC}"
fi
echo ""

# 3. Test login with incorrect password
echo -e "${BLUE}3. Attempting login with incorrect password${NC}"
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

# 4. Test get user endpoint
if [[ -n "$TOKEN" ]]; then
  echo -e "${BLUE}4. Retrieving user profile with token${NC}"
  USER_RESPONSE=$(curl -s -X GET "$BASE_URL/me" \
    -H "Authorization: Bearer $TOKEN")

  echo "Response: $USER_RESPONSE"
  echo ""

  # Check if get user was successful
  if [[ "$USER_RESPONSE" == *"success\":true"* ]]; then
    echo -e "${GREEN}User profile retrieved successfully${NC}"
  else
    echo -e "${RED}Failed to retrieve user profile${NC}"
  fi
else
  echo -e "${RED}Skipping user profile test - no token available${NC}"
fi
echo ""

# 5. Test logout
if [[ -n "$TOKEN" ]]; then
  echo -e "${BLUE}5. Testing logout${NC}"
  LOGOUT_RESPONSE=$(curl -s -X POST "$BASE_URL/logout" \
    -H "Authorization: Bearer $TOKEN")

  echo "Response: $LOGOUT_RESPONSE"
  echo ""

  # Check if logout was successful
  if [[ "$LOGOUT_RESPONSE" == *"success\":true"* ]]; then
    echo -e "${GREEN}Logout successful${NC}"
  else
    echo -e "${RED}Logout failed${NC}"
  fi
else
  echo -e "${RED}Skipping logout test - no token available${NC}"
fi
echo ""

echo -e "${BLUE}=== API Tests Completed ===${NC}"