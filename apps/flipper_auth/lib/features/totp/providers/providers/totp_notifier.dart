// lib/features/totp/providers/totp_notifier.dart
import 'package:flipper_auth/core/providers.dart';
import 'package:flipper_auth/core/services/totp_service.dart';
import 'package:flipper_auth/features/auth/repositories/account_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:equatable/equatable.dart';

part 'totp_notifier.g.dart';

// TOTP State
class TOTPState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<Map<String, dynamic>> accounts;

  const TOTPState({
    this.isLoading = false,
    this.error,
    this.accounts = const [],
  });

  TOTPState copyWith({
    bool? isLoading,
    String? error,
    List<Map<String, dynamic>>? accounts,
  }) {
    return TOTPState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      accounts: accounts ?? this.accounts,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, accounts];
}

// TOTP Notifier
@riverpod
class TOTPNotifier extends _$TOTPNotifier {
  AccountRepository get _accountRepository =>
      ref.read(accountRepositoryProvider);
  TOTPService get _totpService => ref.read(totpServiceProvider);

  @override
  TOTPState build() {
    return const TOTPState();
  }

  Future<void> loadAccounts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final accounts = await _accountRepository.fetchAccounts();
      state = state.copyWith(isLoading: false, accounts: accounts);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addAccount(Map<String, dynamic> account) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _accountRepository.addAccount(account);
      await loadAccounts(); // Reload accounts after adding
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  String generateCode(String secret, {required String provider}) {
    return _totpService.generateTOTPCode(secret,
        provider: provider, debug: false);
  }
}

// Compatibility alias
// Note: verify generated name, likely totpProvider if 'Notifier' suffix is stripped.
// If class matches TOTPNotifier -> totpProvider.
final totpNotifierProvider = tOTPProvider;
