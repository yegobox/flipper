# Riverpod performance — budgets and regression

## Perf budgets

| Path | Budget | Test |
|------|--------|------|
| Cart tap → display line | ≤ 3000 µs (in-memory) | `flipper_models/test/pos_cart_tap_sync_perf_test.dart` |
| Ticket selection toggle | No full-list rebuild | `flipper_dashboard/test/features/tickets/ticket_selection_test.dart` |
| Report view toggle | No regression | `flipper_dashboard/test/transaction_reports_view_toggle_test.dart` |

Constants: `kPosCartTapDisplayMaxMicroseconds` in `pos_cart_sync_tap.dart`.

## Dev tracing

In debug builds, enable provider update logging:

```dart
ref.read(providerPerfTracingEnabledProvider.notifier).state = true;
```

Allowlist: `kProviderPerfTraceAllowlist` in `provider_perf_observer.dart`.

## Key optimizations (2025)

- **Tickets**: `ticketsPaymentSumsProvider` (batch paid), per-card `select()` on selection, `ListView.builder`, single `openPosTicketsTransactionsStream` Ditto observer
- **Catalog**: `stocksForVisibleVariantsProvider` — one stock observer per page vs N per tile
- **Reports**: `transactionItemList` scoped to SQL page ids; KPI totals decoupled from live PLU stream; `transactionReportSnapshot` keepAlive
- **Side menu**: `sideMenuVisibilityProvider` — one watch
- **Park**: `parkTransactionProvider` AsyncNotifier

## Regression suite (run after each phase)

```bash
# flipper_models
cd flipper/packages/flipper_models
dart test test/pos_cart_tap_sync_perf_test.dart

# flipper_dashboard
cd flipper/packages/flipper_dashboard
flutter test test/features/tickets/ticket_selection_test.dart
flutter test test/widgets/pos_cart_tap_widget_test.dart
flutter test test/transaction_reports_view_toggle_test.dart
flutter test test/checkout_error_recovery_test.dart
flutter test test/item_row_test.dart
```

## Manual smoke checklist

- [ ] Add 5 items in POS grid — qty updates instant
- [ ] Park ticket → resume — cart intact
- [ ] Attach customer — no checkout hitch
- [ ] Reports: change date range, filter, paginate, export
- [ ] Toggle ticket multi-select with 20+ tickets
