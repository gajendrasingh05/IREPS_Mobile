import 'package:flutter/material.dart';

import 'CustomRadioController.dart';

class CustomRadioButton extends StatefulWidget {
  CustomRadioButton(
      {this.customRadioController,
      this.label,
      this.values,
      this.onSaved,
      this.onChanged,
      List<String>? value});
  CustomRadioController? customRadioController;
  final String? label;
  final List<String>? values;
  final Function(int)? onSaved;
  final Function(int)? onChanged;

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  int? selectedIndex;
  bool? isFocus;

  @override
  void initState() {
    widget.customRadioController!.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.customRadioController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedIndex = widget.customRadioController!.index;
    isFocus = widget.customRadioController!.isFocus;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.label == null
            ? Icon(Icons.category_sharp)
            : Text(
                widget.label!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: !isFocus! ? Colors.black : Colors.cyanAccent[400],
                ),
              ),
        SizedBox(width: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(
              widget.values!.length,
              (index) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: InkWell(
                    splashColor: Colors.cyan[700],
                    focusColor: Colors.cyan[50],
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      widget.customRadioController!.setValue(index);
                      widget.customRadioController!.setFocus();
                      widget.onChanged!(widget.customRadioController!.index);
                    },
                    child: Container(
                      //height: 40,
                      width: 70,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.cyan[900]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: index == selectedIndex
                            ? Colors.cyanAccent[700]
                            : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          widget.values![index],
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: index == selectedIndex
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: index == selectedIndex
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
