import 'dart:convert';

import 'package:crm_center_techer_app_end_atko_uz/screen/groups/widget/groups_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'group_page.dart';
import 'package:http/http.dart' as http;

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  late Future<List<Map<String, dynamic>>> _groupsFuture;
  static const String _baseUrl = 'https://crm-center.atko.tech/api/techer/groups';

  static Future<List<Map<String, dynamic>>> fetchGroups() async {
    final box = GetStorage();
    final String? token = box.read('token');
    if (token == null) {
      throw Exception('Token topilmadi.');
    }
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Guruhlar yuklab olinmadi: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _groupsFuture = fetchGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guruhlar", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _groupsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Xatolik yuz berdi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Guruhlar topilmadi.'));
          }

          final groups = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: groups.length,
            itemBuilder: (ctx, index) {
              final group = groups[index];
              return GroupsCard(
                group: group,
                onTap: () {
                  Get.to(() => GroupPage(
                    id: group['id'],
                    groupName: group['group_name'],
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
