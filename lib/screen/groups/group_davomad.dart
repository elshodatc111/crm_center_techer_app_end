import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class GroupDavomad extends StatefulWidget {
  final List<dynamic> users;
  final int groupId;
  const GroupDavomad({super.key, required this.users, required this.groupId});

  @override
  State<GroupDavomad> createState() => _GroupDavomadState();
}

class _GroupDavomadState extends State<GroupDavomad> {
  late Map<int, bool> attendanceStatus;

  @override
  void initState() {
    super.initState();
    attendanceStatus = {for (var user in widget.users) user['id']: true};
  }

  Future<void> _submitAttendance() async {
    final box = GetStorage();
    final String? token = box.read('token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token topilmadi')),
      );
      return;
    }

    final List<Map<String, dynamic>> attendances = attendanceStatus.entries.map((entry) {
      return {
        'user_id': entry.key,
        'group_id': widget.groupId,
        'status': entry.value ? 1 : 0,
      };
    }).toList();

    final url = Uri.parse('https://crm-center.atko.tech/api/techer/davomad');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'attendances': attendances}),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Davomad saqlandi!')),
      );
      Get.back(result: true); // Qaytishda true yuboramiz
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Davomad olish', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 3,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (context, index) {
                final user = widget.users[index];
                return Card(
                  color: Colors.white70,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(user['user_name']),
                    subtitle: Text(user['phone1']),
                    trailing: Switch(
                      value: attendanceStatus[user['id']] ?? true,
                      onChanged: (bool value) {
                        setState(() {
                          attendanceStatus[user['id']] = value;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _submitAttendance,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Davomadni saqlash',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
