# Ditto Live Integration in Flipper

This document outlines the implementation of Ditto Live for offline data synchronization in Flipper.

## Overview

Ditto Live is used to store and synchronize user profile data between devices, allowing for offline access to critical user information. The implementation consists of:

1. **UserProfile Model** - Data model for user profiles
2. **DittoService** - Service for interacting with Ditto Live
3. **UserRepository** - Repository connecting the API with Ditto Live

## Setup

### Dependencies

Add the ditto_live dependency to your pubspec.yaml:

```yaml
dependencies:
  ditto_live: ^4.12.1
```

### Configuration

Ensure you have the appropriate platform-specific configurations:

#### Android

Add the following permissions to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

#### iOS

Add the following to your `Info.plist`:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth is used to connect and sync data with nearby devices</string>
<key>NSLocalNetworkUsageDescription</key>
<string>Local network is used to connect and sync data with nearby devices</string>
<key>NSBonjourServices</key>
<array>
    <string>_http._tcp</string>
</array>
```

## Usage

### Initialize Ditto

Ditto should be initialized at app startup:

```dart
final dittoService = ref.read(dittoServiceProvider);
await dittoService.initialize();
```

### Fetch and Save User Profile

After user authentication, fetch and save the user profile:

```dart
final userRepo = ref.read(userRepositoryProvider);
final userProfile = await userRepo.fetchAndSaveUserProfile(authToken);
```

### Get User Profile Locally

Access user data offline:

```dart
final userRepo = ref.read(userRepositoryProvider);
final userProfile = await userRepo.getCurrentUserProfile(userId);
```

### Listen to User Profile Changes

Listen for changes from other devices:

```dart
final userRepo = ref.read(userRepositoryProvider);
userRepo.userProfilesStream.listen((profiles) {
  // Handle updated profiles
});
```

## Architecture

### Models

- `UserProfile`: Represents a user's profile data, including tenants, businesses, and branches.

### Services

- `DittoService`: Manages the connection to Ditto Live and provides methods for CRUD operations on user profiles.

### Repositories

- `UserRepository`: Mediates between the API and Ditto Live, fetching user data from the server and storing it locally.

## Testing

The implementation includes tests for:

1. Model serialization/deserialization
2. Repository methods for fetching and saving data
3. Service methods for interacting with Ditto

## Example Implementation

See the `UserProfilePage` widget for an example of how to use the implementation in a UI context.

## Future Improvements

1. Add synchronization for other data types (transactions, inventory, etc.)
2. Implement conflict resolution strategies
3. Add encryption for sensitive data
4. Optimize synchronization to reduce bandwidth usage