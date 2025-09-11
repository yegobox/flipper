
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState {
  unauthenticated,
  authenticated,
}

final authStateProvider = StateProvider<AuthState>((ref) {
  return AuthState.unauthenticated;
});
