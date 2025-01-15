import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/mmis/controllers/home_controller.dart';
import 'package:flutter_app/mmis/controllers/language_controller.dart';

class LanguageBottomSheet extends StatelessWidget {
  final HomeController _homeController = Get.find<HomeController>();
  final LanguageController _languageController = Get.find<LanguageController>();


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [
                0.5,
                1.0
              ],
              colors: [
                Colors.red[300]!,
                Colors.orange[400]!,
              ]),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0, top: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('chooselanguage'.tr, style: const TextStyle(color: Colors.white, fontSize: 16.0)),
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Container(
                    height: 28.0,
                    width: 28.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.0), color: Colors.indigo),
                    child: const Icon(Icons.clear, color: Colors.white, size: 16.0),
                  ),
                )
              ],
            ),
            // ListTile(
            //   contentPadding: EdgeInsets.zero,
            //   title: const Text("English", style: TextStyle(color: Colors.white)),
            //   leading: Obx(() => Radio(
            //     activeColor: Colors.indigo,
            //     focusColor: Colors.white,
            //     value: "English",
            //     groupValue: _languageController.selectedLanguage,
            //     //groupValue: _languageController.selectedLanguage.value,
            //     onChanged: (value) => _languageController.setSelectedLanguage(const Locale("en", "US")),
            //   )),
            // ),
            // ListTile(
            //   contentPadding: EdgeInsets.zero,
            //   title: const Text("हिन्दी", style: TextStyle(color: Colors.white)),
            //   leading: Obx(() => Radio(
            //     value: "Hindi",
            //     activeColor: Colors.indigo,
            //     focusColor: Colors.white,
            //     groupValue: _languageController.selectedLanguage,
            //     onChanged: (value) => _languageController.setSelectedLanguage(const Locale("hi", "IN")),
            //   )),
            // ),
            const SizedBox(height: 16),
            SizedBox(
              width: Get.width,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo), // Background color
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(12)), // Padding
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Border radius
                      side: const BorderSide(color: Colors.white), // Border color
                    ),
                  ),
                ),
                onPressed: () => _updateLanguage(),
                child: Text('confirmbtn'.tr, style: const TextStyle(color: Colors.white)),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     TextButton(
            //       onPressed: () => Get.back(),
            //       child: Text(Strings.cancelbtn.tr),
            //     ),
            //
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  void _updateLanguage() {
    // if (_languageController.selectedLanguage == 'hindi') {
    //   Get.updateLocale(const Locale('hi', 'IN'));
    // } else {
    //   Get.updateLocale(const Locale('en', 'US'));
    // }
    //
    // if (_homeController.selectedIndex == 0) {
    //   _homeController.updatelist(RxInt(0));
    //   _homeController.updateSideValue = [Strings.crismmis.tr, Strings.deptmapping.tr];
    // } else {
    //   _homeController.updatelist(RxInt(1));
    //   _homeController.updateSideValue = [Strings.crismmis.tr, Strings.deptmapping.tr];
    // }
    //
    // Get.back();
  }
}
