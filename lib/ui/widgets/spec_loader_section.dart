import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/core.dart';
import '../../providers/providers.dart';
import 'widgets.dart';

class SpecLoaderSection extends StatefulWidget {
  const SpecLoaderSection({Key? key}) : super(key: key);

  @override
  _SpecLoaderSectionState createState() => _SpecLoaderSectionState();
}

class _SpecLoaderSectionState extends State<SpecLoaderSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpecInput(
          controller: _controller,
          onSubmit: () async {
            NavigationUtils.navigateToSpecScreen(context, () async {
              final provider = Provider.of<SpecProvider>(context, listen: false);
              await provider.loadSpec(_controller.text);
              _controller.clear();
            });
          },
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, thickness: 1, color: Colors.grey),
        const SizedBox(height: 16),
        FileUploadButton(
          onFileSelected: (content, fileName) async {
            NavigationUtils.navigateToSpecScreen(context, () async {
              final provider = Provider.of<SpecProvider>(context, listen: false);
              await provider.loadSpecFromFile(content, fileName);
            });
          },
        ),
        const SizedBox(height: 8),
        const SwaggerLink(),
      ],
    );
  }
}