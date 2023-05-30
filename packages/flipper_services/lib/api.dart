import 'dart:developer';

abstract class AB {
  Future<int> intd();
}

class Api implements AB {
  @override
  Future<int> intd() async {
    log('API loaded');
    return await Future.delayed(const Duration(seconds: 1));
  }
}
