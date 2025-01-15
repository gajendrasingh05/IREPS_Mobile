import 'package:flutter/material.dart';

import '../../utils/my_color.dart';

class CustomDivider extends StatelessWidget {
  final double space;
  const CustomDivider({Key? key, this.space = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: space),
        Divider(height: 2, color: MyColor.colorWhite.withOpacity(0.04), thickness: 1),
        SizedBox(height: space),
      ],
    );
  }
}
