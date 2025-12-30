# Signup Flow Documentation

This document outlines the user registration (signup) flow for the Flipper application.

## 1. User Interface (`SignUpView`)

The signup process begins on the `SignUpView`, which presents the user with a form to collect necessary information.

- **Form Fields**:
  - **Username**: The desired username for the account.
  - **Full Name**: The user's full name.
  - **Phone Number**: The user's mobile phone number. The country dial code is automatically added based on the selected country.
  - **Usage (Business Type)**: A dropdown to select the type of business:
    - Flipper Retailer
    - Individual
    - Enterprise
  - **Country**: A dropdown to select the country of operation (e.g., Zambia, Mozambique, Rwanda).
  - **TIN Number**: A field for the Taxpayer Identification Number. This field is only visible if the selected "Usage" is not "Individual".

- **User Interaction**:
  - As the user types a username, the system performs real-time asynchronous validation to check if the username is already taken.
  - When the user selects a country, the phone number field is automatically updated with the correct international dial code.
  - Upon clicking the "Create Account" button, the form submission process is initiated.

## 2. Form Logic (`AsyncFieldValidationFormBloc`)

The `AsyncFieldValidationFormBloc` is responsible for managing the form's state, validation, and submission.

- **Submission Trigger**: When the form is submitted, the `onSubmitting` method is called.

- **Process**:
  1.  It activates a loading state to provide visual feedback to the user.
  2.  The data from the form fields (`username`, `fullName`, `phoneNumber`, `country`, `tinNumber`, `businessType`) is collected and passed to the `SignupViewModel`.
  3.  If the business type is "Individual" or the TIN field is left empty, a default TIN (`999909695`) is used.
  4.  It then invokes the `signup()` method on the `SignupViewModel`.
  5.  **On Success**: If the `signup()` method completes without errors, the user is navigated to the main application startup view (`StartUpViewRoute`).
  6.  **On Failure**: If an error occurs, the loading state is stopped, and a failure message is emitted.

## 3. Business Logic (`SignupViewModel`)

The `SignupViewModel` contains the core business logic for the registration process.

- **`signup()` Method**:
  1.  **User Identification**: It first attempts to retrieve the user's `userId` from local storage.
  2.  **User Creation/Retrieval**: If no `userId` is found, it makes an API call to the backend endpoint (`v2/api/user`) with the user's phone number. This endpoint either creates a new user or retrieves the existing user associated with that phone number and returns a `userId`. The `userId` is then saved to local storage.
  3.  **Business Data Compilation**: It constructs a `businessMap` object containing all the details required to create a new business account. This map includes:
      - `name` (the username)
      - `fullName`
      - `country`
      - `tinNumber`
      - `type` (the business type)
      - `phoneNumber`
      - `userId`
      - Other default values like `currency`, `latitude`, `longitude`, etc.
  4.  **Final API Call**: The `businessMap` is passed to `ProxyService.strategy.signup`, which makes the final API request to the backend to create the business profile linked to the user's account.
  5.  **Error Handling**: If any part of this process fails (e.g., network error, API error), it displays an error notification to the user and re-throws the exception to be caught by the form bloc.
