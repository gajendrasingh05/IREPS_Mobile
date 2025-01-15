import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/mmis/utils/custom_color.dart';


class CustomLoading extends StatelessWidget {
  const CustomLoading({
    Key? key,
    this.color = CustomColor.primaryColor,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20
        ),
        child: SpinKitThreeBounce(
          color: CustomColor.primaryColor.withOpacity(0.5),
          size: 30.0,
        ),
      ),
    );
  }
}
