import "package:flutter/services.dart";
import 'dart:typed_data';

final Uint8List _fotoKosong = Uint8List(0);

Future getIp() async => await rootBundle.loadString("assets/ip.txt");
late String ip;

String get urlApi => "http://$ip/latihan_crud/alumni.php";
String get urlGambar => "http://$ip/latihan_crud/foto";
