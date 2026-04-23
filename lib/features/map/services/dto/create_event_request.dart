class CreateEventRequest {
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String rewardItem;
  final int rewardQuantity;
  final DateTime startTime;
  final DateTime endTime;

  CreateEventRequest({
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.rewardItem,
    required this.rewardQuantity,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'rewardItem': rewardItem,
      'rewardQuantity': rewardQuantity,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }
}
