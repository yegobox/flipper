# Ditto Integration Guide for Flipper

This guide explains how to integrate the new Ditto Live functionality for offline data synchronization in Flipper.

## Implementation Overview

We've implemented:
1. A UserProfile model for storing user data
2. A DittoService for Ditto operations
3. A UserRepository for handling API and local storage operations
4. Integration with authentication flow

## Integration Steps

### 1. After User Login

Add this code to your authentication flow after successful login:

```dart
// After successful login
final userRepo = ref.read(userRepositoryProvider);
final userProfile = await userRepo.fetchAndSaveUserProfile(authToken);
```

This will fetch the user profile from the API and store it in Ditto for offline access.

### 2. Accessing User Profile Data Offline

To access the user profile when the app is offline:

```dart
final userRepo = ref.read(userRepositoryProvider);
final userProfile = await userRepo.getCurrentUserProfile(userId);

if (userProfile != null) {
  // Use the user profile data
} else {
  // Handle missing user data
}
```

### 3. Listen for Changes from Other Devices

To get real-time updates when data changes on other devices:

```dart
final userRepo = ref.read(userRepositoryProvider);
userRepo.userProfilesStream.listen((profiles) {
  // Handle updated profiles
});
```

### 4. Updating User Profile

To update the user profile:

```dart
final userRepo = ref.read(userRepositoryProvider);
final updatedProfile = await userRepo.updateUserProfile(
  userProfile, // Modified user profile
  authToken
);
```

## Existing Files

The following files have been added or modified:

### Models

- `/models/user_profile.dart` - User profile data model with nested tenant and business structures

### Services

- `/services/ditto_service.dart` - Service for interacting with Ditto Live
- `/services/auth_service.dart` - Service for authentication

### Repositories

- `/repositories/user_repository.dart` - Repository connecting API with Ditto

### UI Examples

- `/features/profile/user_profile_page.dart` - Example UI implementation
- `/features/auth/auth_manager.dart` - Example authentication integration

## Testing

Run the tests to ensure everything is working correctly:

```bash
cd apps/flipper_web
flutter test test/models/user_profile_test.dart
flutter test test/services/ditto_service_test.dart
flutter test test/repositories/user_repository_test.dart
```

## Next Steps

1. Add Ditto initialization to app startup:
   ```dart
   // In your app initialization
   final dittoService = ref.read(dittoServiceProvider);
   await dittoService.initialize();
   ```

2. Integrate with your authentication flow as shown in the `auth_manager.dart` example

3. Consider implementing synchronization for additional data types like transactions or inventory

4. Add more comprehensive error handling and retry mechanisms for offline scenarios

## Additional Resources

- Ditto documentation: https://docs.ditto.live/
- Flutter Riverpod documentation: https://riverpod.dev/docs