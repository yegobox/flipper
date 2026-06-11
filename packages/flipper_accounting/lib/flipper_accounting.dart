/// Shared accounting core: domain models, double-entry mappers, chart of
/// accounts seed, ledger repository contract and its Ditto implementation.
///
/// Consumed by both the POS app (transaction-time journal posting via
/// flipper_models' PosJournalPoster) and the Books module in flipper_web.
library flipper_accounting;

export 'accounting_ditto_store.dart';
export 'audit_trail_recorder.dart';
export 'accounting_ledger_repository.dart';
export 'accounting_models.dart';
export 'accounting_transaction_semantics.dart';
export 'default_chart_of_accounts_seed.dart';
export 'ditto_accounting_ledger_repository.dart';
export 'ledger_row_mapper.dart';
export 'transaction_journal_poster.dart';
export 'transaction_to_accounts.dart';
