import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../providers/providers.dart';
import '../widgets/widgets.dart';
import '../../models/models.dart';
import 'screens.dart';

class SpecScreen extends StatefulWidget {
  const SpecScreen({super.key});

  @override
  State<SpecScreen> createState() => _SpecScreenState();
}

class _SpecScreenState extends State<SpecScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with back button, title, and export button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black54),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                                );
                              },
                            ),
                            Expanded(
                              child: Text(
                                spec.title ?? 'API Specification',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            FileDownloader(
                              data: utf8.encode(jsonEncode(provider.exportToPostmanCollection())),
                              fileName: spec.title ?? "api-forge-collection",
                              fileExtension: 'json',
                              onSuccess: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Postman collection exported successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              onError: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to export Postman collection: $error'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Search bar
                      ApiForgeSearchBar(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                      // Endpoint list
                      Expanded(
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
                      ),
                    ],
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