import 'package:flutter/material.dart';
import "dart:ui";
import "globals.dart";
import "alumni.dart";
import "entri_alumni.dart";
import "cetak_album.dart";

extension on String {
  String toIndonesianDate() {
    var nmBulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    var komponen = split("-");
    var thn = int.parse(komponen[0]);
    var bln = nmBulan[int.parse(komponen[1])-1];
    var tgl = int.parse(komponen[2]);
    return '$tgl $bln $thn';
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    scrollBehavior: MaterialScrollBehavior().copyWith(
      dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      },
    ),
    home: Home(),
  );
}

class Home extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  Future inisialisasi() async {
    await getIp().then((value) => ip = value);
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terhubung ke $ip")),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    inisialisasi();
  }

  @override
  Widget build(BuildContext context) {
    var alumni = Alumni();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("E-Book Alumni Universitas XYZ"),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    final pesan = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EntriAlumni(),
                      ),
                    );
                    if (context.mounted && pesan != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(pesan),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      setState(() => daftarAlumni = daftarAlumni);
                    }
                  },
                  tooltip: 'Tambah data alumni',
                  icon: Icon(Icons.add),
                  style: ButtonStyle(
                    foregroundColor:
                    WidgetStateProperty.all(Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      setState(() => daftarAlumni = daftarAlumni),
                  tooltip: "Refresh data alumni",
                  icon: Icon(Icons.refresh),
                  style: ButtonStyle(
                    foregroundColor:
                    WidgetStateProperty.all(Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await Alumni().tampil(context); // ⬅️ WAJIB
                    if (!context.mounted) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CetakAlbum()),
                    );
                  },
                  tooltip: "Cetak album alumni",
                  icon: Icon(Icons.print),
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                ),
                SizedBox(width: 10.0),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: FutureBuilder(
          future: alumni.tampil(context),
          builder: (_, snapshot) => switch (null) {
            _ when snapshot.hasData && snapshot.data!.isNotEmpty =>
                InteractiveViewer(
                  constrained: false,
                  scaleEnabled: false,
                  child: DataTable(
                    showCheckboxColumn: false,
                    dataRowMaxHeight: 60.0,
                    headingTextStyle:
                    TextStyle(fontWeight: FontWeight.bold),
                    columns: [
                      DataColumn(
                        headingRowAlignment:
                        MainAxisAlignment.center,
                        label: Text("Aksi"),
                      ),
                      DataColumn(
                        headingRowAlignment:
                        MainAxisAlignment.center,
                        label: Text("NIM"),
                      ),
                      DataColumn(
                        headingRowAlignment:
                        MainAxisAlignment.center,
                        label: Text("Foto"),
                      ),
                      DataColumn(
                        headingRowAlignment:
                        MainAxisAlignment.center,
                        label: Text("Nama Alumni"),
                      ),
                      DataColumn(
                        headingRowAlignment:
                        MainAxisAlignment.center,
                        label: Text("Program Studi"),
                      ),
                      DataColumn(
                        headingRowAlignment:
                        MainAxisAlignment.center,
                        label: Text("Tempat dan Tanggal Lahir"),
                      ),
                      DataColumn(
                        headingRowAlignment:
                        MainAxisAlignment.center,
                        label: Text("Alamat"),
                      ),
                      DataColumn(
                        headingRowAlignment:
                        MainAxisAlignment.center,
                        label: Text("Nomor HP"),
                      ),
                      DataColumn(
                        headingRowAlignment:
                        MainAxisAlignment.center,
                        label: Text("Tahun Lulus"),
                        numeric: true,
                      ),
                    ],
                    rows: daftarAlumni.map((alumni) {
                      var fgSel = alumni.prodi == "Manajemen Informatika"
                          ? Colors.black
                          : Colors.white;
                      var bgBaris = switch (alumni.prodi) {
                        "Teknik Informatika" => Color(0xffff7f00),
                        "Sistem Informasi" => Color(0xff0000ff),
                        "Manajemen Informatika" => Color(0xffffff00),
                        "Komputerisasi Akuntansi" => Color(0xff4b3621),
                        "Bisnis Digital" => Color(0xff800000),
                        _ => Color(0xff8f00ff),
                      };

                      return DataRow(
                        color: WidgetStatePropertyAll(bgBaris),
                        cells: [
                          DataCell(
                            Center(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final pesan = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EntriAlumni(
                                            nim: alumni.nim,
                                          ),
                                        ),
                                      );

                                      if (context.mounted && pesan != null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(pesan),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                        setState(
                                              () => daftarAlumni = daftarAlumni,
                                        );
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      WidgetStatePropertyAll(
                                          Colors.orangeAccent),
                                      foregroundColor:
                                      WidgetStatePropertyAll(
                                          Colors.white),
                                    ),
                                    icon: Icon(Icons.edit),
                                    tooltip: "Ubah",
                                  ),
                                  IconButton(
                                    onPressed:() => showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => AlertDialog(
                                        title: Text("Konfirmasi"),
                                        content: Text(
                                          "Apakah Anda yakin akan menghapus "
                                              "data alumni dengan NIM "
                                              "[${alumni.nim}]?",
                                        ),
                                        actions: [
                                          ElevatedButton.icon(
                                            onPressed: () => Navigator.of(context).pop(),
                                            label: Text("Tidak"),
                                            icon: Icon(Icons.close),
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all(Colors.greenAccent),
                                              foregroundColor: WidgetStateProperty.all(Colors.white),
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              setState(() => daftarAlumni = daftarAlumni);
                                              Navigator.of(context).pop(
                                                alumni.hapus(context, alumni.nim),
                                              );
                                            },
                                            label: Text("Ya"),
                                            icon: Icon(Icons.check),
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all(Colors.redAccent),
                                              foregroundColor: WidgetStateProperty.all(Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).then((pesan) {
                                      if (pesan != null && context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(pesan),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                    }), // IconButton
                                    style: ButtonStyle(
                                      backgroundColor:
                                      WidgetStatePropertyAll(
                                          Colors.redAccent),
                                      foregroundColor:
                                      WidgetStatePropertyAll(
                                          Colors.white),
                                    ),
                                    icon: Icon(Icons.delete),
                                    tooltip: "Hapus",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                           Center(
                             child: Text(
                               alumni.nim,
                               style: TextStyle(color: fgSel),
                             ),
                           ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 70,
                              height: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  "$urlGambar/${alumni.nim}.jpeg?${DateTime.now().millisecondsSinceEpoch}",
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.person, size: 40),
                                ),
                              ),
                            ),
                          ),

                          DataCell(
                            Text(
                              alumni.nmAlumni,
                              style: TextStyle(color: fgSel),
                            ),
                          ),
                          DataCell(
                            Text(
                              alumni.prodi,
                              style: TextStyle(color: fgSel),
                            ),
                          ),
                          DataCell(
                            Text(
                            "${alumni.tmptLahir}, "
                            "${alumni.tglLahir.toIndonesianDate()}",
                            style: TextStyle(color: fgSel),
                            ),
                          ),
                          DataCell(
                            Text(
                              alumni.alamat,
                              style: TextStyle(color: fgSel),
                            ),
                          ),
                          DataCell(
                            Text(
                              alumni.noHp,
                              style: TextStyle(color: fgSel),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                "${alumni.thnLulus}",
                                style: TextStyle(color: fgSel),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            _ when snapshot.hasError => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.yellow,
                  size: 200.0,
                ),
                Text(
                  "Tidak dapat memuat data:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            _ when snapshot.connectionState == ConnectionState.waiting =>
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text("Memuat...", textAlign: TextAlign.center),
                    ],
                ),
          _ => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel, color: Colors.red, size: 200.0),
              Text(
                "Tidak ada data",
                style: TextStyle(fontSize: 32.0, color: Colors.grey),
              ),
            ],
          ),
          },
        ),
      ),
    );
  }
}

void main() => runApp(MainApp());
