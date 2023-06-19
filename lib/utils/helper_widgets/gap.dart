import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap(this.value, {super.key});
  final double value;

  SizedBox get row => SizedBox(width: value);
  SizedBox get column => SizedBox(height: value);

  @override
  Widget build(BuildContext context) => SizedBox(width: value, height: value);
}
