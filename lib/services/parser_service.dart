import '../models/models.dart';

class ParserService {
  OpenApiSpec parseSpec(Map<String, dynamic> specJson) {
    final paths = <String, Endpoint>{};
    final pathData = specJson['paths'] as Map<String, dynamic>? ?? {};

    pathData.forEach((path, methods) {
      (methods as Map<String, dynamic>).forEach((method, details) {
        // Parse parameters
        final List<Parameter> parameters = [];
        final List<Parameter> headers = [];
        final params = (details['parameters'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
        for (var param in params) {
          final parameter = Parameter.fromJson(param);
          // Skip parameters with null name or inType
          if (parameter.name == null || parameter.inType == null) {
            continue;
          }
          if (parameter.inType == 'header') {
            headers.add(parameter);
          } else {
            parameters.add(parameter);
          }
        }

        // Parse request body
        RequestBody? requestBody;
        if (details['requestBody'] != null) {
          requestBody = RequestBody.fromJson(details['requestBody']);
        }

        // Parse responses
        final List<Response> responses = [];
        final responseData = details['responses'] as Map<String, dynamic>? ?? {};
        responseData.forEach((statusCode, responseDetails) {
          responses.add(Response.fromJson({
            'statusCode': statusCode,
            ...responseDetails as Map<String, dynamic>,
          }));
        });

        paths['$path-$method'] = Endpoint(
          path: path,
          method: method.toUpperCase(),
          description: details['description']?.toString(),
          parameters: parameters.isNotEmpty ? parameters : null,
          headers: headers.isNotEmpty ? headers : null,
          requestBody: requestBody,
          responses: responses.isNotEmpty ? responses : null,
        );
      });
    });

    return OpenApiSpec(
      title: specJson['info']?['title']?.toString(),
      description: specJson['info']?['description']?.toString(),
      paths: paths,
    );
  }
}