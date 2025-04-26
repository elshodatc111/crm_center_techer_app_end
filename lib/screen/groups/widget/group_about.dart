import 'package:crm_center_techer_app_end_atko_uz/screen/groups/widget/about_item_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class GroupAbout extends StatelessWidget {
  final String group_name;
  final String room;
  final String price;
  final int lessen_count;
  final String lessen_start;
  final String lessen_end;
  final String techer_paymart;
  final String techer_bonus;
  final String status;

  const GroupAbout({
    super.key,
    required this.group_name,
    required this.room,
    required this.price,
    required this.lessen_count,
    required this.lessen_start,
    required this.lessen_end,
    required this.techer_paymart,
    required this.techer_bonus,
    required this.status,
  });

  String formatDate(String date) {
    try {
      final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
      final DateTime parsedDate = inputFormat.parse(date);
      final DateFormat outputFormat = DateFormat('y-MM-dd');
      return outputFormat.format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  String formatPrice(String price) {
    try {
      final numberFormat = NumberFormat("#,##0.00"); // Minglik va kasr qismini ajratishni sozlash
      double priceDouble = double.parse(price); // String qiymatni double ga o'zgartirish
      return numberFormat.format(priceDouble);
    } catch (e) {
      return price; // Agar parse qilishda xato bo'lsa, original qiymatni qaytarish
    }
  }


  @override
  Widget build(BuildContext context) {
    String formatDate(String dateTimeString) {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/logo.png',
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 150,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
        AboutItemTheme(title: "Dars xonasi:", about: room),
        AboutItemTheme(title: "Guruh narxi:", about: "${formatPrice(price)} so'm"),
        AboutItemTheme(title: "O'qituvchiga to'lov:", about: "${formatPrice(techer_paymart)} so'm"),
        AboutItemTheme(title: "O'qituvchiga bonus:", about: "${formatPrice(techer_bonus)} so'm"),
        AboutItemTheme(title: "Darslar boshlanish:", about: formatDate(lessen_start)),
        AboutItemTheme(title: "Darslar boshlanish:", about: formatDate(lessen_end)),
      ],
    );
  }

}
