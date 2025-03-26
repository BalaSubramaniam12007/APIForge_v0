import 'package:flutter/material.dart';
import 'widgets.dart';

class SpecSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;

  const SpecSearchBar({Key? key, required this.onSearchChanged}) : super(key: key);

  @override
  _SpecSearchBarState createState() => _SpecSearchBarState();
}

class _SpecSearchBarState extends State<SpecSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ApiForgeSearchBar(
    controller: _searchController,
    onChanged: (value) {
      widget.onSearchChanged(value);
    },
    suffixIcon: _searchController.text.isNotEmpty
        ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              widget.onSearchChanged('');
            },
          )
        : null,
  );
}
}