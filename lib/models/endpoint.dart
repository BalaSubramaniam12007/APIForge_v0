import 'package:json_annotation/json_annotation.dart';
import 'models.dart';

part 'endpoint.g.dart';

@JsonSerializable()
class Endpoint {
  final String path;
  final String method; // e.g., GET, POST, DELETE
  final String? description;
  final List<Parameter>? parameters;
  final List<Parameter>? headers; // Headers are often specified as parameters with inType="header"
  final RequestBody? requestBody;
  final List<Response>? responses;

  Endpoint({
    required this.path,
    required this.method,
    this.description,
    this.parameters,
    this.headers,
    this.requestBody,
    this.responses,
  });

  factory Endpoint.fromJson(Map<String, dynamic> json) =>
      _$EndpointFromJson(json);
  Map<String, dynamic> toJson() => _$EndpointToJson(this);
}