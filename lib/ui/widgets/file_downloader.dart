import 'package:flutter/material.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data'; // Add this import for Uint8List

class FileDownloader extends StatelessWidget {
  final Uint8List data;
  final String fileName;
  final String fileExtension;
  final VoidCallback? onSuccess;
  final Function(String)? onError;

  const FileDownloader({
    Key? key,
    required this.data,
    required this.fileName,
    this.fileExtension = 'json',
    this.onSuccess,
    this.onError,
  }) : super(key: key);

  Future<void> _downloadFile(BuildContext context) async {
    try {
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: data,
        ext: fileExtension,
        mimeType: MimeType.json,
      );
      if (onSuccess != null) {
        onSuccess!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File downloaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (onError != null) {
        onError!(e.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.download, color: Colors.black54),
      tooltip: 'Download File',
      onPressed: () => _downloadFile(context),
    );
  }
}