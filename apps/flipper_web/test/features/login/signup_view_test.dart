import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_web/features/login/signup_view.dart';
import 'package:flipper_web/features/login/signup_providers.dart';
import 'package:flipper_web/repositories/signup_repository.dart';
import 'package:flipper_web/models/business_type.dart';
import 'package:flipper_web/widgets/app_button.dart';

// Mock repository for testing
class MockSignupRepository extends SignupRepository {
  bool checkUsernameResult = true;
  Map<String, dynamic> registerUserResult = {};
  String? errorMessage;

  List<String> checkedUsernames = [];
  List<RegisteredUser> registeredUsers = [];

  @override
  Future<bool> checkUsernameAvailability(String username) async {
    checkedUsernames.add(username);
    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
    return checkUsernameResult;
  }

  @override
  Future<Map<String, dynamic>> registerBusiness({
    required String username,
    required String fullName,
    required String businessTypeId,
    required String tinNumber,
    required String country,
    String? phoneNumber,
    Object? userId,
  }) async {
    registeredUsers.add(
      RegisteredUser(
        username: username,
        fullName: fullName,
        businessTypeId: businessTypeId,
        tinNumber: tinNumber,
        country: country,
        phoneNumber: phoneNumber,
        userId: userId,
      ),
    );

    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
    return registerUserResult;
  }
}

class RegisteredUser {
  final String username;
  final String fullName;
  final String businessTypeId;
  final String tinNumber;
  final String country;
  final String? phoneNumber;
  final Object? userId;

  RegisteredUser({
    required this.username,
    required this.fullName,
    required this.businessTypeId,
    required this.tinNumber,
    required this.country,
    this.phoneNumber,
    this.userId,
  });
}

// Custom test wrapper that provides the overriden providers
class TestWrapper extends StatelessWidget {
  final Widget child;
  final MockSignupRepository mockRepository;

  const TestWrapper({
    super.key,
    required this.child,
    required this.mockRepository,
  });

  @override
  Widget build(BuildContext context) {
    // Use a MediaQuery to set a specific size for testing
    // Make sure it's narrow enough to trigger the mobile layout
    return ProviderScope(
      overrides: [
        signupRepositoryProvider.overrideWithValue(mockRepository),
        businessTypesProvider.overrideWithValue([
          BusinessType(id: '1', typeName: 'Flipper Retailer'),
          BusinessType(id: '2', typeName: 'Individual'),
        ]),
        countriesProvider.overrideWithValue(['Rwanda', 'Kenya', 'Uganda']),
      ],
      child: MaterialApp(
        // Use a test-appropriate theme to avoid layout issues
        theme: ThemeData(
          visualDensity: VisualDensity.compact,
          inputDecorationTheme: const InputDecorationTheme(
            // Reduce content padding to avoid overflow
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            isDense: true,
          ),
        ),
        home: MediaQuery(
          // Set a narrow screen size to ensure mobile layout
          data: const MediaQueryData(
            size: Size(
              700,
              1000,
            ), // Width less than 768 to trigger mobile layout
            devicePixelRatio: 1.0,
            padding: EdgeInsets.zero,
          ),
          child: Scaffold(body: child),
        ),
      ),
    );
  }
}

void main() {
  late MockSignupRepository mockRepository;

  setUp(() {
    mockRepository = MockSignupRepository();
    // Make sure we have a binding instance
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('SignupView UI', () {
    testWidgets('renders form fields correctly', (tester) async {
      // Set a narrower surface size to ensure mobile layout
      await tester.binding.setSurfaceSize(const Size(700, 1000));

      // Build the signup view
      await tester.pumpWidget(
        TestWrapper(mockRepository: mockRepository, child: const SignupView()),
      );

      // Verify header is displayed
      expect(find.text('Join Flipper and grow your business'), findsOneWidget);

      // Check for fields using more reliable finders
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Business Type'), findsOneWidget);
      expect(find.text('TIN Number'), findsOneWidget);
      expect(find.text('Country'), findsOneWidget);

      // Check for AppButton
      expect(find.byType(AppButton), findsOneWidget);

      // Check for sign in link
      expect(find.text('Already have an account? Sign in'), findsOneWidget);
    });

    testWidgets('shows validation errors when submitting empty form', (
      tester,
    ) async {
      // Set a narrower surface size to ensure mobile layout
      await tester.binding.setSurfaceSize(const Size(700, 1000));

      // Build the signup view with a larger test surface
      await tester.pumpWidget(
        TestWrapper(mockRepository: mockRepository, child: const SignupView()),
      );

      // Force validation by calling validate on the form without submitting
      // This is more reliable in tests than tapping the submit button
      tester.state<FormState>(find.byType(Form)).validate();
      await tester.pump();

      // Check for validation error messages
      expect(find.text('Username is required'), findsOneWidget);
      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Please select a business type'), findsOneWidget);
      expect(find.text('TIN number is required'), findsOneWidget);
    });
  });

  group('Username availability', () {
    testWidgets('shows availability indicators when typing username', (
      tester,
    ) async {
      // Set a narrower surface size to ensure mobile layout
      await tester.binding.setSurfaceSize(const Size(700, 1000));

      // Configure mock repository
      mockRepository.checkUsernameResult = true;

      // Build the signup view
      await tester.pumpWidget(
        TestWrapper(mockRepository: mockRepository, child: const SignupView()),
      );

      // Find username field - usually the first text field
      // Enter a username
      await tester.enterText(find.byType(TextFormField).first, 'test_user');
      await tester.pumpAndSettle();

      // Wait for the debounce timer
      await tester.pump(const Duration(milliseconds: 600));

      // Now check that the repository was called
      expect(mockRepository.checkedUsernames, contains('test_user'));

      // Check for the availability icon (green check)
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows unavailable indicator when username is taken', (
      tester,
    ) async {
      // Set a narrower surface size to ensure mobile layout
      await tester.binding.setSurfaceSize(const Size(700, 1000));

      // Configure mock repository
      mockRepository.checkUsernameResult = false;

      // Build the signup view
      await tester.pumpWidget(
        TestWrapper(mockRepository: mockRepository, child: const SignupView()),
      );

      // Enter a username
      await tester.enterText(find.byType(TextFormField).first, 'taken_user');
      await tester.pumpAndSettle();

      // Wait for the debounce timer
      await tester.pump(const Duration(milliseconds: 600));

      // Now check that the repository was called
      expect(mockRepository.checkedUsernames, contains('taken_user'));

      // Check for the unavailability icon (red x)
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });
  });
}
