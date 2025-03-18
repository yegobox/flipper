import 'dart:async';

import 'package:flipper_models/sync/interfaces/base_sync_interface.dart';
import 'package:flipper_services/abstractions/storage.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

mixin CollectionMixin {
  Future<BaseSyncInterface> configureLocal({
    required bool useInMemory,
    required LocalStorage box,
  }) async {
    // Implementation needed - this method should configure local storage settings
    throw UnimplementedError('configureLocal needs to be implemented');
  }

  Future<void> initCollections() async {
    // Implementation needed - this method should initialize all required collections
    throw UnimplementedError('initCollections needs to be implemented');
  }

  Repository get repository;
  Talker get talker;
}
