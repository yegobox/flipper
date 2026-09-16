import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_stay_picker.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

/// Posting a bar tab onto a hotel guest's folio.
///
/// A property that runs both a bar and rooms bills a resident guest once, at
/// check-out: the drinks are not a separate sale, they are lines on the stay.
/// So the tab is *moved* — the lines keep the itemCd and tax the bar computed,
/// the table frees up, and no receipt is filed until the desk settles the
/// folio.
///
/// Deliberately not gated on Hotel Mode being the branch's active service
/// mode: the whole point is that the bar terminal is in Bar Mode while guests
/// are upstairs.
abstract final class BarRoomCharge {
  /// Tender label for the settle screen. Never reaches a payment row — a room
  /// charge is settled on the folio, so this only drives the UI.
  static const method = 'Room charge';

  /// Whether the bar should offer a room charge at all — false for a branch
  /// with no rooms, or with nobody checked in.
  static bool isAvailable(WidgetRef ref) =>
      ref.watch(hotelRoomChargeAvailableProvider);

  /// Asks which guest picks up the tab.
  static Future<HotelStay?> pickStay(
    BuildContext context, {
    required bool mobile,
  }) {
    return HotelStayPicker.show(
      context,
      mobile: mobile,
      subtitle: 'The tab moves onto the guest folio and is paid at check-out.',
    );
  }

  /// Moves [tab]'s lines onto [stay]'s folio and closes the table.
  ///
  /// Returns true when something moved; the caller stays put otherwise, so an
  /// empty tab or a rejected transfer does not look like a completed charge.
  static Future<bool> chargeTab({
    required BuildContext context,
    required WidgetRef ref,
    required ITransaction tab,
    required BarTable table,
    required Tenant cashier,
    required HotelStay stay,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final moved = await ProxyService.getStrategy(Strategy.capella)
          .transferCartToFolio(
            cartTransactionId: tab.id,
            stay: stay,
            clerkTenantId: cashier.id,
            clerkName: cashier.name ?? 'Staff',
          );

      if (moved == 0) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Add something to the tab before charging a room.'),
          ),
        );
        return false;
      }

      ref.invalidate(barTabLinesProvider(tab.id));
      ref
          .read(barModeProvider.notifier)
          .afterSettle(
            tableName: table.name,
            message:
                '${table.name} → ${hotelRoomChargeTarget(stay)} · '
                '$moved item${moved == 1 ? '' : 's'} on the folio',
          );
      return true;
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
      return false;
    }
  }

  /// Picker + transfer in one step, for the tab screens.
  static Future<bool> promptAndChargeTab({
    required BuildContext context,
    required WidgetRef ref,
    required ITransaction tab,
    required BarTable table,
    required Tenant cashier,
    required bool mobile,
  }) async {
    final stay = await pickStay(context, mobile: mobile);
    if (stay == null || !context.mounted) return false;
    return chargeTab(
      context: context,
      ref: ref,
      tab: tab,
      table: table,
      cashier: cashier,
      stay: stay,
    );
  }
}
