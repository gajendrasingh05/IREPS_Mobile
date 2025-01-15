import 'package:flutter_app/mmis/utils/dimensions.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/view/components/text/read_more_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/style.dart';

class ShowMore extends StatelessWidget {
  final String showMoreText;
  final int trimLines;
  final String trimCollapsedText;
  final String trimExpandedText;
  final TextStyle textStyle;
  const ShowMore(this.showMoreText,{
    Key? key,
    this.trimLines = 1,
    this.trimCollapsedText = 'Show more',
    this.trimExpandedText = 'Show less',
    this.textStyle = interRegularDefault,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      showMoreText.tr,
      trimLines: trimLines,
      colorClickableText: MyColor.primaryColor,
      trimMode: TrimMode.Line,
      trimCollapsedText: trimCollapsedText,
      trimExpandedText: trimExpandedText,
      style: textStyle,
      moreStyle: const TextStyle(fontSize: Dimensions.fontDefault, fontWeight: FontWeight.bold,color: MyColor.primaryColor),
    );
  }
}
