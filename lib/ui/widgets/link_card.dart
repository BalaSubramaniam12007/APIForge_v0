import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/core.dart';

// LinkCard Widget (Reusable Template for Links)
class LinkCard extends StatefulWidget {
  final String title;
  final String url;

  const LinkCard({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  _LinkCardState createState() => _LinkCardState();
}

class _LinkCardState extends State<LinkCard> {
  bool _isExpanded = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTapDown: (_) {
          setState(() {
            _scale = 0.9;
          });
        },
        onTapUp: (_) {
          setState(() {
            _scale = 1.0;
          });
          Clipboard.setData(ClipboardData(text: widget.url));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.title} copied to clipboard!'),
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          );
        },
        onTapCancel: () {
          setState(() {
            _scale = 1.0;
          });
        },
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.link,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                  ],
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.url,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}