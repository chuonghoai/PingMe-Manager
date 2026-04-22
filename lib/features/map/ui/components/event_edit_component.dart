// file: map/ui/components/event_edit_widget.dart
// ignore_for_file: use_super_parameters, deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/map/services/dto/create_event_request.dart';
import 'package:pingme_manager/features/map/ui/controller/map_event_controller.dart';
import 'package:pingme_manager/features/map/models/reward_model.dart';

class EventEditComponent extends StatefulWidget {
  final double latitude;
  final double longitude;

  const EventEditComponent({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<EventEditComponent> createState() => _EventEditComponentState();
}

class _EventEditComponentState extends State<EventEditComponent> {
  final MapEventController _eventController = MapEventController();
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController(text: '1');

  String _selectedReward = RewardDefinitions.items.keys.first;
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(days: 1));

  Future<void> _pickDateTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startTime : _endTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStart ? _startTime : _endTime),
    );
    if (time == null) return;

    setState(() {
      final newDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      if (isStart) {
        _startTime = newDateTime;
      } else {
        _endTime = newDateTime;
      }
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final request = CreateEventRequest(
        name: _nameCtrl.text,
        description: _descCtrl.text,
        latitude: widget.latitude,
        longitude: widget.longitude,
        rewardItem: _selectedReward,
        rewardQuantity: int.parse(_quantityCtrl.text),
        startTime: _startTime,
        endTime: _endTime,
      );

      final success = await _eventController.createEvent(request);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tạo sự kiện thành công!')),
        );
        Navigator.pop(context); // Đóng pop-up
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${_eventController.errorMessage}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Tạo Map Event',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tên sự kiện',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Tọa độ (chỉ đọc)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.latitude.toStringAsFixed(5),
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                        ),
                        enabled: false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.longitude.toStringAsFixed(5),
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                        ),
                        enabled: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Chọn Quà
                DropdownButtonFormField<String>(
                  value: _selectedReward,
                  decoration: const InputDecoration(
                    labelText: 'Phần thưởng',
                    border: OutlineInputBorder(),
                  ),
                  items: RewardDefinitions.items.entries.map((e) {
                    return DropdownMenuItem(
                      value: e.key,
                      child: Text('${e.value.emoji} ${e.value.name}'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedReward = val!),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _quantityCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Số lượng quà',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      int.tryParse(v ?? '') == null ? 'Phải là số' : null,
                ),
                const SizedBox(height: 12),

                // Thời gian
                ListTile(
                  title: const Text('Bắt đầu'),
                  subtitle: Text(_startTime.toString().substring(0, 16)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDateTime(true),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: const Text('Kết thúc'),
                  subtitle: Text(_endTime.toString().substring(0, 16)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDateTime(false),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 24),

                ListenableBuilder(
                  listenable: _eventController,
                  builder: (context, child) {
                    if (_eventController.isCreating)
                      return const Center(child: CircularProgressIndicator());
                    return ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Lưu sự kiện',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
