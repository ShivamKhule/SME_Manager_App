import "dart:typed_data";
import "package:flutter/material.dart";
import "package:share_plus/share_plus.dart";
import "package:syncfusion_flutter_pdf/pdf.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<int>? pdfDocList;
  Future<void> generatePdf() async {
    PdfDocument document = PdfDocument();
    document.pages.add().graphics.drawString(
          'Hello World!',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: const Rect.fromLTWH(0, 0, 150, 20),
        );

    pdfDocList = await document.save();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await generatePdf();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MainApp'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await Share.shareXFiles(
              [
                XFile.fromData(
                  Uint8List.fromList(pdfDocList!),
                  mimeType: "application/pdf",
                ),
              ],
            );
          },
          child: const Text("Share Document/URL"),
        ),
      ),
    );
  }
}
