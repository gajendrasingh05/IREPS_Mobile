import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../form_row.dart';

class LabelText extends StatelessWidget {

  final String text;
  final TextAlign? textAlign;
  final bool required;

  const LabelText({
    Key? key,
    required this.text,
    this.textAlign,
    this.required = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormRow(label: text.tr, isRequired: required);
  }
}
