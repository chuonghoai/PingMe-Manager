// ignore_for_file: constant_identifier_names

enum EItemType {
  ROSE,
  ROCKET,
  STAR,
  STREAK_SHIELD,
  EXP_BOOST,
}

class RewardItem {
  final EItemType type;
  final String name;
  final String emoji;
  final String description;

  const RewardItem({
    required this.type,
    required this.name,
    required this.emoji,
    required this.description,
  });
}

class RewardDefinitions {
  static const Map<String, RewardItem> items = {
    'ROSE': RewardItem(
      type: EItemType.ROSE,
      name: 'Hoa hồng',
      emoji: '🌹',
      description: 'Tặng bạn bè để tăng 15 điểm thân mật',
    ),
    'ROCKET': RewardItem(
      type: EItemType.ROCKET,
      name: 'Tên lửa',
      emoji: '🚀',
      description: 'Tặng bạn bè để tăng 25 điểm thân mật',
    ),
    'STAR': RewardItem(
      type: EItemType.STAR,
      name: 'Ngôi sao',
      emoji: '⭐',
      description: 'Tặng bạn bè để tăng 40 điểm thân mật',
    ),
    'STREAK_SHIELD': RewardItem(
      type: EItemType.STREAK_SHIELD,
      name: 'Khiên bảo vệ streak',
      emoji: '🛡️',
      description: 'Bảo vệ streak không bị mất khi bỏ lỡ 1 ngày',
    ),
    'EXP_BOOST': RewardItem(
      type: EItemType.EXP_BOOST,
      name: 'x2 EXP 1 giờ',
      emoji: '⚡',
      description: 'Nhân đôi điểm thân mật nhận được trong 60 phút',
    ),
  };

  static RewardItem? getReward(String? typeStr) {
    if (typeStr == null) return null;
    return items[typeStr];
  }
}
