import 'package:flutter_app/mmis/utils/dimensions.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/utils/style.dart';
import 'package:flutter_app/mmis/view/components/text/default_text.dart';
import 'package:flutter_app/mmis/view/components/text/extra_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ClickableCard extends StatelessWidget {

  final VoidCallback onPressed;
  final String image;
  final String label;
  final double imageSize;
  final bool needHorizontal;
  final Color? backgroundColor;

  const ClickableCard({
    Key? key,
    required this.onPressed,
    required this.image,
    required this.label,
    this.imageSize = 22,
    this.needHorizontal = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: needHorizontal ? Dimensions.space15 : 0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12)
        ),
        child: needHorizontal ? Row(
          children: [
            Image.asset(image, color: MyColor.getSelectedIconColor(), height: imageSize, width: imageSize),
            const SizedBox(width: Dimensions.space10),
            DefaultText(text: label, textAlign: TextAlign.left, textColor: MyColor.getTextColor())
          ],
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image.contains("svg")? SvgPicture.asset(image, color: MyColor.getSelectedIconColor(), height: imageSize, width: imageSize) : Image.asset(image, color: MyColor.getSelectedIconColor(), height: imageSize, width: imageSize),
            const SizedBox(height: Dimensions.space10),
            ExtraSmallText(text: label, textAlign: TextAlign.center, textStyle: interRegularExtraSmall.copyWith(color: MyColor.getTextColor()))
          ],
        ),
      ),
    );
  }
}
