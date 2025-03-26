import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../widgets/widgets.dart';
import '../../models/models.dart';

class SpecScreen extends StatefulWidget {
  const SpecScreen({super.key});

  @override
  State<SpecScreen> createState() => _SpecScreenState();
}

class _SpecScreenState extends State<SpecScreen> {
  String _searchQuery = '';

  @override
Widget build(BuildContext context) {
  return Consumer<SpecProvider>(
    builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final spec = provider.spec;

      if (spec == null) {
        return const NoSpecLoadedScreen();
      }

      final filteredEndpoints = _filterEndpoints(spec);

      return PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            provider.clearSpec();
          }
        },
        child: Scaffold(
          body: Row(
            children: [
              const Sidebar(currentRoute: '/spec'),
              Expanded(
                child: SpecContent(
                  spec: spec,
                  filteredEndpoints: filteredEndpoints,
                  onSearchChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  List<dynamic> _filterEndpoints(OpenApiSpec spec) {
    return spec.paths!.values.where((endpoint) {
      final query = _searchQuery.toLowerCase();
      final pathMatch = endpoint.path.toLowerCase().contains(query);
      final methodMatch = endpoint.method.toLowerCase().contains(query);
      return pathMatch || methodMatch;
    }).toList();
  }
}