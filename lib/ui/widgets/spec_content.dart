import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'widgets.dart';

class SpecContent extends StatelessWidget {
  final OpenApiSpec spec;
  final List<dynamic> filteredEndpoints;
  final ValueChanged<String> onSearchChanged;

  const SpecContent({
    Key? key,
    required this.spec,
    required this.filteredEndpoints,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpecHeader(title: spec.title ?? 'API Specification'),
        SpecSearchBar(onSearchChanged: onSearchChanged),
        SpecEndpointList(spec: spec, filteredEndpoints: filteredEndpoints),
      ],
    );
  }
}