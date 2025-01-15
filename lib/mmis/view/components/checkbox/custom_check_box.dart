import 'package:flutter_app/mmis/utils/dimensions.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class CustomCheckBox extends StatefulWidget {

  final List<String>?  selectedValue;
  final List<String> list;
  final ValueChanged? onChanged;

  const CustomCheckBox({Key? key,
    this.selectedValue,
    required this.list,
    this.onChanged, }) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {


  @override
  Widget build(BuildContext context) {

    if(widget.list.isEmpty){
      return Container();
    }
    return Column(
      children: [
        Column(
            children: List<CheckboxListTile>.generate(
                widget.list.length,
                    (int index){
                  List<String>?s=widget.selectedValue;
                  bool selected_=s!=null?s.contains(widget.list[index]):false;
                  return CheckboxListTile(
                    fillColor: const MaterialStatePropertyAll<Color>(MyColor.transparentColor),
                    checkColor: MyColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.defaultRadius+2),
                    ),
                    side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(width: 1.0, color: MyColor.getPrimaryColor()),
                    ),
                    value: selected_,
                    activeColor: MyColor.primaryColor,
                    title: Text(widget.list[index].tr,style: interRegularDefault.copyWith(color: MyColor.getTextColor()),),
                    onChanged: (bool? value) {
                      setState((){
                        if(value!=null){
                          widget.onChanged!('${index}_$value');
                        }
                      });
                    },
                  );
                }
            )
        ),
      ],
    );
  }
}
