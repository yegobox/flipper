import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Example controller that demonstrates how to use the UserRepository
/// to fetch and save user profiles from the API and Ditto
class UserProfileController extends StateNotifier<AsyncValue<UserProfile?>> {
  final UserRepository _userRepository;

  UserProfileController(this._userRepository)
    : super(const AsyncValue.loading());

  /// Fetch user profile from API and save to Ditto
  Future<void> fetchUserProfile(Session session) async {
    try {
      state = const AsyncValue.loading();
      final userProfile = await _userRepository.fetchAndSaveUserProfile(
        session,
      );
      state = AsyncValue.data(userProfile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Get cached user profile from Ditto
  Future<void> getCachedUserProfile(String userId) async {
    try {
      state = const AsyncValue.loading();
      final userProfile = await _userRepository.getCurrentUserProfile(userId);
      state = AsyncValue.data(userProfile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Listen to changes in user profiles from other devices
  Stream<List<UserProfile>> get userProfilesStream =>
      _userRepository.userProfilesStream;
}

/// Provider for the user profile controller
final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, AsyncValue<UserProfile?>>((
      ref,
    ) {
      final userRepository = ref.watch(userRepositoryProvider);
      return UserProfileController(userRepository);
    });

/// Example widget that demonstrates how to use the UserProfileController
class UserProfilePage extends ConsumerWidget {
  final Session session;

  const UserProfilePage({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the user profile state
    final userProfileState = ref.watch(userProfileControllerProvider);

    // Fetch the user profile when the page loads
    ref.read(userProfileControllerProvider.notifier).fetchUserProfile(session);

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: userProfileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (userProfile) {
          if (userProfile == null) {
            return const Center(child: Text('No user profile found'));
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'ID: ${userProfile.id}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Phone: ${userProfile.phoneNumber}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16.0),
              Text('Tenants', style: Theme.of(context).textTheme.titleMedium),
              ...userProfile.tenants.map(
                (tenant) => Card(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${tenant.name}'),
                        Text('Type: ${tenant.type}'),
                        const SizedBox(height: 8.0),
                        Text('Businesses: ${tenant.businesses.length}'),
                        Text('Branches: ${tenant.branches.length}'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
