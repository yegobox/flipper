import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

/// Utility class for cleaning up old Ditto directories
class DittoCleanup {
  /// Clean up old Ditto directories that are older than the specified duration
  /// This helps prevent accumulation of temporary directories
  static Future<void> cleanupOldDirectories({
    Duration olderThan = const Duration(hours: 24),
  }) async {
    if (kIsWeb) {
      // Web doesn't have file system access, skip cleanup
      return;
    }

    try {
      // Get the current working directory or documents directory
      final currentDir = Directory.current;
      
      // Look for Ditto directories in common locations
      final searchDirs = [
        currentDir,
        Directory(path.join(currentDir.path, 'Documents')),
        Directory(path.join(currentDir.path, 'AppData', 'Local')),
      ];

      for (final searchDir in searchDirs) {
        if (!await searchDir.exists()) continue;

        await for (final entity in searchDir.list()) {
          if (entity is Directory) {
            final dirName = path.basename(entity.path);
            
            // Check if it's a Ditto directory
            if (dirName.startsWith('flipper_data_bridge_') ||
                dirName.startsWith('ditto_flipper_')) {
              
              // Check if it's old enough to clean up
              final stat = await entity.stat();
              final age = DateTime.now().difference(stat.modified);
              
              if (age > olderThan) {
                try {
                  await entity.delete(recursive: true);
                  debugPrint('🧹 Cleaned up old Ditto directory: $dirName');
                } catch (e) {
                  debugPrint('⚠️  Could not clean up directory $dirName: $e');
                }
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️  Error during Ditto cleanup: $e');
    }
  }

  /// Get the size of all Ditto directories for monitoring
  static Future<int> getTotalDittoDirectorySize() async {
    if (kIsWeb) return 0;

    int totalSize = 0;
    
    try {
      final currentDir = Directory.current;
      
      await for (final entity in currentDir.list()) {
        if (entity is Directory) {
          final dirName = path.basename(entity.path);
          
          if (dirName.startsWith('flipper_data_bridge_') ||
              dirName.startsWith('ditto_flipper_')) {
            
            await for (final file in entity.list(recursive: true)) {
              if (file is File) {
                final stat = await file.stat();
                totalSize += stat.size;
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️  Error calculating Ditto directory size: $e');
    }
    
    return totalSize;
  }

  /// List all Ditto directories for debugging
  static Future<List<String>> listDittoDirectories() async {
    if (kIsWeb) return [];

    final directories = <String>[];
    
    try {
      final currentDir = Directory.current;
      
      await for (final entity in currentDir.list()) {
        if (entity is Directory) {
          final dirName = path.basename(entity.path);
          
          if (dirName.startsWith('flipper_data_bridge_') ||
              dirName.startsWith('ditto_flipper_')) {
            directories.add(dirName);
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️  Error listing Ditto directories: $e');
    }
    
    return directories;
  }
}