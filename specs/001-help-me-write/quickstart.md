# Quickstart: PIN Login End-to-End Test (Flutter Web)

This document outlines the manual steps to verify the complete PIN login feature in a web browser.

## Scenario 1: Successful Login with SMS OTP

1.  **Navigate** to the web application URL.
2.  **Enter a valid PIN**.
3.  The application should prompt you to choose a second factor. **Click "SMS"**.
4.  You will receive an OTP via SMS. **Enter the received OTP** into the input field.
5.  **Verification**: Confirm that you are successfully logged in and redirected to the main dashboard.

## Scenario 2: Successful Login with Authenticator App

1.  **Log out** if you are already logged in.
2.  **Navigate** to the web application URL.
3.  **Enter a valid PIN**.
4.  The application should prompt you to choose a second factor. **Click "Authenticator"**.
5.  Open your authenticator application. **Enter the current TOTP** into the input field.
6.  **Verification**: Confirm that you are successfully logged in and redirected to the main dashboard.