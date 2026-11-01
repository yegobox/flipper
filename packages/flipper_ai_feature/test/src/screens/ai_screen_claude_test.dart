import 'dart:async';

import 'package:flipper_ai_feature/src/claude/claude_cli_runner.dart';
import 'package:flipper_ai_feature/src/claude/claude_cli_status.dart';
import 'package:flipper_ai_feature/src/claude/claude_consent.dart';
import 'package:flipper_ai_feature/src/models/flo_ai_mode.dart';
import 'package:flipper_ai_feature/src/providers/conversation_provider.dart';
import 'package:flipper_ai_feature/src/providers/whatsapp_connection_provider.dart';
import 'package:flipper_ai_feature/src/providers/whatsapp_message_provider.dart';
import 'package:flipper_ai_feature/src/screens/ai_screen.dart';
import 'package:flipper_ai_feature/src/services/whatsapp_connection_service.dart';
import 'package:flipper_ai_feature/src/widgets/flo/flo_composer.dart';
import 'package:flipper_ai_feature/src/widgets/flo/flo_model_selector.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flipper_models/providers/local_inference_engine.dart';
import 'package:flipper_models/sync/capella/capella_sync.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/whatsapp_message_sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/models/conversation.model.dart';

import '../../helpers/mocks.dart';

class _FakeRunner implements ClaudeCliRunner {
  _FakeRunner(this.status);

  ClaudeCliStatus status;
  final prompts = <String>[];

  @override
  Future<ClaudeCliStatus> detect() async => status;

  @override
  Future<String> ask({
    required String executable,
    required String systemPrompt,
    required String prompt,
    Duration timeout = const Duration(minutes: 2),
  }) async {
    prompts.add(prompt);
    return 'Claude says hi.';
  }
}

class _MockCapella extends Mock implements CapellaSync {}

/// Ready on-device engine without RAG that records its prompts.
class _EchoEngine implements LocalInferenceEngine {
  final prompts = <String>[];

  @override
  bool get isSupported => true;

  @override
  bool get isReady => true;

  @override
  bool get supportsRag => false;

