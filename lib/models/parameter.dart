import 'package:json_annotation/json_annotation.dart';

part 'parameter.g.dart';

@JsonSerializable()
class Parameter {
  final String? name; // Changed to nullable
  final String? inType; // Changed to nullable
  final String? description;
  final bool required;
  final String? type;

  Parameter({
    required this.name,
    required this.inType,
    this.description,
    this.required = false,
    this.type,
  });

  factory Parameter.fromJson(Map<String, dynamic> json) =>
      _$ParameterFromJson(json);
  Map<String, dynamic> toJson() => _$ParameterToJson(this);
}