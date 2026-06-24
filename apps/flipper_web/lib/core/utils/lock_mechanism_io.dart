import 'dart:io';

/// Platform-agnostic interface for acquiring a lock
abstract class LockMechanism {
  Future<bool> acquire(String path);
  Future<void> release();
}

class LockMechanismImpl implements LockMechanism {
  File? _lockFile;
  RandomAccessFile? _lockFileHandle;
  bool _lockAcquired = false;

  @override
  Future<bool> acquire(String path) async {
    _lockFile = File(path);
    try {
      if (!_lockFile!.parent.existsSync()) {
        _lockFile!.parent.createSync(recursive: true);
      }
      // Open the file for read/write access
      _lockFileHandle = await _lockFile!.open(mode: FileMode.write);

      // Try to acquire an exclusive lock atomically
      await _lockFileHandle!.lock(FileLock.exclusive);

      // Write the current process ID while holding the lock
      await _lockFileHandle!.truncate(0);
      await _lockFileHandle!.setPosition(0);
      await _lockFileHandle!.writeString(pid.toString());
      await _lockFileHandle!.flush();

      _lockAcquired = true;
      return true;
    } catch (e) {
      if (_lockFileHandle != null) {
        try {
          await _lockFileHandle!.close();
        } catch (_) {}
        _lockFileHandle = null;
      }
      _lockAcquired = false;
      return false;
    }
  }

  @override
  Future<void> release() async {
    if (_lockFileHandle != null && _lockAcquired) {
      try {
        await _lockFileHandle!.close();
        _lockFileHandle = null;
        _lockAcquired = false;
      } catch (_) {}
    }

    if (_lockFile != null) {
      try {
        if (await _lockFile!.exists()) {
          await _lockFile!.delete();
        }
      } catch (_) {}
    }
  }
}

// Function to get the platform implementation
LockMechanism getLockMechanism() => LockMechanismImpl();
