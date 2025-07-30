The process is a two-step flow:
   1. Request OTP: The user enters their PIN, and your app sends it to the backend to request an OTP.
   2. Verify OTP: The user receives the OTP via SMS, enters it into your app, and your app sends the PIN and OTP to the backend for verification. If successful, the backend returns a JWT authentication token.


  ---

  Step 1: Request an OTP

  Your app should first make a call to this endpoint to trigger the OTP SMS.

   * Endpoint: POST /v2/api/login/pin
   * Content-Type: application/json


  Request Body

  The request body should be a JSON object containing the user's PIN.


  ```json
   {
     "pin": "1234"
   }
  ```


  Success Response (Status `200 OK`)


  If the PIN is valid and the user has a phone number, the backend will send the OTP and your app will receive a success response.


  ```json
   {
       "success": true,
       "message": "OTP sent to your phone",
       "phoneNumber": "250788123456",
       "requiresOtp": true
   }
  ```


   * Note for Development: If the server is running with flipper.otp.bypass.enabled=true, the response will include the OTP directly, so you don't have to check your phone during testing.


  ```json
    {
        "success": true,
        "message": "OTP SMS sending bypassed for dev/debug. Use OTP: 123456",
        "dev_otp": "123456",
        "phoneNumber": "250788123456",
        "requiresOtp": true
    }
  ```


  Error Responses


   * Status `422 Unprocessable Entity`: The request is missing the PIN.

  ```json
    { "error": "Missing PIN" }
  ```

   * Status `404 Not Found`: The PIN does not correspond to a valid user.

  ```json
    { "error": "Invalid PIN. User not found." }
  ```


  ---

  Step 2: Verify the OTP and Get JWT Token


  After the user enters the OTP they received, your app sends it along with the original PIN to get an authentication token.

   * Endpoint: POST /v2/api/login/verify-otp
   * Content-Type: application/json

  Request Body

  The request body must include both the user's PIN and the OTP they received.


  ```json
   {
     "pin": "1234",
     "otp": "123456"
   }
  ```


  Success Response (Status `200 OK`)


  If the OTP is correct and not expired, the server will return a JWT token and business information. Your mobile app should save this token securely for authenticating subsequent API calls.


  ```json
   {
       "success": true,
       "token": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
       "businessId": 1,
       "businessName": "Example Business",
       "userId": "1234"
   }
  ```

  Error Responses

   * Status `401 Unauthorized`: The OTP is incorrect or has expired.

  ```json
    { "error": "Invalid OTP or OTP expired." }
  ```

   * Status `422 Unprocessable Entity`: The request is missing the PIN or OTP.

  ```json
    { "error": "Missing OTP" }
  ```

   * Status `404 Not Found`: The business associated with the PIN could not be found.

  ```json
    { "error": "Business not found for PIN." }
  ```