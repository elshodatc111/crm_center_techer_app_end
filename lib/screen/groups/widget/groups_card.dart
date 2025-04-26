import 'package:flutter/material.dart';

class GroupsCard extends StatelessWidget {
  final Map<String, dynamic> group;
  final VoidCallback onTap;

  const GroupsCard({Key? key, required this.group, required this.onTap}) : super(key: key);

  // Holatga qarab rangni aniqlash
  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'end':
        return Colors.red;
      case 'new':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  // Holatga qarab labelni aniqlash
  String _getStatusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Aktiv';
      case 'end':
        return 'Yakunlangan';
      case 'new':
        return 'Yangi';
      default:
        return 'Noma\'lum';
    }
  }

  // Holatga qarab rasm URL'ini aniqlash
  String _getImageUrl(String status) {
    switch (status) {
      case 'active':
        return 'https://static1.tgstat.ru/channels/_0/3f/3fb0b6fb8b46846145613c754cd797d5.jpg';
      case 'end':
        return 'https://static1.tgstat.ru/channels/_0/3f/3fb0b6fb8b46846145613c754cd797d5.jpg';
      case 'new':
        return 'https://static1.tgstat.ru/channels/_0/3f/3fb0b6fb8b46846145613c754cd797d5.jpg';
      default:
        return 'https://static1.tgstat.ru/channels/_0/3f/3fb0b6fb8b46846145613c754cd797d5.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = group['status'] ?? 'unknown';
    final statusColor = _getStatusColor(status);
    final statusLabel = _getStatusLabel(status);
    final imageUrl = _getImageUrl(status);

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Rasm va holat belgisi
            Stack(
              alignment: Alignment.center,
              children: [
                // Rasm
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                  child: Image.asset(
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
                ),
                // Holat belgisi
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              ],
            ),
            // Kontent
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Guruh nomi
                  Center(
                    child: Text(
                      group['group_name'] ?? 'Noma\'lum guruh',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Boshlanish va tugash sanalari
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "Boshlanish: ${group['lessen_start'] ?? 'Noma\'lum'}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "Tugash: ${group['lessen_end'] ?? 'Noma\'lum'}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
