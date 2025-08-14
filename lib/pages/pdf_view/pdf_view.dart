import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key, required this.path, required this.doc});
  final String path;
  final pw.Document doc;
  @override
  State<PdfView> createState() => PdfViewState();
}

class PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('预览')),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Platform.isAndroid || Platform.isIOS
            ? PDFView(
                filePath: widget.path,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: false,
                backgroundColor: Colors.grey,
              )
            : PdfPreview(
                build: (format) => widget.doc.save(),
                // 桌面平台配置
                allowSharing: true,
                allowPrinting: true,
                pdfFileName: widget.path.split('/').last,
              ),
      ),
    );
  }
}
