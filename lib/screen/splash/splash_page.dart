import 'dart:async';
import 'package:crm_center_techer_app_end_atko_uz/screen/login/login_page.dart';
import 'package:crm_center_techer_app_end_atko_uz/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 1), () {
      final box = GetStorage();
      final token = box.read('token');

      if (token != null && token.toString().isNotEmpty) {
        Get.offAll(() => const MainScreen());
      } else {
        Get.offAll(() => const LoginPage());
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
