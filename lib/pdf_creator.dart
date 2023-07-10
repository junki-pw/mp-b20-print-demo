import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfCreator {
  /// レシートを作成
  static Future<pw.Document> createReceipt() async {
    /// 印刷物のフォントを確定させる
    final fontData = await rootBundle.load(
      'assets/fonts/NotoSansJP-Regular.ttf',
    );
    final font = pw.Font.ttf(fontData);

    final pdf = pw.Document(author: 'Me');

    /// width を 4.8 ✖️ cm で設定する以外は無い
    /// 結局は 単位　が違うかった
    const double inch = 72.0;
    const double cm = inch / 2.54;
    const double printerWidth = 4.8 * cm;

    ///todo ここの height を適当な変数にしても印刷できるようにしたい
    const height = printerWidth * 0.12 * 3;

    /// 表紙
    final cover = pw.Page(
      pageTheme: pw.PageTheme(
        theme: pw.ThemeData.withFont(
          base: font,
        ),
        pageFormat: const PdfPageFormat(
          printerWidth,
          height,
        ),
      ),
      build: (context) {
        return pw.Container(
          width: printerWidth,
          height: height,
          child: pw.Column(
            children: [
              pw.Text(
                'あ' * 15,
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),
            ],
          ),
        );
      },
    );

    pdf.addPage(cover);

    return pdf;
  }
}
