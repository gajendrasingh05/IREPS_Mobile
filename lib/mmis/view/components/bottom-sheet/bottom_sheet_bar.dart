import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter/material.dart';

class BottomSheetBar extends StatelessWidget {
  const BottomSheetBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 250, width: double.infinity,
        decoration: BoxDecoration(
          color: MyColor.primaryTextColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(3)
        ),
      ),
    );
  }
}
