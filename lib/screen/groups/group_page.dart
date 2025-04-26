import 'dart:convert';
import 'package:crm_center_techer_app_end_atko_uz/screen/groups/group_davomad.dart';
import 'package:crm_center_techer_app_end_atko_uz/screen/groups/group_days.dart';
import 'package:crm_center_techer_app_end_atko_uz/screen/groups/group_users.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crm_center_techer_app_end_atko_uz/screen/groups/widget/group_about.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Sana formatlash uchun

class GroupPage extends StatefulWidget {
  final int id;
  final String groupName;
  const GroupPage({super.key, required this.id, required this.groupName});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late Map<String, dynamic> groupData;
  late List<dynamic> allUsers;
  late List<dynamic> days;
  late List<dynamic> groupDay;
  late List<dynamic> davomad;
  bool _isLoading = true;
  bool _isTodayLesson = false;

  static const String _apiUrl = 'https://crm-center.atko.tech/api/techer/group/';

  @override
  void initState() {
    super.initState();
    _fetchGroupData();
  }

  Future<void> _fetchGroupData() async {
    setState(() {
      _isLoading = true;
    });
    final box = GetStorage();
    final String? token = box.read('token');
    if (token == null) {
      throw Exception('Token topilmadi.');
    }
    final response = await http.get(
      Uri.parse('$_apiUrl${widget.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      setState(() {
        groupData = decoded;
        allUsers = groupData['users'] ?? [];
        groupDay = groupData['davomad_history'] ?? [];
        davomad = groupData['users'] ?? [];
        days = groupData['days'] ?? [];
        _isLoading = false;
      });
      _checkIfTodayIsLesson();
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ma\'lumotni olishda xato yuz berdi')),
      );
    }
  }

  void _checkIfTodayIsLesson() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _isTodayLesson = days.any((day) => day['data'] == today);
    setState(() {}); // State yangilash
  }

  Future<void> _navigateToDavomad() async {
    final result = await Get.to(() => GroupDavomad(users: davomad, groupId: groupData['group']['id']));
    if (result == true) {
      await _fetchGroupData(); // Agar davomad saqlansa, yangilash
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 3,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            GroupAbout(
              group_name: groupData['group']['group_name'],
              room: groupData['group']['room'],
              price: groupData['group']['price'],
              lessen_count: groupData['group']['lessen_count'],
              lessen_start: groupData['group']['lessen_start'],
              lessen_end: groupData['group']['lessen_end'],
              techer_paymart: groupData['group']['techer_paymart'],
              techer_bonus: groupData['group']['techer_bonus'],
              status: groupData['group']['status'],
            ),
            const SizedBox(height: 16),
            _buildButton(
              label: 'Guruh talabalari',
              color: Colors.blue,
              onPressed: () {
                Get.to(() => GroupUsers(users: allUsers));
              },
            ),
            const SizedBox(height: 16),
            _buildButton(
              label: 'Dars kunlari',
              color: Colors.brown,
              onPressed: () {
                Get.to(() => GroupDays(days: groupDay));
              },
            ),
            const SizedBox(height: 16),
            _buildButton(
              label: 'Davomad olish',
              color: _isTodayLesson ? Colors.orange : Colors.grey,
              onPressed: _isTodayLesson ? _navigateToDavomad : null,
            ),
            if (!_isTodayLesson)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Center(
                  child: Text(
                    'Bugun davomad kuni emas!',
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required Color color, required VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
