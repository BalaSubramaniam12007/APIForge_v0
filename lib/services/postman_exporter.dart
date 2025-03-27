import 'dart:convert';
import '../models/models.dart';

class PostmanExporter {
  Map<String, dynamic> exportToPostmanCollection(OpenApiSpec spec) {
    if (spec == null) {
      throw Exception('No specification loaded to export');
    }

    final collection = {
      "info": {
        "_postman_id": "api-forge-${DateTime.now().millisecondsSinceEpoch}",
        "name": spec.title ?? "ApiForge Collection",
        "description": spec.description ?? "Exported from ApiForge",
        "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
      },
      "item": <Map<String, dynamic>>[],
      "variable": [
        {
          "key": "baseUrl",
          "value": "https://api.example.com",
          "description": "Base URL of the API"
        }
      ]
    };

    // Group endpoints by path
    final pathGroups = <String, List<Endpoint>>{};
    for (var endpoint in spec.paths!.values) {
      pathGroups.putIfAbsent(endpoint.path, () => []).add(endpoint);
    }

    // Convert each path group to a Postman folder
    for (var path in pathGroups.keys) {
      final endpoints = pathGroups[path]!;
      final folder = {
        "name": path,
        "item": endpoints.map((endpoint) {
          // Handle path variables
          final pathSegments = endpoint.path.split('/').where((p) => p.isNotEmpty).toList();
          final variables = <Map<String, dynamic>>[];
          for (var segment in pathSegments) {
            if (segment.startsWith('{') && segment.endsWith('}')) {
              variables.add({
                "key": segment.substring(1, segment.length - 1),
                "value": "",
                "description": "Path parameter"
              });
            }
          }

          return {
            "name": "${endpoint.method} ${endpoint.path}",
            "request": {
              "method": endpoint.method,
              "header": endpoint.headers?.map((header) {
                    return {
                      "key": header.name ?? "",
                      "value": "",
                      "description": header.description,
                      "type": "text"
                    };
                  }).toList() ??
                  [],
              "url": {
                "raw": "{{baseUrl}}${endpoint.path}",
                "host": ["{{baseUrl}}"],
                "path": pathSegments,
                "variable": variables,
                "query": endpoint.parameters
                        ?.where((param) => param.inType == 'query')
                        .map((param) {
                      return {
                        "key": param.name ?? "",
                        "value": "",
                        "description": param.description
                      };
                    }).toList() ??
                    [],
              },
              "body": endpoint.requestBody != null
                  ? {
                      "mode": "raw",
                      "raw": endpoint.requestBody!.content != null &&
                              endpoint.requestBody!.content!['application/json'] != null
                          ? jsonEncode(endpoint.requestBody!.content!['application/json'])
                          : "",
                      "options": {
                        "raw": {"language": "json"}
                      }
                    }
                  : null,
              "description": endpoint.description
            },
            "response": endpoint.responses?.map((response) {
                  return {
                    "name": "Response ${response.statusCode}",
                    "originalRequest": {
                      "method": endpoint.method,
                      "header": endpoint.headers?.map((header) {
                            return {
                              "key": header.name ?? "",
                              "value": "",
                              "description": header.description,
                              "type": "text"
                            };
                          }).toList() ??
                          [],
                      "url": {
                        "raw": "{{baseUrl}}${endpoint.path}",
                        "host": ["{{baseUrl}}"],
                        "path": pathSegments,
                        "variable": variables,
                      }
                    },
                    "status": response.statusCode ?? "Unknown",
                    "code": int.tryParse(response.statusCode ?? "200") ?? 200,
                    "body": response.content != null &&
                            response.content!['application/json'] != null
                        ? jsonEncode(response.content!['application/json'])
                        : "",
                    "header": [
                      {
                        "key": "Content-Type",
                        "value": "application/json"
                      }
                    ]
                  };
                }).toList() ??
                []
          };
        }).toList()
      };
      (collection["item"] as List<Map<String, dynamic>>).add(folder);
    }

    return collection;
  }
}