# Feature: Default Application Selection

## Summary

This feature allows users to select a default application to launch after logging in and selecting a business/branch. This provides a more streamlined experience by taking them directly to their most-used part of the application.

## User Story

As a user, after I select my branch during login, I want to be prompted to choose a default application (e.g., POS, Inventory, Reports). Once I set a default, the system should remember my choice for future logins.

If I select "POS" as my default application, the system should then check if I have an open shift. If I don't, it should prompt me to open one before I can proceed, maintaining the existing workflow.

## Implementation Details

### 1. Triggering the Selection

- The prompt to choose a default app should appear within the `LoginChoices` widget (`packages/flipper_dashboard/lib/login_choices.dart`).
- This should happen immediately after a user successfully selects a branch in the `_handleBranchSelection` method.
- The prompt should only appear if a default application has not been set previously.

### 2. The "Choose Default App" Prompt

- A dialog will be presented to the user with a list of available applications to set as default.
- Tentative list of apps:
    - **POS (Point of Sale)**
    - **Inventory**
    - **Reports**
    - **Settings**
- The UI should be clear and easy to use.

### 3. Storing the Preference

- The user's choice for the default application will be stored locally using `ProxyService.box`.
- A new key, `defaultApp`, will be used to store the selected app's identifier (e.g., 'POS', 'Inventory').

### 4. Modifying the Login Flow

- In `_handleBranchSelection` of `login_choices.dart`:
    1. After setting the default branch (`_setDefaultBranch`).
    2. Check if `ProxyService.box.readString(key: 'defaultApp')` is null.
    3. If it is null, show the "Choose Default App" dialog.
    4. Save the user's selection.
    5. **If the selected default app is 'POS'**: Proceed with the existing logic to check for an active shift (`ProxyService.strategy.getCurrentShift`).
    6. **If another app is selected**: For now, the flow will continue as it does currently, navigating to the main `FlipperAppRoute`. Future work can route to the specific app's screen.

### 5. Impact on Existing Code

- **`packages/flipper_dashboard/lib/login_choices.dart`**: This file will be modified to include the new dialog and logic.
- A new dialog will likely be added to `flipper_routing/app.dialogs.dart` and its builder in `flipper_routing/app.router.dart`.
