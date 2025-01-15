import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/utils/style.dart';
import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle textStyle;
  const HeaderText({
    Key? key,
    required this.text,
    this.textAlign,
    this.textStyle = interSemiBoldHeader1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: textStyle.copyWith(color: MyColor.getTextColor()),
    );
  }
}
