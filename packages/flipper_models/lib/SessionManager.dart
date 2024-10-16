import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';

import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart' as amplify;

class SessionManager {
  DateTime? _lastAuthCheck;
  bool _isAuthenticated = false;
  final Duration _sessionDuration = Duration(hours: 1); // Adjust as needed

  Future<bool> isAuthenticated() async {
    if (_lastAuthCheck == null ||
        DateTime.now().difference(_lastAuthCheck!) > _sessionDuration) {
      await _refreshAuthStatus();
    }
    return _isAuthenticated;
  }

  Future<void> _refreshAuthStatus() async {
    try {
      final result = await amplify.Amplify.Auth.fetchAuthSession();
      _isAuthenticated = result.isSignedIn;
      _lastAuthCheck = DateTime.now();
    } catch (e) {
      talker.error('Error refreshing auth status: $e');
      _isAuthenticated = false;
    }
  }

  Future<void> signIn(String identifier) async {
    try {
      if (_isAuthenticated) {
        talker.warning('User is already signed in.');
        return;
      }

      final signInResult = await amplify.Amplify.Auth.signIn(
        username: identifier,
        password: identifier,
      );

      _isAuthenticated = signInResult.isSignedIn;
      _lastAuthCheck = DateTime.now();
      if (_isAuthenticated) {
        talker.warning('User logged in successfully');
      } else {
        talker.warning('Login not complete. Additional steps required.');
      }
    } catch (e) {
      talker.error('Error during sign in: $e');
      if (e is amplify.InvalidStateException ||
          e.toString().contains('Failed to authenticate')) {
        await amplify.Amplify.Auth.signOut();
        talker.warning('Forced sign-out due to authentication error.');
      }
    }
  }
}
