import 'dart:typed_data';
import "package:flutter/material.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:printing/printing.dart";
import "alumni.dart";



extension on List {
  List chunked(int size) {
    if (size <= 0) {
      throw ArgumentError("Chunk size must be greater than 0.");
    }

    var chunks = [];
    for (var i = 0; i < length; i += size) {
      int endIndex = (i + size > length) ? length : i + size;
      chunks.add(sublist(i, endIndex));
    }
    return chunks;
  }
}

extension on String {
  String toIndonesianDate() {
    var nmBulan = [
      "", "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember",
    ];

    var komponen = split("-");
    var thn = int.parse(komponen[0]);
    var bln = nmBulan[int.parse(komponen[1])];
    var tgl = int.parse(komponen[2]);
    return "$tgl $bln $thn";
  }
}

Uint8List fotoAman(int index) {
  final foto = daftarFoto[index];
  if (foto != null) return foto;

  // fallback: gambar abu-abu sederhana
  return Uint8List.fromList(List.filled(84 * 108 * 3, 200));
}

class CetakAlbum extends StatelessWidget {
  final daftarAlumniPerHalaman = daftarAlumni.chunked(6);

  @override
  Widget build(BuildContext context) {
    final daftarAlumniPerHalaman = daftarAlumni.chunked(6);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 103, 80, 164),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: "Kembali",
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PdfPreview(
        initialPageFormat: PdfPageFormat.a4,
        build: (_) {
          final pdf = pw.Document();
          pdf.addPage(
            pw.MultiPage(
              maxPages: daftarAlumniPerHalaman.length,
              pageFormat: PdfPageFormat.a4,
              build: (_) =>
                  List.generate(
                    daftarAlumniPerHalaman.length,
                        (i) =>
                        pw.Column(
                          children: [
                            pw.Align(
                              alignment: pw.Alignment.topCenter,
                              child: (i > 0)
                                  ? pw.SizedBox()
                                  : pw.Text(
                                "ALBUM ALUMNI UNIVERSITAS XYZ",
                                style: pw.TextStyle(fontSize: 18.0),
                              ),
                            ),
                            pw.SizedBox(height: 20.0),
                            pw.Table(
                              children: List.generate(
                                  daftarAlumniPerHalaman[i].length, (j,) {
                                var alumni = daftarAlumniPerHalaman[i][j];
                                return pw.TableRow(
                                  children: [
                                    pw.Container(
                                      height: 113.0,
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border(
                                          bottom: pw.BorderSide(
                                            color: PdfColors.black,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: pw.Padding(
                                        padding: pw.EdgeInsets.all(1.0),
                                        child: pw.Center(
                                          child: () {
                                            final index = daftarAlumni.indexOf(
                                                alumni);
                                            Uint8List? foto;

                                            if (index >= 0 &&
                                                index < daftarFoto.length) {
                                              foto = daftarFoto[index];
                                            }

                                            if (foto == null || foto.isEmpty) {
                                              return pw.Container(
                                                width: 84,
                                                height: 108,
                                                alignment: pw.Alignment.center,
                                                decoration: pw.BoxDecoration(
                                                  border: pw.Border.all(
                                                      color: PdfColors.grey),
                                                ),
                                                child: pw.Text(
                                                  "TIDAK ADA FOTO",
                                                  style: pw.TextStyle(
                                                      fontSize: 8),
                                                  textAlign: pw.TextAlign
                                                      .center,
                                                ),
                                              );
                                            }

                                            return pw.Image(
                                              pw.MemoryImage(foto),
                                              width: 84,
                                              height: 108,
                                              fit: pw.BoxFit.contain,
                                            );
                                          }(),
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border(
                                          bottom: pw.BorderSide(
                                            color: PdfColors.black,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: pw.Padding(
                                        padding: pw.EdgeInsets.all(1.0),
                                        child: pw.Align(
                                          alignment: pw.Alignment.topLeft,
                                          child: pw.Text(
                                            "NIM: ${alumni.nim}\n"
                                                "Nama Alumni: ${alumni
                                                .nmAlumni}\n"
                                                "Program Studi: ${alumni
                                                .prodi}\n"
                                                "Tempat dan Tanggal Lahir: "
                                                "${alumni.tmptLahir}, "
                                                "${(alumni.tglLahir as String)
                                                .toIndonesianDate()}\n"
                                                "Alamat: ${alumni.alamat}\n"
                                                "Nomor HP: ${alumni.noHp}\n"
                                                "Tahun Lulus: ${alumni
                                                .thnLulus}\n\n",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                  ),
            ),
          );
          return pdf.save();
        },
      ),
    );
  }
}