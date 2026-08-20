import 'package:flipper_hr/features/session/data/hr_account_repository.dart';
import 'package:flipper_hr/features/session/data/hr_identity.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The `public.users` reader. Overridden with a fake in tests.
final hrAccountRepositoryProvider = Provider<HrAccountRepository>((ref) {
  return SupabaseHrAccountRepository(Supabase.instance.client);
});

/// The signed-in person's name, for the chrome.
///
/// Resolved once per session and cached — it labels an avatar, so it must be
/// cheap and it must not change under the person reading it.
///
/// Never fails: every source is optional and the fallbacks run to the login
/// number, because an account menu that shows an error is worse than one that
/// shows a phone number. Retry is off for the same reason the rest of HR turns
/// it off — Riverpod 3 would otherwise keep re-reading `users` behind a shell
/// that has already settled on a label.
final hrIdentityProvider = FutureProvider<HrIdentity>((ref) async {
  UserProfile? profile;
  try {
    profile = await ref.watch(currentUserProfileProvider.future);
  } catch (_) {
    profile = null;
  }

  final identityKeys = ref.watch(hrSessionProvider).value?.identityKeys ?? const [];
  final account = identityKeys.isEmpty
      ? null
      : await ref.watch(hrAccountRepositoryProvider).fetchAccount(
          identityKeys: identityKeys,
        );

  // Their own roster row, when they have one. Already fetched for the leave
  // page, so for staff this is a cache hit rather than a second round trip.
  String? employeeName;
  try {
    employeeName = (await ref.watch(myEmployeeProvider.future))?.fullName;
  } catch (_) {
    employeeName = null;
  }

  return resolveHrIdentity(
    accountName: account?.name,
    employeeName: employeeName,
    tenantName: _tenantNameOf(profile),
    businessName: ref.watch(selectedBusinessProvider)?.name,
    email: account?.email,
    phone: account?.phoneNumber ?? profile?.phoneNumber,
  );
}, retry: (retryCount, error) => null);

/// What the shell shows while [hrIdentityProvider] is still resolving, and if it
/// somehow never does.
final hrIdentityOrUnknownProvider = Provider<HrIdentity>((ref) {
  return ref.watch(hrIdentityProvider).value ?? HrIdentity.unknown;
});

String? _tenantNameOf(UserProfile? profile) {
  if (profile == null || profile.tenants.isEmpty) return null;
  for (final tenant in profile.tenants) {
    final name = tenant.name.trim();
    if (name.isNotEmpty) return name;
  }
  return null;
}
