
import 'package:auto_mall/auth/global_function.dart';
import 'package:auto_mall/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/base_url.dart';


class LogoutService {
  static Future<void> fetchLogout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final response = await Dio().get(
        logout,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Cookie": "ci_session=${prefs.getString("sessionId")}",
            "Authorization": "${prefs.getString("token")}",
          },
        ),
      );

      final item = response.data;
      print("Logout Response: $item");

      if (item["success"] == true) {
        if (!context.mounted) return;

        Utils.showMotionToast(
          context,
          title: "${item["message"]}!",
          description: "Redirecting to Login Page",
          icon: Icons.check_circle,
          duration: const Duration(seconds: 2),
        );

        await AuthHelper.userLogout();
      } else {
        print("Logout failed: ${item["message"]}");
      }
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}

