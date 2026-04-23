class InventoryItemModel {
  final String? id;
  final String itemType;
  final String? name;
  final String? emoji;
  int quantity;

  InventoryItemModel({
    this.id,
    required this.itemType,
    this.name,
    this.emoji,
    required this.quantity,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'],
      itemType: json['itemType'],
      name: json['name'],
      emoji: json['emoji'],
      quantity: json['quantity'] ?? 0,
    );
  }

  InventoryItemModel clone() {
    return InventoryItemModel(
      id: id,
      itemType: itemType,
      name: name,
      emoji: emoji,
      quantity: quantity,
    );
  }
}
