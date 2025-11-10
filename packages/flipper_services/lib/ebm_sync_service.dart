import 'dart:async';

import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:supabase_models/brick/models/customer.model.dart';
import 'package:flipper_services/event_bus.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/services/turbo_tax_service.dart';
import 'package:supabase_models/brick/repository.dart';

class EbmSyncService {
  StreamSubscription<CustomerUpserted>? _subscription;

  EbmSyncService(this.repository) {
    _subscription = EventBus().on<CustomerUpserted>().listen((event) {
      _handleCustomerUpsert(event.customer);
    });
  }

  final Repository repository;

  void dispose() {
    _subscription?.cancel();
  }

  Future<void> _handleCustomerUpsert(Customer customer) async {
    try {
      final serverUrl = await ProxyService.box.getServerUrl();
      if (serverUrl != null) {
        RwApiResponse response = await ProxyService.tax.saveCustomer(
          customer: ICustomer.fromJson(customer.toFlipperJson()),
          URI: serverUrl,
        );
        if (response.resultCd == "000") {
          ProxyService.notification
              .sendLocalNotification(body: "Customer Synced");
        } else {
          final message = response.resultMsg.extractMeaningfulMessage();
          ProxyService.notification.sendLocalNotification(body: message);
        }
        talker.info('EBM Sync successful for customer ${customer.id}');
      }
    } catch (e) {
      talker.error('EBM Sync failed for customer ${customer.id}: $e');
      // You can add more robust error handling here, like logging to a service.
    }
  }
}
