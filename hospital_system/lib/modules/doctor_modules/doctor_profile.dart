import 'package:flutter/material.dart';

import '../../shared/components/constants.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    internetConection('doctor', context);
    return const Placeholder();
  }
}
