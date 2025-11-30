abstract class SyncScheduler {
  Future<void> enqueue({
    required String entityType, // sentence/highlight/pref
    required String op, // create/update/delete
    required String entityLocalKey,
    String? remoteId,
    Map<String, dynamic>? payload,
    int priority = 0,
    String status = 'pending',
    String? errorCode,
    String? errorMessage,
  });

  Future<void> runOnce();
  Future<void> runContinuous();
  Future<void> stop();
  void onNetworkChange(bool online);
  void registerHandler(String entityType, SyncHandler handler);
}

abstract class SyncHandler {
  Future<SyncResult> handle(SyncJob job);
}

class SyncJob {
  final String entityType;
  final String op;
  final String? remoteId;
  final Map<String, dynamic>? payload;
  final String entityLocalKey;
  SyncJob(this.entityType, this.op, this.entityLocalKey,
      {this.remoteId, this.payload});
}

class SyncResult {
  final bool ok;
  final String? newRemoteId;
  final DateTime? remoteEditedAt;
  final String? errorCode;
  final String? errorMessage;
  const SyncResult.ok({this.newRemoteId, this.remoteEditedAt})
      : ok = true,
        errorCode = null,
        errorMessage = null;
  const SyncResult.err(this.errorCode, this.errorMessage)
      : ok = false,
        newRemoteId = null,
        remoteEditedAt = null;
}
