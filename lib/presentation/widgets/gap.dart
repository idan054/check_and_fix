

import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  final double height;
  final double width;
  const Gap({Key? key, this.height = 0, this.width = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}