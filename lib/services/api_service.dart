import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yaml/yaml.dart';

class ApiService {
  Future<Map<String, dynamic>> fetchOpenApiSpec(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Check if the response is YAML or JSON
      if (url.endsWith('.yaml') || url.endsWith('.yml')) {
        final yamlDoc = loadYaml(response.body);
        return jsonDecode(jsonEncode(yamlDoc)); // Convert YAML to JSON
      } else {
        return jsonDecode(response.body);
      }
    } else {
      throw Exception('Failed to load OpenAPI spec');
    }
  }
}