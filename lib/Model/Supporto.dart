import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class SaveFile {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

class Supporto {
  static convalidaTesto(String testo) {
    bool check = false;
    check = testo.contains("'");
    check = testo.contains("ì");
    check = testo.contains("à");
    check = testo.contains("è");
    return check;
  }

  static Future<String> castDocumentToBase64(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File pdfifle = new File.fromUri(myUri);
    List<int> imageBytes = pdfifle.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  static Future<bool> verificaConnessione() async {
    bool ret = true;
    try {
      final result = await InternetAddress.lookup("google.it");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        log('connected');
      }
    } on SocketException catch (_) {
      ret = false;
      log('not connected');
    }

    return ret;
  }

  static Future<File> getImageFromNetwork(String url) async {
    File file = await DefaultCacheManager().getSingleFile(url);
    return file;
  }
}
