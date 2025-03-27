import 'package:flutter/material.dart';
import '../../core/core.dart';

// AppTitle Widget
class AppTitle extends StatelessWidget {
  const AppTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ApiForge',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Load, Parse, and Explore OpenAPI Specifications',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryTextColor,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}