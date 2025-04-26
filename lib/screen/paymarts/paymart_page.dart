import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:crm_center_techer_app_end_atko_uz/screen/paymarts/widget/paymart_card.dart';

class PaymartPage extends StatefulWidget {
  const PaymartPage({super.key});
  @override
  State<PaymartPage> createState() => _PaymartPageState();
}

class _PaymartPageState extends State<PaymartPage> {
  late Future<List<Map<String, dynamic>>> _paymentsFuture;
  static const String _baseUrl = 'https://crm-center.atko.tech/api/techer/paymart';

  final box = GetStorage();

  Future<List<Map<String, dynamic>>> fetchPayments() async {
    final token = box.read('token'); // ← Tokenni GetStorage'dan o'qish
    if (token == null) {
      throw Exception("Token topilmadi");
    }

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> messageList = decoded['message'];
      return messageList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('To\'lovlar yuklab olinmadi: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _paymentsFuture = fetchPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To'lovlar", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 3,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _paymentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Xatolik: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('To\'lovlar topilmadi'));
          }
          final payments = snapshot.data!;
          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              final groupName = payment['group_name'] ?? 'Noma\'lum';
              final amount = payment['amount'] ?? '0';
              final type = payment['type'] ?? '-';
              final date = payment['created_at']?.substring(0, 10) ?? '-';
              return PaymartCard(groupName: groupName, amount: amount, type: type, createdAt: date);
            },
          );
        },
      ),
    );
  }
}
