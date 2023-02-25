import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<pw.Document> generatePdf() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Center(
        child: pw.Column(
          children: [
            //pw.Image(FileImage(File('baam.pdf'), scale: 3.0)),
            pw.Text('Portfolio', style: const pw.TextStyle(fontSize: 20)),
          ],
        ),
      ),
    ),
  );
  return pdf;
}
