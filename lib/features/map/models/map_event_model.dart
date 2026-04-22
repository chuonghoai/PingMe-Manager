class MapEventModel {
  final String? id;
  final String? name;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? rewardItem;
  final int? rewardQuantity;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MapEventModel({
    this.id,
    this.name,
    this.description,
    this.latitude,
    this.longitude,
    this.rewardItem,
    this.rewardQuantity,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.updatedAt,
  });

  factory MapEventModel.fromJson(Map<String, dynamic> json) {
    return MapEventModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      rewardItem: json['rewardItem'] as String?,
      rewardQuantity: json['rewardQuantity'] as int?,
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'])
          : null,
      endTime: json['endTime'] != null
          ? DateTime.tryParse(json['endTime'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (rewardItem != null) 'rewardItem': rewardItem,
      if (rewardQuantity != null) 'rewardQuantity': rewardQuantity,
      if (startTime != null) 'startTime': startTime?.toIso8601String(),
      if (endTime != null) 'endTime': endTime?.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
