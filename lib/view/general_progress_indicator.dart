import 'package:flutter/material.dart';

class GeneralProgressIndicator extends StatelessWidget {
  const GeneralProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
