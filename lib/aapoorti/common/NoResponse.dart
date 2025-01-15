import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';

class NoResponse extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    AapoortiUtilities al=new AapoortiUtilities();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        primaryColor: Colors.teal,
        textTheme: TextTheme(
        /* headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.green),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic,color: Colors.red),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind',color: Colors.orange),*/
        //caption:  TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.blueGrey),
    ),
    primarySwatch: Colors.teal,

    ),
    home: Scaffold(   resizeToAvoidBottomInset: false,
        // //resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor:Colors.teal,
          title: Text('IREPS',style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold,),),

        ),
      body:new Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 50,bottom: 40,right: 50),
            //width: 100,
            child: Image(image:AssetImage("assets/no_response.jpg"),
            fit: BoxFit.fitWidth,),
          ),
          Text('Oops! Service temporarily unavailable. \n Please try again later.',textAlign: TextAlign.center,style: TextStyle(fontSize: 16),)
        ],
      )),

    )
    );
  }
}