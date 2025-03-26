import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yaml/yaml.dart';
import '../models/models.dart';
import '../services/services.dart';

class SpecProvider with ChangeNotifier {
  OpenApiSpec? _spec;
  bool _isLoading = false;
  String? _error;

  OpenApiSpec? get spec => _spec;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiService _apiService = ApiService();
  final ParserService _parserService = ParserService();

  Future<void> loadSpec(String url) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (url.isEmpty) {
        throw Exception('URL cannot be empty');
      }

      final specJson = await _apiService.fetchOpenApiSpec(url);
      _spec = _parserService.parseSpec(specJson);
      print('Spec updated: ${_spec?.title}');
    } catch (e) {
      if (e is http.ClientException) {
        _error = 'Network error: Failed to connect to the server. Please check your internet connection.';
      } else if (e.toString().contains('FormatException')) {
        _error = 'Invalid URL format. Please enter a valid URL (e.g., https://example.com/spec.json).';
      } else {
        _error = 'Failed to load spec: $e';
      }
      print('Error loading spec: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSpecFromFile(String content, String fileName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Map<String, dynamic> specJson;
      if (fileName.endsWith('.yaml') || fileName.endsWith('.yml')) {
        try {
          final yamlDoc = loadYaml(content);
          specJson = jsonDecode(jsonEncode(yamlDoc));
        } catch (e) {
          throw Exception('Invalid YAML format: $e');
        }
      } else {
        try {
          specJson = jsonDecode(content);
        } catch (e) {
          throw Exception('Invalid JSON format: $e');
        }
      }

      _spec = _parserService.parseSpec(specJson);
      print('Spec updated from file: ${_spec?.title}');
    } catch (e) {
      _error = 'Failed to parse file: $e';
      print('Error loading spec from file: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSpec() {
    _spec = null;
    _error = null;
    notifyListeners();
  }
}