/// Platform-agnostic interface for acquiring a lock
abstract class LockMechanism {
  Future<bool> acquire(String path);
  Future<void> release();
}

class LockMechanismImpl implements LockMechanism {
  @override
  Future<bool> acquire(String path) async {
    // No-op on web since there's no filesystem contention from multiple processes
    // in the same way as desktop/mobile OSs.
    // If needed, we could use Web Locks API but that requires JS interop
    // For now we assume single instance per tab or handle it via other means
    return true;
  }

  @override
  Future<void> release() async {
    // No-op
  }
}

// Function to get the platform implementation
LockMechanism getLockMechanism() => LockMechanismImpl();
