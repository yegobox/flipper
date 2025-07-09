import 'package:flipper_models/helperModels/talker.dart';
import 'package:supabase_models/brick/models/customer.model.dart';
import 'package:flipper_services/event_bus.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/services/turbo_tax_service.dart';
import 'package:supabase_models/brick/repository.dart';

class EbmSyncService {
  EbmSyncService(this.repository) {
    EventBus().on<CustomerUpserted>().listen((event) {
      _handleCustomerUpsert(event.customer);
    });
  }

  final Repository repository;

  Future<void> _handleCustomerUpsert(Customer customer) async {
    try {
      final serverUrl = await ProxyService.box.getServerUrl();
      if (serverUrl != null) {
        final turboTaxService = TurboTaxService(repository);
        await turboTaxService.syncCustomerWithEbm(
          instance: customer,
          serverUrl: serverUrl,
        );
        talker.info('EBM Sync successful for customer ${customer.id}');
      }
    } catch (e) {
      talker.error('EBM Sync failed for customer ${customer.id}: $e');
      // You can add more robust error handling here, like logging to a service.
    }
  }
}
