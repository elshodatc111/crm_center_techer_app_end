import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ShowBook extends StatefulWidget {
  final String book_name;
  final String booh_url;

  const ShowBook({super.key, required this.book_name, required this.booh_url});

  @override
  State<ShowBook> createState() => _ShowBookState();
}

class _ShowBookState extends State<ShowBook> {
  bool _isLoading = true;
  String? _localFilePath;

  @override
  void initState() {
    super.initState();
    _loadOrDownloadPDF();
  }

  Future<void> _loadOrDownloadPDF() async {
    try {
      final fileName = path.basename(widget.booh_url);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) {
        // Fayl mavjud bo'lsa, uni o'qiymiz
        setState(() {
          _localFilePath = file.path;
          _isLoading = false;
        });
      } else {
        // Fayl yo'q bo'lsa yuklab olib saqlaymiz
        final response = await http.get(Uri.parse(widget.booh_url));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
          setState(() {
            _localFilePath = file.path;
            _isLoading = false;
          });
        } else {
          throw Exception('PDF yuklanmadi. Kod: ${response.statusCode}');
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik yuz berdi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book_name, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 3,
      ),
      body: Stack(
        children: [
          if (_localFilePath != null)
            SfPdfViewer.file(
              File(_localFilePath!),
              canShowScrollHead: true,
              canShowScrollStatus: true,
            ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
