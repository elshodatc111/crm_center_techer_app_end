import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymartCard extends StatelessWidget {
  final String groupName;
  final String amount;
  final String type;
  final String createdAt;

  const PaymartCard({
    super.key,
    required this.groupName,
    required this.amount,
    required this.type,
    required this.createdAt,
  });

  String formatAmount(String value) {
    final number = double.tryParse(value) ?? 0;
    return NumberFormat("#,##0", "uz_UZ").format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white70,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              groupName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Miqdor
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.attach_money, color: Colors.green),
                    SizedBox(height: 8.0,),
                    Text(
                      "${formatAmount(amount)} so'm",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.payment, color: Colors.deepPurple),
                    SizedBox(height: 8.0,),
                    Text(
                      type.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                    SizedBox(height: 8.0,),
                    Text(
                      createdAt.substring(0, 10),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
