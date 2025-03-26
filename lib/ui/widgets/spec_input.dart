import 'package:flutter/material.dart';

class SpecInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const SpecInput({
    Key? key,
    required this.controller,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Paste the URL',
              ),
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Load'),
          ),
        ],
      ),
    );
  }
}