// lib/features/totp/providers/totp_notifier.dart
import 'package:flipper_auth/core/providers.dart';
import 'package:flipper_auth/core/services/totp_service.dart';
import 'package:flipper_auth/features/auth/repositories/account_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

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
class TOTPNotifier extends StateNotifier<TOTPState> {
  final AccountRepository _accountRepository;
  final TOTPService _totpService;

  TOTPNotifier(this._accountRepository, this._totpService)
      : super(const TOTPState());

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

  String generateCode(String secret) {
    return _totpService.generateTOTPCode(secret);
  }
}

// TOTP Notifier Provider
final totpNotifierProvider =
    StateNotifierProvider<TOTPNotifier, TOTPState>((ref) {
  final accountRepository = ref.watch(accountRepositoryProvider);
  final totpService = ref.watch(totpServiceProvider);
  return TOTPNotifier(accountRepository, totpService);
});
