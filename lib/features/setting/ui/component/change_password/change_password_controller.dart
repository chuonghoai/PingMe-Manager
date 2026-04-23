import 'package:flutter/material.dart';
import 'package:pingme_manager/features/setting/service/setting_service.dart';

class ChangePasswordController extends ChangeNotifier {
  final SettingService _settingService = SettingService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordCtrl = TextEditingController();
  final TextEditingController newPasswordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  bool isLoading = false;

  void submit(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();

      final result = await _changePassword(
        oldPasswordCtrl.text.trim(),
        newPasswordCtrl.text.trim(),
      );

      isLoading = false;
      notifyListeners();

      if (!context.mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đổi mật khẩu thành công!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Đã xảy ra lỗi'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Change password API call
  Future<Map<String, dynamic>> _changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final response = await _settingService.changePassword(
      oldPassword,
      newPassword,
    );
    if (response['success']) {
      return {
        'success': true,
        'message': 'Đổi mật khẩu thành công',
        'error': null,
      };
    } else {
      return {
        'success': false,
        'message': 'Đổi mật khẩu thất bại',
        'error': response['error'],
      };
    }
  }

  @override
  void dispose() {
    oldPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }
}
