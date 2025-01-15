import 'package:flutter_app/mmis/view/components/text/label_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/dimensions.dart';
import '../../../utils/my_color.dart';
import '../../../utils/style.dart';


class CustomTimeTextField extends StatefulWidget {
  const CustomTimeTextField({Key? key, required this.labelText, required this.hintText, this.controller, this.chargeText = '', required this.currency, required this.onChanged, this.autoFocus = false, this.inputAction, this.readOnly = false, this.isRequired = false}) : super(key: key);

  final String chargeText;
  final String labelText;
  final String hintText;
  final String currency;
  final bool autoFocus;
  final bool readOnly;
  final bool isRequired;
  final Function(String) onChanged;
  final TextEditingController? controller;
  final TextInputAction? inputAction;

  @override
  State<CustomTimeTextField> createState() => _CustomTimeTextFieldState();
}

class _CustomTimeTextFieldState extends State<CustomTimeTextField> {
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(text: widget.labelText.tr, required: widget.isRequired),
        const SizedBox(height: 8),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: 8),
          decoration: BoxDecoration(color: MyColor.transparentColor, border: Border.all(color: isFocus ? MyColor.getFieldEnableBorderColor() : MyColor.getFieldDisableBorderColor(), width: 0.5), borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: FocusScope(
                  child: Focus(
                    onFocusChange: (focus) {
                      setState(() {
                        isFocus = focus;
                      });
                    },
                    child: TextField(
                      cursorColor: MyColor.getTextColor(),
                      readOnly: widget.readOnly,
                      controller: widget.controller,
                      autofocus: widget.autoFocus,
                      style: interRegularDefault.copyWith(color: MyColor.getTextColor()),
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.number,
                      textInputAction: widget.inputAction,
                      onChanged: widget.onChanged,
                      decoration:
                          InputDecoration(contentPadding: const EdgeInsets.only(bottom: 16), hintText: widget.hintText, hintStyle: interRegularSmall.copyWith(color: MyColor.hintTextColor, height: 1.452), border: InputBorder.none, focusedBorder: InputBorder.none, enabledBorder: InputBorder.none, disabledBorder: InputBorder.none, focusedErrorBorder: InputBorder.none, errorBorder: InputBorder.none),
                    ),
                  ),
                ),
              ),
              Container(
                width: 50,
                padding: const EdgeInsets.all(Dimensions.space5),
                decoration: BoxDecoration(color: MyColor.primaryColor.withOpacity(0.7), borderRadius: BorderRadius.circular(5)),
                alignment: Alignment.center,
                child: Text(
                  widget.currency,
                  textAlign: TextAlign.center,
                  style: interRegularDefault.copyWith(color: MyColor.getTextColor(), fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
