class CloudinarySignature {
  final String signature;
  final dynamic timestamp;
  final String cloudName;
  final String apiKey;
  final String? folder;
  final String? tags;

  CloudinarySignature({
    required this.signature,
    required this.timestamp,
    required this.cloudName,
    required this.apiKey,
    this.folder,
    this.tags,
  });

  factory CloudinarySignature.fromJson(Map<String, dynamic> json) {
    return CloudinarySignature(
      signature: json['signature']?.toString() ?? '',
      timestamp: json['timestamp'],
      cloudName: json['cloud_name']?.toString() ?? '',
      apiKey: json['api_key']?.toString() ?? '',
      folder: json['folder']?.toString(),
      tags: json['tags']?.toString(),
    );
  }
}