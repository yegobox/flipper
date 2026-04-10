import 'package:flipper_dashboard/features/services_gigs/services/service_gig_admin_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final servicesGigAdminProvider = FutureProvider.family<bool, String>((
  ref,
  userId,
) async {
  final repo = ServiceGigAdminRepository();
  return repo.isEnabledAdmin(userId: userId);
});

