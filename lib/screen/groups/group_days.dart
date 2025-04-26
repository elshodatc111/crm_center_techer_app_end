import 'package:flutter/material.dart';

class GroupDays extends StatelessWidget {
  final List<dynamic> days;
  const GroupDays({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dars kunlari', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 3,
      ),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final date = day['data'] ?? '';;
          final status = day['status'] ?? '';
          final users = day['user'] ?? [];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 2,
            color: Colors.white70,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      Text(
                        status=='true'?'Davomad Olindi':status=='false'?"Davomad olinmadi":"Davomad kutilmoqda",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: status=='true'?Colors.green:status=='false'?Colors.red:Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, userIndex) {
                      final user = users[userIndex];
                      final userName = user['user_name'] ?? '';
                      final status = user['status'] == 'true' ? '✅' : '❌';
                      
                      return ListTile(
                        dense: true,
                        leading: Text(
                          '${userIndex + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        title: Text(userName),
                        trailing: Text(
                          status,
                          style: TextStyle(
                            fontSize: 20,
                            color: user['status'] == 'true' ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
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
