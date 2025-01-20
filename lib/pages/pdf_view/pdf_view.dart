import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key, required this.path});
  final String path;
  @override
  State<PdfView> createState() => PdfViewState();
}

class PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('预览'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: PDFView(
          filePath: widget.path,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }
}
