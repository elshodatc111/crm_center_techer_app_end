import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupUsers extends StatelessWidget {
  final List<dynamic> users;

  const GroupUsers({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final NumberFormat numberFormat = NumberFormat("#,##0", "en_US");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Guruh talabalari",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 3,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final formattedBalance = numberFormat.format(user['balans']);
            return Card(
              elevation: 2,
              color: Colors.white70,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.0,),
                    Text(user['user_name'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                    SizedBox(height: 8.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('Telefon raqam',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w600),),
                            SizedBox(height: 4.0,),
                            Text('${user['phone1']}'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Balansi',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w600),),
                            SizedBox(height: 4.0,),
                            Text('${formattedBalance} so\'m'),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
