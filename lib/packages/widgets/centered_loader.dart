import 'package:flutter/material.dart';

class CenteredLoader extends StatelessWidget {
  const CenteredLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [CircularProgressIndicator()],
    );
  }
}
