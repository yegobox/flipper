abstract final class AnalyticsEvents {
  /// Canonical "user was active" signal for PostHog DAU/WAU/retention dashboards.
  /// Emitted on cold start and each app foreground resume via [ProductActiveLifecycle].
  static const productActive = 'product_active';

  static const loginSuccess = 'login_success';
  static const loginFailed = 'login_failed';
  static const signupCompleted = 'signup_completed';
  static const transactionCompleted = 'transaction_completed';
  static const quickSellCompleted = 'quick_sell_completed';
  static const productCreated = 'product_created';
  static const businessSelected = 'business_selected';
  static const branchSelected = 'branch_selected';
  static const booksSessionStarted = 'books_session_started';
  static const dittoInitReady = 'ditto_init_ready';
  static const dittoInitFailed = 'ditto_init_failed';
  static const journalEntryPosted = 'journal_entry_posted';
  static const expenseRecorded = 'expense_recorded';
  static const bankStatementImported = 'bank_statement_imported';
}
