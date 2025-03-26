import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'endpoint_card.dart';

class SpecEndpointList extends StatelessWidget {
  final OpenApiSpec spec;
  final List<dynamic> filteredEndpoints;

  const SpecEndpointList({
    Key? key,
    required this.spec,
    required this.filteredEndpoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          if (spec.description != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                spec.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          if (filteredEndpoints.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No endpoints match your search.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ...filteredEndpoints.map((endpoint) => EndpointCard(endpoint: endpoint)).toList(),
        ],
      ),
    );
  }
}