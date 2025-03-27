import 'dart:convert';

class PostmanService {
  static Map<String, dynamic> convertToPostmanCollection(Map<String, dynamic> spec) {
    // Extract title from the spec (if available)
    final title = spec['info']?['title']?.toString() ?? 'API Collection';

    // Extract base URL (if available)
    String? baseUrl;
    if (spec['servers'] != null && spec['servers'] is List && spec['servers'].isNotEmpty) {
      baseUrl = spec['servers'][0]['url']?.toString();
    }

    // Convert paths to Postman items
    final items = _convertPathsToItems(spec, baseUrl);

    // Create the Postman Collection
    final collection = {
      'info': {
        'name': title,
        'schema': 'https://schema.getpostman.com/json/collection/v2.1.0/collection.json',
      },
      'item': items,
    };

    return collection;
  }

  static List<Map<String, dynamic>> _convertPathsToItems(Map<String, dynamic> spec, String? baseUrl) {
    final items = <Map<String, dynamic>>[];

    // Check if paths exist in the spec
    if (spec['paths'] == null || spec['paths'] is! Map) {
      return items;
    }

    // Iterate over each path in the OpenAPI spec
    final paths = spec['paths'] as Map<String, dynamic>;
    for (final pathEntry in paths.entries) {
      final path = pathEntry.key;
      final pathData = pathEntry.value as Map<String, dynamic>;

      // Iterate over each method in the path (e.g., get, post)
      for (final methodEntry in pathData.entries) {
        final method = methodEntry.key.toString().toUpperCase();
        final operation = methodEntry.value as Map<String, dynamic>;

        // Skip if the method is not a valid HTTP method
        if (!['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS', 'HEAD'].contains(method)) {
          continue;
        }

        // Extract description (if available)
        final description = operation['description']?.toString() ?? operation['summary']?.toString();

        // Create the Postman item for this endpoint
        final item = {
          'name': path,
          'request': {
            'method': method,
            'url': {
              'raw': '${baseUrl ?? ''}$path',
              'host': [baseUrl ?? ''],
              'path': path.split('/').where((p) => p.isNotEmpty).toList(),
            },
            'description': description,
          },
          'response': [],
        };

        items.add(item);
      }
    }

    return items;
  }

  static String generatePostmanCollectionJson(Map<String, dynamic> spec) {
    final collection = convertToPostmanCollection(spec);
    return jsonEncode(collection);
  }
}