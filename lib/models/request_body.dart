import 'package:json_annotation/json_annotation.dart';

part 'request_body.g.dart';

@JsonSerializable()
class RequestBody {
  final String? description;
  final bool required;

  @JsonKey(fromJson: _contentFromJson, toJson: _contentToJson)
  final Map<String, dynamic>? content; // e.g., {"application/json": {"schema": {...}}}

  RequestBody({this.description, this.required = false, this.content});

  factory RequestBody.fromJson(Map<String, dynamic> json) =>
      _$RequestBodyFromJson(json);
  Map<String, dynamic> toJson() => _$RequestBodyToJson(this);

  static Map<String, dynamic>? _contentFromJson(Map<String, dynamic>? json) => json;
  static Map<String, dynamic>? _contentToJson(Map<String, dynamic>? content) => content;
}