import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/domain/party/customer_factory.dart';
import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/repository/storage.dart';

/// Attach / quick-create for the mobile checkout customer sheet.
///
/// The single service-locator lookup for that sheet: tests override this
/// provider instead of booting Ditto.
final mposCustomerActionsProvider = Provider<MposCustomerActions>(
  (ref) => MposCustomerActions(
    capella: ProxyService.getStrategy(Strategy.capella),
    box: ProxyService.box,
  ),
);

class MposCustomerActions {
  MposCustomerActions({required this.capella, required this.box});

  final DatabaseSyncInterface capella;
  final LocalStorage box;

  /// Puts an existing [customer] on [transaction].
  Future<void> attach(Customer customer, ITransaction transaction) async {
    await capella.assignCustomerToTransaction(
      customer: customer,
      transaction: transaction,
    );
    await _writeSaleSession(customer);
  }

  /// Saves a new customer from just a phone (name optional) and attaches it
  /// to [transaction] in the same write.
  Future<Customer> quickAdd({
    required String phone,
    required String name,
    required ITransaction transaction,
  }) async {
    final branchId = box.getBranchId();
    if (branchId == null || branchId.isEmpty) {
      throw StateError('No active branch');
    }
    final trimmedPhone = phone.trim();
    final trimmedName = name.trim();
    final draft = PartyDraft(
      // Phone-only customers still need a display name (desktop's pay gate
      // and receipts read custNm), so the phone stands in for it.
      name: trimmedName.isEmpty ? trimmedPhone : trimmedName,
      phone: trimmedPhone,
      // Empty, not null: a null TIN falls back to the phone, which would make
      // every later sale for this customer ask for an RRA purchase code.
      tin: '',
      customerType: 'Individual',
      branchId: branchId,
      bhfId: await box.bhfId() ?? '00',
    );
    final customer = customerFromDraft(draft);
    final saved = await capella.addCustomer(
      customer: customer,
      transactionId: transaction.id,
    );
    if (saved == null) {
      throw StateError('Customer could not be saved');
    }
    await _writeSaleSession(saved);
    return saved;
  }

  /// Checkout, receipts and the purchase-code prompt read these keys for the
  /// sale in progress (same keys CoreViewModel.addCustomer keeps in sync).
  Future<void> _writeSaleSession(Customer customer) async {
    await box.writeString(key: 'customerName', value: customer.custNm ?? '');
    await box.writeString(
      key: 'currentSaleCustomerPhoneNumber',
      value: customer.telNo ?? '',
    );
    final tin = customer.custTin?.trim() ?? '';
    if (tin.isEmpty) {
      await box.remove(key: 'customerTin');
    } else {
      await box.writeString(key: 'customerTin', value: tin);
    }
  }
}
