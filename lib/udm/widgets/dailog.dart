import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}

class CommonDailog extends StatelessWidget {
  final String? title;
  final String? contentText;
  final String? type;
  final Function? action;

  const CommonDailog({this.title,this.contentText, this.type,this.action}) ;


  @override
  Widget build(BuildContext context) {
    return Dialog(
      //Set to remove dailog from icon
      insetPadding: EdgeInsets.only(top:100,left:40,right:40) ,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Constants.padding),
  ),
  elevation: 0,
  backgroundColor: Colors.transparent,
  child: contentBox(context),
);
  }
  contentBox(context){
  return Stack(
    children: <Widget>[
      Container(
  padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
      + Constants.padding, right: Constants.padding,bottom: Constants.padding
  ),
  margin: EdgeInsets.only(top: Constants.avatarRadius),
  decoration: BoxDecoration(
    shape: BoxShape.rectangle,
    color: Colors.white,
    borderRadius: BorderRadius.circular(Constants.padding),
    boxShadow: [
      BoxShadow(color: Colors.black,offset: Offset(0,10),
      blurRadius: 10
      ),
    ]
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Text(title!,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
      SizedBox(height: 15,),
      Text(contentText!,style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
      SizedBox(height: 22,),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
           Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: (){
               Navigator.of(context).pop();
              action!();
            },
           
            child: Text('RETRY',style: TextStyle(fontSize: 18),)),
      ),
       Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Future.delayed(const Duration(milliseconds: 300),(){
                   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  //  exit(0);
              });
             
            },
            child: Text('OK',style: TextStyle(fontSize: 18),)),
      ),
        ],
      ),
      
    ],
  ),
),// bottom part
      Positioned(left: Constants.padding,
      right: Constants.padding,
      child: CircleAvatar(
      backgroundColor: type != 'Error' ? Colors.red[300] : Colors.white,
      radius: Constants.avatarRadius,
      child: ClipRRect(
         borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
         child: Icon( type=='Error' ? Icons.error: Icons.warning_outlined,
         size: Constants.avatarRadius+45,
         color: Colors.red[300])))),// top part
    ],
  );
}
}
