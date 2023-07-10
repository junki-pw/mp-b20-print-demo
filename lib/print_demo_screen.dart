import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mp_b20_print_demo/pdf_creator.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class PrintDemoScreen extends StatelessWidget {
  const PrintDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          const Uuid().v4(),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async {
              final pdf = await PdfCreator.createReceipt();

              /// PDFをバイトデータに変換
              final pdfBytes = await pdf.save();

              /// バイトデータをBase64に変換
              final base64 = base64Encode(pdfBytes);

              /// 印刷アプリに遷移
              _launchUrl(base64);
            },
            child: const Text('印刷する'),
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) async {
          final pdf = await PdfCreator.createReceipt();
          return await pdf.save();
        },
      ),
    );
  }

  Future<void> _launchUrl(String base64) async {
    const String baseUrl = 'siiprintagent://1.0/print?';

    final List<String> paramlist = [
      'BtKeepConnect=always',
      'Format=pdf',
      // 'PaperWidth=58',
      // 'FitToWidth=yes',
      'Data=$base64',
    ];

    final String params = paramlist.join('&');
    final uri = Uri.parse(baseUrl + params);
    await launchUrl(uri);
  }
}
