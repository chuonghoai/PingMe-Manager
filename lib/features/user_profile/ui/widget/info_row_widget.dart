// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class InfoRowWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const InfoRowWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor = const Color(0xFFF5A623),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 16),
        Text(
          title, 
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const Spacer(),
        Text(
          value, 
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}