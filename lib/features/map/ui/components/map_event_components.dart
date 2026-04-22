// file: map/ui/components/map_event_components.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/map/ui/controller/map_event_controller.dart';
import 'package:pingme_manager/features/map/models/reward_model.dart';

class MapEventComponents extends StatefulWidget {
  final VoidCallback onCreateNewTriggered;

  const MapEventComponents({Key? key, required this.onCreateNewTriggered})
    : super(key: key);

  @override
  State<MapEventComponents> createState() => _MapEventComponentsState();
}

class _MapEventComponentsState extends State<MapEventComponents> {
  final MapEventController _eventController = MapEventController();

  @override
  void initState() {
    super.initState();
    _eventController.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách sự kiện',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: widget.onCreateNewTriggered,
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo sự kiện mới'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListenableBuilder(
              listenable: _eventController,
              builder: (context, child) {
                if (_eventController.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_eventController.events.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Chưa có sự kiện nào.'),
                        TextButton(
                          onPressed: _eventController.fetchEvents,
                          child: const Text('Tải lại'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _eventController.fetchEvents,
                  child: ListView.builder(
                    itemCount: _eventController.events.length,
                    itemBuilder: (context, index) {
                      final event = _eventController.events[index];
                      final rewardInfo = RewardDefinitions.getReward(
                        event.rewardItem,
                      );

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            rewardInfo?.emoji ?? '🎁',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        title: Text(
                          event.name ?? 'Không tên',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(event.description ?? ''),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'x${event.rewardQuantity ?? 1}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  _eventController.deleteEvent(event.id!),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
