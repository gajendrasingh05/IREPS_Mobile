import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';

class NoData extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: new Scaffold(   resizeToAvoidBottomInset: false,
          //resizeToAvoidBottomPadding: true,
          appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.cyan[400],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                      child: Text('IREPS', style:TextStyle(
                          color: Colors.white
                      ))),
                  // new Padding(padding: new EdgeInsets.only(right: 50.0)),
                  //new Padding(padding: new EdgeInsets.all(30)),
                  //  IconButton(
                  //     icon: new Icon(
                  //       Icons.home,color: Colors.white,
                  //     ),
                  //     onPressed: () {
                  //       Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false) ;})
                ],
              )),



      body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image(image:AssetImage("assets/nodatafound.png"),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,),
              ),
              Text('Oops! No record found.',textAlign: TextAlign.center,style: TextStyle(fontSize: 16),)
            ],
          )),/* Container(

        decoration: BoxDecoration(
          color: Colors.grey[100],
          image: DecorationImage(

            image: AssetImage("assets/nodatafound.png"),
            fit: BoxFit.fitWidth,

          ),
        ),
        child: null *//* add child content here *//*,
      ),*/
    )
    );
  }
}