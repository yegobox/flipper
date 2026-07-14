class LocalDbConfig {
  LocalDbConfig(
    this.path, {
    this.enableEncryption = false,
    this.enableAttach = false,
    this.enableCustomTypes = false,
    this.enableIndexMethod = false,
    this.enableMaterializedViews = false,
    this.enableVacuum = false,
    this.enableGeneratedColumns = false,
    this.enableMultiprocessWal = false,
    this.enableWithoutRowid = false,
    this.vfs,
    this.encryptionOptsChiper,
    this.encryptionOptsHexkey,
  });

  String path;
  bool enableEncryption;
  bool enableAttach;
  bool enableCustomTypes;
  bool enableIndexMethod;
  bool enableMaterializedViews;
  bool enableVacuum;
  bool enableGeneratedColumns;
  bool enableMultiprocessWal;
  bool enableWithoutRowid;
  String? vfs;
  String? encryptionOptsChiper;
  String? encryptionOptsHexkey;

  Map<String, dynamic> toJson() => {
    'path': path,
    'enable_encryption': enableEncryption,
    'enable_attach': enableAttach,
    'enable_custom_types': enableCustomTypes,
    'enable_index_method': enableIndexMethod,
    'enable_materialized_views': enableMaterializedViews,
    'enable_vacuum': enableVacuum,
    'enable_generated_columns': enableGeneratedColumns,
    'enable_multiprocess_wal': enableMultiprocessWal,
    'enable_without_rowid': enableWithoutRowid,
    if (vfs != null) 'vfs': vfs,
    if (encryptionOptsChiper != null)
      'encryption_opts_chiper': encryptionOptsChiper,
    if (encryptionOptsHexkey != null)
      'encryption_opts_hexkey': encryptionOptsHexkey,
  };
}

class SyncDbConfig {
  SyncDbConfig(
    this.path, {
    required this.remoteUrl,
    this.authToken,
    this.clientName,
    this.longPollTimeout,
    this.bootstrapIfEmpty = false,
    this.experimentalIndexMethod = false,
  });

  String path;
  String remoteUrl;
  String? authToken;
  String? clientName;
  Duration? longPollTimeout;
  bool bootstrapIfEmpty;
  bool experimentalIndexMethod;

  Map<String, dynamic> toJson() => {
    'path': path,
    'remote_url': remoteUrl,
    if (authToken != null) 'auth_token': authToken,
    if (clientName != null) 'client_name': clientName,
    if (longPollTimeout != null)
      'long_poll_timeout': longPollTimeout?.inMilliseconds,
    'bootstrap_if_empty': bootstrapIfEmpty,
    'experimental_index_method': experimentalIndexMethod,
  };
}
