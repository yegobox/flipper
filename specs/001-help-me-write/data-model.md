# Data Models for PIN Login

## User
Represents a user of the application.

**Fields**:
- `id`: `String` - Unique identifier for the user.
- `pin`: `String` - The user's PIN, which should be stored securely (e.g., hashed).
- `phoneNumber`: `String` (Optional) - The user's phone number for receiving SMS OTPs.
- `totpSecret`: `String` (Optional) - The secret key for generating TOTPs, shared with the user's authenticator app.

## AuthToken
Represents an authentication token provided to the user upon successful login.

**Fields**:
- `token`: `String` - The access token.
- `expiry`: `DateTime` - The token's expiration date and time.