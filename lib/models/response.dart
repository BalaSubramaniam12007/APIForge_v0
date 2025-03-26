import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class Response {
  final String statusCode; // e.g., "200", "404"
  final String? description;

  @JsonKey(fromJson: _contentFromJson, toJson: _contentToJson)
  final Map<String, dynamic>? content; // e.g., {"application/json": {"schema": {...}}}

  Response({required this.statusCode, this.description, this.content});

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseToJson(this);

  static Map<String, dynamic>? _contentFromJson(Map<String, dynamic>? json) => json;
  static Map<String, dynamic>? _contentToJson(Map<String, dynamic>? content) => content;
}