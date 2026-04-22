// ignore_for_file: deprecated_member_use, use_super_parameters

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OptionFeatureSlider extends StatefulWidget {
  const OptionFeatureSlider({Key? key}) : super(key: key);

  @override
  State<OptionFeatureSlider> createState() => _OptionFeatureSliderState();
}

class _OptionFeatureSliderState extends State<OptionFeatureSlider> {
  List<dynamic> features = [];

  @override
  void initState() {
    super.initState();
    _loadFeatures();
  }

  Future<void> _loadFeatures() async {
    try {
      final String response = await rootBundle.loadString(
        'lib/features/home/ui/widget/option_feature_slider/option_feature.json',
      );
      final data = await json.decode(response);
      setState(() {
        features = data;
      });
    } catch (e) {
      debugPrint('Lỗi khi đọc file JSON: $e');
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'photo_library':
        return Icons.photo_library;
      case 'people':
        return Icons.people;
      case 'report':
        return Icons.report_problem;
      default:
        return Icons.extension;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: features.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemBuilder: (context, index) {
          final feature = features[index];

          return GestureDetector(
            onTap: () {
              if (feature['route'] != null) {
                Navigator.pushNamed(context, feature['route']);
              }
            },
            child: Container(
              width: 110,
              margin: const EdgeInsets.only(right: 12.0, top: 8.0, bottom: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIconData(feature['icon']),
                    size: 32,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      feature['name'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
