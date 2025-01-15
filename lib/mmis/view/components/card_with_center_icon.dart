import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/dimensions.dart';
import '../../utils/my_color.dart';
import '../../utils/style.dart';
import 'custom_sized_box.dart';

class CardWithCenterIconShape extends StatelessWidget {
  final double padding;
  final double margin;
  final double cardRadius;
  final Color cardBgColor;
  final VoidCallback press;
  final String icon;
  final String text;

  const CardWithCenterIconShape({Key? key, required this.text, required this.icon, required this.press, this.padding = 10.0, this.margin = 5.0, this.cardRadius = 8, this.cardBgColor = MyColor.colorWhite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        constraints: const BoxConstraints(minHeight: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10),
              margin: EdgeInsets.all(margin),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cardRadius),
                color: cardBgColor,
              ),
              child: SizedBox(
                height: 35,
                width: 35,
                child: SvgPicture.asset(
                  icon,
                ),
              ),
            ),
            const CustomSizedBox(
              height: 5,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: interBoldDefault.copyWith(fontSize: Dimensions.fontSmall),
            )
          ],
        ),
      ),
    );
  }
}
