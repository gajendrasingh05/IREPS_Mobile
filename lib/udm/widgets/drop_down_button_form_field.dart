import 'package:flutter/material.dart';


class CustomDropDownButtonFormField extends StatefulWidget {
  String? dropDownValue;
  final String? labeltext;
  final String? hinttext;
  final List<dynamic>? itemList;
  final Function(String? val)? setValue;
  CustomDropDownButtonFormField({this.dropDownValue,this.labeltext, this.hinttext, this.itemList, this.setValue});
  @override
  _CustomDropDownButtonFormFieldState createState() => _CustomDropDownButtonFormFieldState();
}

class _CustomDropDownButtonFormFieldState extends State<CustomDropDownButtonFormField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      value: widget.dropDownValue,
      icon: Icon(Icons.keyboard_arrow_down),
      //  decoration: InputDecoration.collapsed(hintText: 'Select Railway',
      //  ),
      decoration: InputDecoration(
        labelText: widget.labeltext,
        hintText: widget.hinttext,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        labelStyle: Theme.of(context)
            .primaryTextTheme
            .bodySmall!
            .copyWith(color: Colors.black),
        border: const OutlineInputBorder(),
        contentPadding: EdgeInsetsDirectional.all(10),
      ),
      isDense: true,
      onChanged: (String? value) {
        widget.setValue!(value);
        setState(() {
          widget.dropDownValue = value;
        });
      },
      validator: (dynamic value) =>
      value == null ? widget.hinttext : null,
      // item height should not be less than 48
      items: widget.itemList!.map((e) =>DropdownMenuItem<String>(
        value: e,
        child:Text(e, style: TextStyle(
          fontSize: 15.0,
        ),
        ),
      ), ).toList(),
    );
  }
}