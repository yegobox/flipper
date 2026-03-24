import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'tickets_provider.g.dart';

@riverpod
Stream<List<ITransaction>> ticketsStream(Ref ref) {
  final capellaStrategy = ProxyService.getStrategy(Strategy.capella);
  final branchId = ProxyService.box.getBranchId();

  final waitingStream = capellaStrategy
      .transactionsStream(
        status: WAITING,
        branchId: branchId,
        removeAdjustmentTransactions: true,
        forceRealData: true,
        skipOriginalTransactionCheck: false,
      )
      .map((tickets) {
        // Mark all tickets as coming from Capella
        return tickets.map((ticket) {
          ticket.dataSource = Strategy.capella;
          return ticket;
        }).toList();
      })
      .startWith(const <ITransaction>[]);

  final parkedStream = capellaStrategy
      .transactionsStream(
        status: PARKED,
        removeAdjustmentTransactions: true,
        forceRealData: true,
        branchId: branchId,
        skipOriginalTransactionCheck: false,
      )
      .map((tickets) {
        // Mark all tickets as coming from Capella
        return tickets.map((ticket) {
          ticket.dataSource = Strategy.capella;
          return ticket;
        }).toList();
      })
      .startWith(const <ITransaction>[]);

  final inProgressStream = capellaStrategy
      .transactionsStream(
        status: IN_PROGRESS,
        removeAdjustmentTransactions: true,
        forceRealData: true,
        branchId: branchId,
        skipOriginalTransactionCheck: false,
      )
      .map((tickets) {
        // Mark all tickets as coming from Capella
        return tickets.map((ticket) {
          ticket.dataSource = Strategy.capella;
          return ticket;
        }).toList();
      })
      .startWith(const <ITransaction>[]);

  return Rx.combineLatest3<
        List<ITransaction>,
        List<ITransaction>,
        List<ITransaction>,
        List<ITransaction>
      >(waitingStream, parkedStream, inProgressStream, (
        waiting,
        parked,
        inProgress,
      ) {
        // Combine all transactions
        final allTickets = <ITransaction>[
          ...waiting,
          ...parked,
          ...inProgress,
        ];

        // Sort by priority and creation date
        allTickets.sort((a, b) {
          final priority = <String, int>{
            WAITING: 3,
            PARKED: 2,
            IN_PROGRESS: 1,
          };
          final aPrio = priority[a.status] ?? 0;
          final bPrio = priority[b.status] ?? 0;
          if (aPrio != bPrio) return bPrio.compareTo(aPrio);

          final aDate = a.createdAt ?? DateTime(1970);
          final bDate = b.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });

        return allTickets;
      })
      .handleError((e, st) {
        talker.error('Ticket stream error: $e', st);
        throw e;
      });
}
