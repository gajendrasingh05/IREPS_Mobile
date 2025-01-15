import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';

class ItemReceiptTextWidget extends StatelessWidget {
  ItemReceiptTextWidget(this.heading, this.value,
      {bool blueColor = false, bool orangeColor = false, Key? key})
      : super(key: key) {
    this.blueColor = blueColor;
    this.orangeColor = orangeColor;
  }
  final String? heading;
  final String? value;
  late bool blueColor;
  late bool orangeColor;
  @override
  Widget build(BuildContext context) {
    LanguageProvider language =
        Provider.of<LanguageProvider>(context, listen: false);
    if (heading == language.text('date') ||
        heading == language.text('rateRs') ||
        heading == language.text('rate') ||
        heading == language.text('valueRs') ||
        heading == language.text('warrantyClaimNo') ||
        heading == language.text('warrantyClaimDate')) {
      blueColor = false;
      orangeColor = true;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14.0,
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              heading ?? '_',
              style: TextStyle(
                color: blueColor
                    ? Color(0XFF0073ff)
                    : orangeColor
                        ? Colors.deepOrangeAccent
                        : Colors.indigo[800],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value ?? '_',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
