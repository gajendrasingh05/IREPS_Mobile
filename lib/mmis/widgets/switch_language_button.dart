import 'package:flutter_app/mmis/controllers/language_controller.dart';
import 'package:flutter_app/mmis/localizations/languages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SwitchLanguageButton extends StatelessWidget{
  SwitchLanguageButton({
    Key? key,
    this.color = Colors.white,
  }) : super(key: key);
  final Color color;
  final LanguageController _languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: DropdownButton<Language>(
        isExpanded: true,
        icon: Image.asset('assets/images/translate_logo.png', height: 60, width: 60),
        underline: const SizedBox(),
        onChanged: (value) {
          if(value == null) return;
          value == Language.Hindi ? _languageController.changeLocale(Locale('hi')) :  _languageController.changeLocale(Locale('en'));
          //value == Language.Hindi ? _languageController.setSelectedLanguage(const Locale("hi", "IN")) : _languageController.setSelectedLanguage(const Locale("en", "US"));
        },
        value: null,
        items: languageTextMap.keys.map((Language value) {
          return DropdownMenuItem(
            value: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languageTextMap[value]!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                if(_languageController.selectedLanguage == languageTextMap[value]!)
                  const Icon(
                    Icons.check_box,
                    color: Colors.blue,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}