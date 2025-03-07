import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double space;
  const CustomDivider({Key? key, this.space = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: space),
        Divider(color: MyColor.getBorderColor(), height: 0.5, thickness: .5),
        SizedBox(height: space),
      ],
    );
  }
}
