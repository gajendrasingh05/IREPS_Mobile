import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class ShowMoreText extends StatelessWidget {
  //final String text;
  final Callback onTap;
  const ShowMoreText({Key? key,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        "text",
        style: interSemiBoldDefault.copyWith(color:MyColor.getPrimaryColor(),decoration:TextDecoration.underline),
      ),
    );
  }
}
