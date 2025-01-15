import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/mmis/controllers/home_controller.dart';
import 'package:flutter_app/mmis/controllers/language_controller.dart';

class LanguageDialog extends StatelessWidget {
  final LanguageController _controller = Get.find<LanguageController>();
  final HomeController _homecontroller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Text('chooselanguage'.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ListTile(
          //   title: const Text("English"),
          //   leading: Obx(() => Radio(
          //     value: "English",
          //     groupValue: _controller.selectedLanguage.value,
          //     onChanged: (value) => _controller.setSelectedLanguage(const Locale("en", "US")),
          //   )),
          // ),
          // ListTile(
          //   title: const Text("हिन्दी"),
          //   leading: Obx(() => Radio(
          //     value: "Hindi",
          //     groupValue: _controller.selectedLanguage.value,
          //     onChanged: (value) => _controller.setSelectedLanguage(const Locale("hi", "IN")),
          //   )),
          // ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('cancelbtn'.tr),
        ),
        TextButton(
          onPressed: () {
            // if(_controller.selectedLanguage.value == 'hindi') {
            //   Get.updateLocale(const Locale('hi', 'IN'));
            //   if(_homecontroller.selectedIndex == 0) {
            //     _homecontroller.updatelist(RxInt(0));
            //     _homecontroller.updateSideValue = [Strings.crismmis.tr, Strings.deptmapping.tr];
            //   }
            //   else{
            //     _homecontroller.updatelist(RxInt(1));
            //     _homecontroller.updateSideValue = [Strings.crismmis.tr, Strings.deptmapping.tr];
            //   }
            //   Get.back();
            // }
            // else{
            //   Get.updateLocale(const Locale('en', 'US'));
            //   if(_homecontroller.selectedIndex == 0) {
            //     _homecontroller.updatelist(RxInt(0));
            //     _homecontroller.updateSideValue = [Strings.crismmis.tr, Strings.deptmapping.tr];
            //   }
            //   else{
            //     _homecontroller.updatelist(RxInt(1));
            //     _homecontroller.updateSideValue = [Strings.crismmis.tr, Strings.deptmapping.tr];
            //   }
            //   Get.back();
            // }
          },
          child: Text("${'confirmbtn'.tr}"),
        ),
      ],
    );
  }
}
