import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AboutItemTheme extends StatelessWidget {
  final String title;
  final String about;
  AboutItemTheme({super.key, required this.title, required this.about});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w600),),
          Text(about, style: TextStyle(fontSize: 16.0),),
        ],
      ),
    );
  }
}
