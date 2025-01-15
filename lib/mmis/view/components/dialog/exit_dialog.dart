import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_app/mmis/utils/dimensions.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/utils/style.dart';
import 'package:flutter_app/mmis/view/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';



  showExitDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      dialogBackgroundColor: MyColor.getCardBg(),
      width: 300,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
      onDismissCallback: (type) {},
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'exitTitle'.tr,
      titleTextStyle:interRegularDefault.copyWith(color: MyColor.getTextColor(),fontSize: Dimensions.fontLarge),
      showCloseIcon: false,
      btnCancel: RoundedButton(text: 'no'.tr, press: (){
        Navigator.pop(context);
      },horizontalPadding: 3,verticalPadding: 3,textColor:MyColor.getTextColor(),color: MyColor.getScreenBgColor(),),
      btnOk: RoundedButton(text: 'yes'.tr, press: (){
        SystemNavigator.pop();
      },horizontalPadding: 3,verticalPadding: 3,color: MyColor.red,textColor: MyColor.colorWhite,),
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        SystemNavigator.pop();
      },
    ).show();
  }
