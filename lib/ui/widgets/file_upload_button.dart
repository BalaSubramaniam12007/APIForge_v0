import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io' show File;

class FileUploadButton extends StatelessWidget {
  final Function(String, String) onFileSelected;

  const FileUploadButton({
    Key? key,
    required this.onFileSelected,
  }) : super(key: key);

  Future<void> pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'yaml', 'yml'],
      );

      if (result != null && result.files.isNotEmpty) {
        String fileName = result.files.single.name;
        String content;

        if (kIsWeb) {
          // On web, use the bytes property to read the file content
          final bytes = result.files.single.bytes;
          if (bytes != null) {
            content = String.fromCharCodes(bytes);
          } else {
            throw Exception('No file content available on web');
          }
        } else {
          // On non-web platforms, use dart:io to read the file content
          content = await _readFileOnNonWeb(result);
        }

        onFileSelected(content, fileName);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String> _readFileOnNonWeb(FilePickerResult result) async {
    // This method is only called when kIsWeb is false, so dart:io is available
    final filePath = result.files.single.path;
    if (filePath != null) {
      final file = File(filePath);
      return await file.readAsString();
    } else {
      throw Exception('No file path available on non-web platform');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: () => pickFile(context),
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload OpenAPI Spec'),
      ),
    );
  }
}