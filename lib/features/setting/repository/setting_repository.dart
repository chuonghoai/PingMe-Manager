// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pingme_manager/core/network/api_client.dart';
import 'package:pingme_manager/core/network/api_response.dart';

class SettingRepository {
  final ApiClient _apiClient = ApiClient();

  // Get list features from json
  Future<List<Map<String, dynamic>>> loadSettingFeatures() async {
    try {
      final String response = await rootBundle.loadString(
        'lib/features/setting/ui/setting_feature.json',
      );
      final List<dynamic> data = json.decode(response);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print('Lỗi load setting_feature.json: $e');
      return [];
    }
  }

  // API logout
  Future<ApiResponse> logout(String refreshToken) async {
    final response = await _apiClient.client.post('/auth/logout', data: {
      'refreshToken': refreshToken,
    });
    return response.data as ApiResponse;
  }

  // API change password
  Future<ApiResponse> changePassword(String oldPassword, String newPassword) async {
    final response = await _apiClient.client.patch('/admin/change-password', data: {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
    return response.data as ApiResponse;
  }
}
