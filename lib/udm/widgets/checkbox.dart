import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';

class LoginSavedCheckBox extends StatefulWidget {
  final Function(bool val)? setValue;
  bool? value;
  LoginSavedCheckBox({this.value, this.setValue});

  @override
  _LoginSavedCheckBoxState createState() => _LoginSavedCheckBoxState();
}

class _LoginSavedCheckBoxState extends State<LoginSavedCheckBox> {
  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Row(
      children: [
        Checkbox(
          value: widget.value,
          onChanged: (bool? val) {
            widget.setValue!(!widget.value!);
            setState(() {
              widget.value = !widget.value!;
            });
          },
        ),
        Expanded(
          child: Text(
            language.text('saveCred'),
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
