import 'dart:convert';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' show AnchorElement, Blob, Url;

class FileDownloader {
  static Future<void> downloadFile(String content, String fileName) async {
    if (kIsWeb) {
      // On web, create a downloadable link
      final blob = Blob([utf8.encode(content)]);
      final url = Url.createObjectUrlFromBlob(blob);
      final anchor = AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      Url.revokeObjectUrl(url);
    } else {
      // On desktop, save to the downloads directory
      final directory = await getDownloadsDirectory();
      if (directory != null) {
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(content);
      } else {
        throw Exception('Could not access downloads directory');
      }
    }
  }
}