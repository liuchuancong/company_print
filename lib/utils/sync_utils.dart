// 同步状态结果封装
enum SyncStatus { success, conflict, error, skipped }

class SyncResult {
  final String uuid;
  final SyncStatus status;
  final String? message;
  SyncResult({required this.uuid, required this.status, this.message});
}

class SyncClassResult {
  final SyncStatus status;
  final String? message;
  SyncClassResult({required this.status, this.message});
}
