import 'package:json_annotation/json_annotation.dart';
import 'models.dart';

part 'openapi_spec.g.dart';

@JsonSerializable()
class OpenApiSpec {
  final String? title;
  final String? description;
  final Map<String, Endpoint>? paths;

  OpenApiSpec({this.title, this.description, this.paths});

  factory OpenApiSpec.fromJson(Map<String, dynamic> json) =>
      _$OpenApiSpecFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiSpecToJson(this);
}