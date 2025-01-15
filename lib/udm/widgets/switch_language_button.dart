import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/languageHelper.dart';
import '../providers/languageProvider.dart';
class SwitchLanguageButton extends StatelessWidget {
  const SwitchLanguageButton({
    Key? key,
    this.color = Colors.white,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    Language currLang = Provider.of<LanguageProvider>(context).language;
    return Container(
      width: 100,
      child: DropdownButton<Language>(
        isExpanded: true,
        icon: Image.asset(
          'assets/images/translate_logo.png',
          height: 60,
          width: 60,
        ),
        underline: const SizedBox(),
        onChanged: (value) {
          print("value $value");
          if(value == null) return;
          Provider.of<LanguageProvider>(context, listen: false).updateLanguage(value);
        },
        value: null,
        items: languageTextMap.keys.map((Language value) {
          return DropdownMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languageTextMap[value]!,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                if(currLang == value)
                  Icon(
                    Icons.check_box,
                    color: Colors.blue,
                  ),
              ],
            ),
            value: value,
          );
        }).toList(),
      ),
    );
  }
}