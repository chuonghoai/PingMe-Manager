// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class ChatBubbleWidget extends StatelessWidget {
  static final ValueNotifier<int> unreadCounter = ValueNotifier<int>(0);

  const ChatBubbleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: unreadCounter,
      builder: (context, count, child) {
        return FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/conversation');
          },
          backgroundColor: const Color(0xFFF5A623),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.message_rounded, color: Colors.white, size: 28),
              if (count > 0)
                Positioned(
                  right: -8,
                  top: -8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}