
import 'dart:async';

import 'package:flipper_dashboard/features/ai/screens/ai_screen.dart';
import 'package:flipper_dashboard/features/ai/widgets/ai_input_field.dart';
import 'package:flipper_dashboard/features/ai/widgets/welcome_view.dart';
import 'package:flipper_models/providers/ai_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/models/ai_conversation.model.dart';
import 'package:supabase_models/brick/repository.dart';

import '../../../test_helpers/mocks.dart';
import '../../../test_helpers/setup.dart';

class MockRouterService extends Mock implements RouterService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEnvironment env;
  late MockDatabaseSync mockDbSync;
  late MockBox mockBox;
  late MockFlipperHttpClient mockFlipperHttpClient;
  late MockRouterService mockRouterService;
  late MockRepository mockRepository;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();

    mockDbSync = env.mockDbSync;
    mockBox = env.mockBox;
    mockFlipperHttpClient = env.mockFlipperHttpClient;
    mockRouterService = MockRouterService();
    mockRepository = MockRepository();

    // Register fallbacks for mocktail
    registerFallbackValue(models.Message(
      id: 'fallback_message',
      text: 'fallback',
      role: 'user',
      conversationId: 'fallback_conversation',
      branchId: 1,
      phoneNumber: '123',
      delivered: false,
    ));
    registerFallbackValue(models.BusinessAnalytic(
      id: 'fallback_analytic',
      branchId: 1,
      date: DateTime.now(),
      itemName: 'fallback',
      price: 0.0,
      profit: 0.0,
      unitsSold: 0,
      taxRate: 0.0,
      trafficCount: 0,
    ));
    registerFallbackValue(AiConversation(
      id: 'fallback_conversation',
      title: 'Fallback Conversation',
      branchId: 1,
      createdAt: DateTime.now(),
    ));
    registerFallbackValue(Uri());
    registerFallbackValue(MockBusiness());
    registerFallbackValue(FakeHttpClient());
    registerFallbackValue(MockPlan());
    registerFallbackValue(models.PaymentVerificationResponse(
      result: models.PaymentVerificationResult.active,
      isActive: true,
    ));
    registerFallbackValue(FlipperAppRoute());

    // Register mocks with getIt locator
    locator.registerSingleton<RouterService>(mockRouterService);
    locator.registerSingleton<Repository>(mockRepository);
  });

  setUp(() {
    reset(mockDbSync);
    reset(mockBox);
    reset(mockFlipperHttpClient);
    reset(mockRouterService);
    reset(mockRepository);

    env.injectMocks();
    env.stubCommonMethods();

    // Default mocks for ProxyService
    when(() => mockBox.getBranchId()).thenReturn(1);
    when(() => mockBox.getUserPhone()).thenReturn('123456789');
    when(() => mockDbSync.activeBusiness()).thenAnswer((_) async =>
        models.Business(id: '1', name: 'Test Business', serverId: 1));

    // Default mock for getConversations (empty list)
    when(() => mockDbSync.getConversations(
          branchId: any(named: 'branchId'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => []);

    // Default mock for createConversation
    when(() => mockDbSync.createConversation(
          title: any(named: 'title'),
          branchId: any(named: 'branchId'),
        )).thenAnswer((_) async => AiConversation(
          id: 'new_conversation_id',
          title: 'New Conversation',
          branchId: 1,
          createdAt: DateTime.now(),
        ));

    // Default mock for subscribeToMessages (empty stream)
    when(() => mockDbSync.subscribeToMessages(any()))
        .thenAnswer((_) => Stream.fromIterable([[]]));

    // Default mock for saveMessage
    when(() => mockDbSync.saveMessage(
          text: any(named: 'text'),
          phoneNumber: any(named: 'phoneNumber'),
          branchId: any(named: 'branchId'),
          role: any(named: 'role'),
          conversationId: any(named: 'conversationId'),
          aiResponse: any(named: 'aiResponse'),
          aiContext: any(named: 'aiContext'),
        )).thenAnswer((_) async => models.Message(
          id: 'saved_message_id',
          text: 'saved',
          role: 'user',
          conversationId: 'new_conversation_id',
          branchId: 1,
          phoneNumber: '123456789',
          delivered: false,
        ));

    // Default mock for geminiBusinessAnalyticsProvider
    when(() => mockRepository.subscribeToRealtime<models.BusinessAnalytic>(
          query: any(named: 'query'),
        )).thenAnswer((_) => Stream.fromIterable([[]]));
  });

  tearDown(() {
    // Clean up after each test if necessary
  });

  Widget _wrapWithMaterialApp(Widget widget) {
    return ProviderScope(
      child: MaterialApp(
        home: ScaffoldMessenger(
          child: widget,
        ),
      ),
    );
  }

  group('AiScreen Widget Tests', () {
    testWidgets('renders WelcomeView when no conversations exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(const AiScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(WelcomeView), findsOneWidget);
      expect(find.text('Start a new conversation'), findsOneWidget);
    });

    testWidgets('sends message and displays AI response',
        (WidgetTester tester) async {
      // Mock a non-empty conversation list to skip WelcomeView
      when(() => mockDbSync.getConversations(
            branchId: any(named: 'branchId'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [
            AiConversation(
              id: 'existing_conversation',
              title: 'Existing Conversation',
              branchId: 1,
              createdAt: DateTime.now(),
            )
          ]);
      when(() => mockDbSync.subscribeToMessages('existing_conversation'))
          .thenAnswer((_) => Stream.fromIterable([
                [
                  models.Message(
                    id: 'user_msg',
                    text: 'Hello',
                    role: 'user',
                    conversationId: 'existing_conversation',
                    branchId: 1,
                    phoneNumber: '123',
                    delivered: false,
                  )
                ]
              ]));

      // Mock the AI response
      when(() => geminiBusinessAnalyticsProvider(any(), any()).future)
          .thenAnswer((_) async => 'AI response text');

      await tester.pumpWidget(_wrapWithMaterialApp(const AiScreen()));
      await tester.pumpAndSettle();

      // Enter text into the input field
      await tester.enterText(find.byType(AiInputField), 'Hello AI');
      await tester.pumpAndSettle();

      // Tap the send button
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump(); // Start loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(); // End loading, show AI response

      // Verify user message and AI response are displayed
      expect(find.text('Hello AI'), findsOneWidget);
      expect(find.text('AI response text'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('displays error snackbar on message send failure',
        (WidgetTester tester) async {
      // Mock a non-empty conversation list
      when(() => mockDbSync.getConversations(
            branchId: any(named: 'branchId'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [
            AiConversation(
              id: 'existing_conversation',
              title: 'Existing Conversation',
              branchId: 1,
              createdAt: DateTime.now(),
            )
          ]);
      when(() => mockDbSync.subscribeToMessages('existing_conversation'))
          .thenAnswer((_) => Stream.fromIterable([[]]));

      // Mock AI response to throw an error
      when(() => geminiBusinessAnalyticsProvider(any(), any()).future)
          .thenThrow(Exception('AI service unavailable'));

      await tester.pumpWidget(_wrapWithMaterialApp(const AiScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(AiInputField), 'Test message');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Error: Exception: AI service unavailable'),
          findsOneWidget);
    });

    testWidgets('selects conversation from drawer', (WidgetTester tester) async {
      // Mock multiple conversations
      when(() => mockDbSync.getConversations(
            branchId: any(named: 'branchId'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [
            AiConversation(
              id: 'conv1',
              title: 'Conversation 1',
              branchId: 1,
              createdAt: DateTime.now(),
            ),
            AiConversation(
              id: 'conv2',
              title: 'Conversation 2',
              branchId: 1,
              createdAt: DateTime.now(),
            ),
          ]);
      when(() => mockDbSync.getMessagesForConversation(
            conversationId: 'conv1',
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [
            models.Message(
              id: 'msg1',
              text: 'Message from Conv1',
              role: 'user',
              conversationId: 'conv1',
              branchId: 1,
              phoneNumber: '123',
              delivered: false,
            )
          ]);
      when(() => mockDbSync.getMessagesForConversation(
            conversationId: 'conv2',
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [
            models.Message(
              id: 'msg2',
              text: 'Message from Conv2',
              role: 'user',
              conversationId: 'conv2',
              branchId: 1,
              phoneNumber: '123',
              delivered: false,
            )
          ]);
      when(() => mockDbSync.subscribeToMessages('conv1'))
          .thenAnswer((_) => Stream.fromIterable([
                [
                  models.Message(
                    id: 'msg1',
                    text: 'Message from Conv1',
                    role: 'user',
                    conversationId: 'conv1',
                    branchId: 1,
                    phoneNumber: '123',
                    delivered: false,
                  )
                ]
              ]));
      when(() => mockDbSync.subscribeToMessages('conv2'))
          .thenAnswer((_) => Stream.fromIterable([
                [
                  models.Message(
                    id: 'msg2',
                    text: 'Message from Conv2',
                    role: 'user',
                    conversationId: 'conv2',
                    branchId: 1,
                    phoneNumber: '123',
                    delivered: false,
                  )
                ]
              ]));

      await tester.pumpWidget(_wrapWithMaterialApp(const AiScreen()));
      await tester.pumpAndSettle();

      // Open the drawer
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();

      // Tap on 'Conversation 2'
      await tester.tap(find.text('Conversation 2'));
      await tester.pumpAndSettle();

      // Verify messages from Conversation 2 are displayed
      expect(find.text('Message from Conv2'), findsOneWidget);
      expect(find.text('Message from Conv1'), findsNothing);
    });

    testWidgets('deletes current conversation and starts new one if no others',
        (WidgetTester tester) async {
      // Mock a single conversation
      when(() => mockDbSync.getConversations(
            branchId: any(named: 'branchId'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [
            AiConversation(
              id: 'single_conv',
              title: 'Single Conversation',
              branchId: 1,
              createdAt: DateTime.now(),
            )
          ]);
      when(() => mockDbSync.getMessagesForConversation(
            conversationId: 'single_conv',
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => []);
      when(() => mockDbSync.subscribeToMessages('single_conv'))
          .thenAnswer((_) => Stream.fromIterable([[]]));

      // Mock deleteConversation
      when(() => mockDbSync.deleteConversation('single_conv'))
          .thenAnswer((_) async => Future.value());

      // Mock createConversation for the new one
      when(() => mockDbSync.createConversation(
            title: any(named: 'title'),
            branchId: any(named: 'branchId'),
          )).thenAnswer((_) async => AiConversation(
            id: 'new_conv_after_delete',
            title: 'New Conversation',
            branchId: 1,
            createdAt: DateTime.now(),
          ));
      when(() => mockDbSync.subscribeToMessages('new_conv_after_delete'))
          .thenAnswer((_) => Stream.fromIterable([[]]));

      await tester.pumpWidget(_wrapWithMaterialApp(const AiScreen()));
      await tester.pumpAndSettle();

      // Open the drawer
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();

      // Tap delete icon for the single conversation
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Verify delete was called
      verify(() => mockDbSync.deleteConversation('single_conv')).called(1);

      // Verify WelcomeView is shown for the new conversation
      expect(find.byType(WelcomeView), findsOneWidget);
      expect(find.text('Start a new conversation'), findsOneWidget);
    });

    testWidgets('analytics stream is subscribed on build',
        (WidgetTester tester) async {
      final branchId = ProxyService.box.getBranchId();
      expect(branchId, isNotNull); // Ensure branchId is available for the test

      // Mock the streamRemoteAnalytics to return a controlled stream
      final analyticsController = StreamController<List<models.BusinessAnalytic>>();
      when(() => mockDbSync.streamRemoteAnalytics(branchId: branchId!))
          .thenAnswer((_) => analyticsController.stream);

      await tester.pumpWidget(_wrapWithMaterialApp(const AiScreen()));
      await tester.pumpAndSettle();

      // Verify that streamRemoteAnalytics was called
      verify(() => mockDbSync.streamRemoteAnalytics(branchId: branchId!)).called(1);

      // Emit some data to the stream
      analyticsController.add([
        models.BusinessAnalytic(
          id: 'analytic1',
          branchId: branchId!,
          date: DateTime.now(),
          itemName: 'Item A',
          price: 10.0,
          profit: 5.0,
          unitsSold: 10,
          taxRate: 0.1,
          trafficCount: 1,
        )
      ]);
      await tester.pumpAndSettle(); // Allow stream listener to process

      // You can add more specific assertions here if the UI reacts to analytics data
      // For now, we just verify the subscription happened.

      await analyticsController.close();
    });
  });
}
