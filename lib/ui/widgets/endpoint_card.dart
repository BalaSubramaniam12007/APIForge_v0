import 'package:flutter/material.dart';
import '../../models/models.dart';

class EndpointCard extends StatefulWidget {
  final Endpoint endpoint;

  const EndpointCard({required this.endpoint, Key? key}) : super(key: key);

  @override
  _EndpointCardState createState() => _EndpointCardState();
}

class _EndpointCardState extends State<EndpointCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                children: [
                  Icon(
                    _getMethodIcon(widget.endpoint.method),
                    color: _getMethodColor(widget.endpoint.method),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getMethodColor(widget.endpoint.method),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      widget.endpoint.method,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.endpoint.path,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            if (widget.endpoint.description != null) ...[
              const SizedBox(height: 12),
              Text(
                widget.endpoint.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              if (widget.endpoint.parameters != null &&
                  widget.endpoint.parameters!.isNotEmpty) ...[
                _buildSectionTitle('Parameters'),
                _buildParameterList(widget.endpoint.parameters!),
              ],
              if (widget.endpoint.headers != null &&
                  widget.endpoint.headers!.isNotEmpty) ...[
                _buildSectionTitle('Headers'),
                _buildParameterList(widget.endpoint.headers!),
              ],
              if (widget.endpoint.requestBody != null) ...[
                _buildSectionTitle('Request Body'),
                _buildRequestBody(widget.endpoint.requestBody!),
              ],
              if (widget.endpoint.responses != null &&
                  widget.endpoint.responses!.isNotEmpty) ...[
                _buildSectionTitle('Responses'),
                _buildResponseList(widget.endpoint.responses!),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: Colors.blueGrey,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterList(List<Parameter> parameters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: parameters.map((param) {
        if (param.name == null || param.inType == null) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${param.name} (${param.inType})',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (param.description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          param.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Type: ${param.type ?? "unknown"} | Required: ${param.required}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRequestBody(RequestBody requestBody) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (requestBody.description != null)
          Text(
            requestBody.description!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        const SizedBox(height: 4),
        Text(
          'Required: ${requestBody.required}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
        ),
        if (requestBody.content != null) ...[
          const SizedBox(height: 4),
          Text(
            'Content: ${requestBody.content!.keys.join(", ")}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }

  Widget _buildResponseList(List<Response> responses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: responses.map((response) {
        if (response.statusCode == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status ${response.statusCode}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (response.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    response.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              if (response.content != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Content: ${response.content!.keys.join(", ")}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getMethodIcon(String method) {
    switch (method) {
      case 'GET':
        return Icons.download;
      case 'POST':
        return Icons.upload;
      case 'DELETE':
        return Icons.delete;
      case 'PUT':
        return Icons.update;
      default:
        return Icons.info;
    }
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'DELETE':
        return Colors.red;
      case 'PUT':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}