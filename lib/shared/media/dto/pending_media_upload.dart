class PendingMediaUpload {
  final String id;
  final String filePath;
  final String type;
  double progress;
  String status;

  PendingMediaUpload({
    required this.id,
    required this.filePath,
    required this.type,
    this.progress = 0.0,
    this.status = 'pending',
  });
}
