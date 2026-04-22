// file: map/ui/components/event_detail_widget.dart

// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/map/models/map_event_model.dart';
import 'package:pingme_manager/features/map/models/reward_model.dart';
import 'package:pingme_manager/features/map/ui/controller/map_event_controller.dart';
import 'package:intl/intl.dart';

class EventDetailComponent extends StatelessWidget {
  final MapEventModel event;
  final MapEventController eventController;

  const EventDetailComponent({
    Key? key,
    required this.event,
    required this.eventController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reward = RewardDefinitions.getReward(event.rewardItem);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(reward?.emoji ?? '🎁', style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name ?? 'Không có tên',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Phần thưởng: ${reward?.name} (x${event.rewardQuantity})',
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          _buildInfoRow(
            Icons.description,
            'Mô tả',
            event.description ?? 'Không có mô tả',
          ),
          _buildInfoRow(
            Icons.access_time,
            'Bắt đầu',
            event.startTime != null
                ? dateFormat.format(event.startTime!)
                : 'Chưa cập nhật',
          ),
          _buildInfoRow(
            Icons.timer_off,
            'Kết thúc',
            event.endTime != null
                ? dateFormat.format(event.endTime!)
                : 'Chưa cập nhật',
          ),
          _buildInfoRow(
            Icons.location_on,
            'Tọa độ',
            '${event.latitude?.toStringAsFixed(5)}, ${event.longitude?.toStringAsFixed(5)}',
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Edit event
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Chỉnh sửa'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await _showDeleteConfirm(context);
                    if (confirm == true && event.id != null) {
                      final success = await eventController.deleteEvent(
                        event.id!,
                      );
                      if (success && context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã xóa sự kiện')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Xóa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa sự kiện này khỏi hệ thống?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
