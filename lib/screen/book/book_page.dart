import 'dart:convert';
import 'package:crm_center_techer_app_end_atko_uz/screen/book/show_book.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Link ochish uchun
import 'package:get/get.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  List<dynamic> books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final box = GetStorage();
    final String? token = box.read('token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token topilmadi')),
      );
      return;
    }

    final response = await http.get(
      Uri.parse('https://crm-center.atko.tech/api/techer/books'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        books = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitoblar', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 3,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: Colors.white70,
            child: ListTile(
              title: Text(book['book_name']),
              trailing: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
              onTap: () {
                print(book['booh_url']);
                Get.to(()=>ShowBook(book_name: book['book_name'], booh_url: book['booh_url']));
              },
            ),
          );
        },
      ),
    );
  }
}
