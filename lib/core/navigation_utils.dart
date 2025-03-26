import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../ui/ui.dart';

class NavigationUtils {
  static Future<void> navigateToSpecScreen(
    BuildContext context,
    Future<void> Function() loadSpecAction,
  ) async {
    final provider = Provider.of<SpecProvider>(context, listen: false);
    await loadSpecAction();
    if (provider.spec != null) {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute == '/spec') {
        Navigator.pop(context);
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SpecScreen(),
          settings: const RouteSettings(name: '/spec'),
        ),
      );
      provider.clearSpec();
    } else if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error!),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () {
              loadSpecAction();
            },
          ),
        ),
      );
    }
  }
}