  @override
  Stream<String> generate(String prompt,
      {double? temperature, int? maxTokens}) async* {
    prompts.add(prompt);
    yield 'Local says hi.';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Keeps the WhatsApp providers inert (no Ditto, no network).
class _IdleWaSync extends StateNotifier<AsyncValue<WhatsAppSyncState>>
    implements WhatsAppMessageSyncNotifier {
  _IdleWaSync() : super(const AsyncValue.loading());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _IdleWaConnection
    extends StateNotifier<AsyncValue<WhatsAppConnectionState>>
    implements WhatsAppConnectionNotifier {
  _IdleWaConnection() : super(const AsyncValue.data(WhatsAppConnectionState()));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _ready = ClaudeCliStatus(
  ClaudeCliState.ready,
  executable: '/usr/bin/claude',
  account: 'owner@shop.rw',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  setupPathProviderMock();

  // Only mocks go into the locator: no Repository/sqlite is opened, so this
  // file can run alongside ai_screen_test.dart without a database lock.
  final strategy = MockSyncStrategy();
  final db = MockDatabaseSync();
  final box = MockBox();
  late _MockCapella capella;
  late _FakeRunner runner;
  String? branchId;

  final l10n = lookupFlipperAppLocalizations(const Locale('en'));

  void put<T extends Object>(T value, {String? name}) {
    if (getIt.isRegistered<T>(instanceName: name)) {
      getIt.unregister<T>(instanceName: name);
    }
    getIt.registerSingleton<T>(value, instanceName: name);
  }

  setUpAll(() {
    registerFallbackValue(
      Conversation(id: 'f', title: 'f', branchId: '', createdAt: DateTime(0)),
    );
    put<SyncStrategy>(strategy, name: 'strategy');
    put<LocalStorage>(box);
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    when(() => strategy.current).thenReturn(db);
    // No branch while the screen boots so the briefing loaders stay idle;
    // tests set one before sending.
    branchId = null;
    when(() => box.getBranchId()).thenAnswer((_) => branchId);
    when(() => box.getBusinessId()).thenReturn(null);
    when(() => box.getUserPhone()).thenReturn('250788000000');

    capella = _MockCapella();
    when(() => strategy.getStrategy(Strategy.capella)).thenReturn(capella);
    when(
      () => capella.transactionsStream(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        branchId: any(named: 'branchId'),
        skipOriginalTransactionCheck:
            any(named: 'skipOriginalTransactionCheck'),
        removeAdjustmentTransactions:
            any(named: 'removeAdjustmentTransactions'),
        forceRealData: any(named: 'forceRealData'),
      ),
    ).thenAnswer((_) => Stream.value(<models.ITransaction>[]));

    clearInteractions(db);
    when(
      () => db.createConversation(
        title: any(named: 'title'),
        branchId: any(named: 'branchId'),
        useCase: any(named: 'useCase'),
      ),
    ).thenAnswer(
      (_) async => Conversation(
        id: 'conv-1',
        title: 'New Conversation',
        branchId: '1',
        createdAt: DateTime(2026),
      ),
    );
    when(() => db.subscribeToMessages(any()))
        .thenAnswer((_) => const Stream.empty());
    when(
      () => db.saveMessage(
        text: any(named: 'text'),
        phoneNumber: any(named: 'phoneNumber'),
        branchId: any(named: 'branchId'),
        role: any(named: 'role'),
        conversationId: any(named: 'conversationId'),
        aiResponse: any(named: 'aiResponse'),
        aiContext: any(named: 'aiContext'),
        messageSource: any(named: 'messageSource'),
      ),
    ).thenAnswer(
      (_) async => models.Message(
        text: 'saved',
        role: 'user',
        conversationId: 'conv-1',
        branchId: '1',
        phoneNumber: '250788000000',
        delivered: true,
      ),
    );
    when(() => db.updateConversation(any())).thenAnswer(
      (i) async => i.positionalArguments.first as Conversation,
    );
  });

  Future<void> pumpScreen(WidgetTester tester, ClaudeCliStatus status) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    runner = _FakeRunner(status);
    ClaudeCli.runner = runner;
    await ClaudeCli.status(refresh: true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          defaultAiModelProvider.overrideWith((ref) async => null),
          whatsappMessageSyncProvider.overrideWith((ref) => _IdleWaSync()),
          whatsAppConnectionStateProvider
              .overrideWith((ref) => _IdleWaConnection()),
          conversationProvider.overrideWith(
            (ref) => Stream.value([
              Conversation(
                id: 'conv-1',
                title: 'New Conversation',
                branchId: '1',
                createdAt: DateTime(2026),
              ),
            ]),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: const AiScreen(),
        ),
      ),
    );
    // Post-frame loaders, then past the delayed briefing fetch.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  FloModelSelector selector(WidgetTester tester) =>
      tester.widget<FloModelSelector>(find.byType(FloModelSelector).first);

  Future<void> pick(WidgetTester tester, String title) async {
    await tester.tap(find.byType(FloModelSelector).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(title).last);
    await tester.pumpAndSettle();
  }

  Future<void> ask(WidgetTester tester, String question) async {
    branchId = '1';
    await tester.enterText(find.byType(TextField), question);
    tester.widget<FloComposer>(find.byType(FloComposer)).onSend();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  /// The assistant reply stored for [question].
  String savedReply(String question) => verify(
        () => db.saveMessage(
          text: any(named: 'text'),
          phoneNumber: any(named: 'phoneNumber'),
          branchId: '1',
          role: 'assistant',
          conversationId: 'conv-1',
          aiResponse: captureAny(named: 'aiResponse'),
          aiContext: question,
          messageSource: 'ai',
        ),
      ).captured.single as String;

  /// Lets a snack bar run out so no timers outlive the test.
  Future<void> drainSnackBar(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  }

  testWidgets('a CLI the platform cannot run hides the Claude option',
      (tester) async {
    await pumpScreen(tester, ClaudeCliStatus.unavailable);

    expect(LocalInferenceRegistry.isAvailable, isFalse);
    expect(selector(tester).claudeAvailable, isFalse);
    expect(selector(tester).mode, FloAiMode.cloud);
  });

  testWidgets('Claude needs consent; cancelling keeps the current mode',
      (tester) async {
    await pumpScreen(tester, _ready);
    expect(selector(tester).claudeAvailable, isTrue);

    await pick(tester, l10n.floModeClaude);
    expect(find.text(l10n.aiClaudeConsentTitle), findsOneWidget);
    expect(find.text(l10n.aiClaudeConsentBody), findsOneWidget);

    await tester.tap(find.text(l10n.cancel));
    await tester.pumpAndSettle();
    expect(selector(tester).mode, FloAiMode.cloud);
    expect(await ClaudeConsent.isGranted(), isFalse);

    await pick(tester, l10n.floModeClaude);
    await tester.tap(find.text(l10n.aiClaudeConsentAllow));
    await tester.pumpAndSettle();
    expect(selector(tester).mode, FloAiMode.claude);
    expect(await ClaudeConsent.isGranted(), isTrue);

    // Leaving Claude needs no checks.
    await pick(tester, l10n.floModeCloud);
    expect(selector(tester).mode, FloAiMode.cloud);
  });

  testWidgets('with consent on file, questions are answered by Claude',
      (tester) async {
    SharedPreferences.setMockInitialValues({'flo_claude_cli_consent_v1': true});
    await pumpScreen(tester, _ready);

    await pick(tester, l10n.floModeClaude);
    expect(find.text(l10n.aiClaudeConsentTitle), findsNothing);
    expect(selector(tester).mode, FloAiMode.claude);

    await ask(tester, 'How did I do today?');

    expect(runner.prompts, hasLength(1));
    expect(
        runner.prompts.single, contains('User question: How did I do today?'));
    expect(runner.prompts.single, contains('No sales recorded for today'));
    expect(savedReply('How did I do today?'), contains('Claude says hi.'));
  });

  testWidgets('a signed-out CLI explains how to sign in and stays on Cloud',
      (tester) async {
    await pumpScreen(
      tester,
      const ClaudeCliStatus(ClaudeCliState.notLoggedIn),
    );

    await pick(tester, l10n.floModeClaude);

    expect(find.text(l10n.aiClaudeNotLoggedIn), findsOneWidget);
    expect(selector(tester).mode, FloAiMode.cloud);
    await drainSnackBar(tester);
  });

  testWidgets('a CLI that vanished since detection asks to install it',
      (tester) async {
    await pumpScreen(tester, _ready);
    runner.status = const ClaudeCliStatus(ClaudeCliState.notInstalled);

    await pick(tester, l10n.floModeClaude);

    expect(find.text(l10n.aiClaudeNotInstalled), findsOneWidget);
    expect(selector(tester).mode, FloAiMode.cloud);
    // The refreshed status still offers the option.
    expect(selector(tester).claudeAvailable, isTrue);
    await drainSnackBar(tester);
  });

  testWidgets('in Cloud mode the question never reaches Claude',
      (tester) async {
    await pumpScreen(tester, _ready);

    await ask(tester, 'Top items?');

    expect(selector(tester).mode, FloAiMode.cloud);
    expect(runner.prompts, isEmpty);
    // No data-connector in tests: the cloud call fails visibly.
    expect(find.byType(SnackBar), findsOneWidget);
    await drainSnackBar(tester);
  });

  // Registers a process-wide engine, so it runs last.
  testWidgets('On-Device mode answers from the local model, not Claude',
      (tester) async {
    final engine = _EchoEngine();
    LocalInferenceRegistry.register(engine);
    await pumpScreen(tester, _ready);

    await pick(tester, l10n.floModeOnDevice);
    expect(selector(tester).mode, FloAiMode.onDevice);
    await ask(tester, 'Sales today?');

    expect(runner.prompts, isEmpty);
    expect(engine.prompts.single, contains('User question: Sales today?'));
    expect(savedReply('Sales today?'), contains('Local says hi.'));
  });
}
