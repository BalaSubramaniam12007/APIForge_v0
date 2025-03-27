import 'package:flutter/material.dart';
import 'widgets.dart';

class SwaggerLink extends StatelessWidget {
  const SwaggerLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        LinkCard(
          title: 'OpenAPI Link',
          url: 'https://raw.githubusercontent.com/openai/openai-openapi/refs/heads/master/openapi.yaml',
        ),
        LinkCard(
          title: 'Petstore Swagger Link',
          url: 'https://petstore.swagger.io/v2/swagger.json',
        ),
        LinkCard(
          title: 'Huggingface -textgenrationInterface',
          url: 'https://raw.githubusercontent.com/huggingface/text-generation-inference/refs/heads/main/docs/openapi.json',
        ),
      ],
    );
  }
}