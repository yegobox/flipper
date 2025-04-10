class P2PConfig {
  final bool enableBluetooth;
  final bool enableCloudSync;
  final String? supabaseUrl;
  final String? supabaseKey;
  final int syncInterval; // in seconds
  final int maxDocumentSize; // in bytes

  const P2PConfig({
    this.enableBluetooth = true,
    this.enableCloudSync = false,
    this.supabaseUrl,
    this.supabaseKey,
    this.syncInterval = 60,
    this.maxDocumentSize = 1024 * 1024, // 1MB default
  });
}
