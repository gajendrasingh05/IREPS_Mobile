import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/dimensions.dart';
import '../../utils/my_color.dart';
import '../../utils/my_images.dart';
import '../../utils/style.dart';


class CustomSnackBar {
  static showCustomSnackBar({required List<String> errorList, required List<String> msg, required bool isError, int duration = 3}) {
    String message = '';
    if(isError) {
      if(errorList.isEmpty) {
        message = 'somethingWentWrong'.tr;
      }
      else {
        for(var element in errorList) {
          String tempMessage = element.tr;
          message = message.isEmpty ? tempMessage : "$message\n$tempMessage";
        }
      }
     // message = Converter.removeQuotationAndSpecialCharacterFromString(message);
    } else
    {
      if(msg.isEmpty) {
        message = 'requestSuccess'.tr;
      }
      else {
        for(var element in msg) {
          String tempMessage = element.tr;
          message = message.isEmpty ? tempMessage : "$message\n$tempMessage";
        }
      }
      //message = Converter.removeQuotationAndSpecialCharacterFromString(message);
    }
    Get.rawSnackbar(
      progressIndicatorBackgroundColor: isError ? MyColor.red : MyColor.green,
      progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(isError ? MyColor.red : MyColor.green),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 2,
          ),
          Text(message, style: interRegularDefault.copyWith(color: MyColor.getTextColor())),
        ],
      ),
      dismissDirection: DismissDirection.horizontal,
      snackPosition: SnackPosition.TOP,
      titleText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Text((!isError ? Strings.success.tr : Strings.error.tr).toLowerCase().capitalizeFirst ?? '', style: interSemiBoldSmall.copyWith(fontSize: Dimensions.fontLarge, color: MyColor.getTextColor())),
          SizedBox(
            height: 25,
            width: 25,
            child: SvgPicture.asset(
              isError ? MyImages.errorImage : MyImages.successImage,
              color: isError ? MyColor.red : MyColor.green,
            ),
          )
        ],
      ),
      backgroundColor: MyColor.getScreenBgColor(),
      borderRadius: 4,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      duration: Duration(seconds: duration),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeIn,
      showProgressIndicator: true,
      leftBarIndicatorColor: MyColor.getScreenBgColor(),
      animationDuration: const Duration(seconds: 1),
      borderColor: MyColor.borderColor,
      reverseAnimationCurve: Curves.easeOut,
      borderWidth: 1,
    );
  }

  static error({required List<String> errorList, int duration = 3}) {
    String message = '';
    if (errorList.isEmpty) {
      message = 'somethingWentWrong'.tr;
    } else {
      for (var element in errorList) {
        String tempMessage = element.tr;
        message = message.isEmpty ? tempMessage : "$message\n$tempMessage";
      }
    }
    //message = Converter.removeQuotationAndSpecialCharacterFromString(message);
    Get.rawSnackbar(
      progressIndicatorBackgroundColor: MyColor.red,
      progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(MyColor.red),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 2,
          ),
          Text(
            message,
            style: interRegularDefault.copyWith(color: MyColor.getTextColor()),
          ),
        ],
      ),
      dismissDirection: DismissDirection.horizontal,
      snackPosition: SnackPosition.TOP,
      titleText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('error'.tr.toLowerCase().capitalizeFirst ?? 'error'.tr, style: interSemiBoldSmall.copyWith(fontSize: Dimensions.fontLarge, color: MyColor.getTextColor())),
          SizedBox(
            height: 25,
            width: 25,
            child: SvgPicture.asset(
              MyImages.errorImage,

              // color: MyColor.red,
            ),
          )
        ],
      ),
      backgroundColor: MyColor.getCardBg(),
      borderRadius: 4,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      duration: Duration(seconds: duration),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeIn,
      showProgressIndicator: true,
      leftBarIndicatorColor: MyColor.getScreenBgColor(),
      animationDuration: const Duration(seconds: 1),
      borderColor: MyColor.transparentColor,
      reverseAnimationCurve: Curves.easeOut,
      borderWidth: 1,
    );
  }

  static success({required List<String> successList, int duration = 3}) {
    String message = '';
    if (successList.isEmpty) {
      message = 'somethingWentWrong'.tr;
    } else {
      for (var element in successList) {
        String tempMessage = element.tr;
        message = message.isEmpty ? tempMessage : "$message\n$tempMessage";
      }
    }
   //message = Converter.removeQuotationAndSpecialCharacterFromString(message);
    Get.rawSnackbar(
      progressIndicatorBackgroundColor: MyColor.green,
      progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(MyColor.green),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 2,
          ),
          Text(message, style: interRegularDefault.copyWith(color: MyColor.getTextColor())),
        ],
      ),
      dismissDirection: DismissDirection.horizontal,
      snackPosition: SnackPosition.TOP,
      titleText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Text(Strings.success.tr.toLowerCase().capitalizeFirst ?? Strings.success.tr, style: interSemiBoldSmall.copyWith(fontSize: Dimensions.fontLarge, color: MyColor.getTextColor())),
        ],
      ),
      backgroundColor: MyColor.getCardBg(),
      borderRadius: 4,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      duration: Duration(seconds: duration),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeIn,
      showProgressIndicator: true,
      leftBarIndicatorColor: MyColor.getScreenBgColor(),
      animationDuration: const Duration(seconds: 1),
      borderColor: MyColor.getBorderColor(),
      reverseAnimationCurve: Curves.easeOut,
      borderWidth: 1,
    );
  }

  static showSnackBarWithoutTitle(BuildContext context, String message, {Color bg = MyColor.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bg,
        content: Text(message),
      ),
    );
  }
}
