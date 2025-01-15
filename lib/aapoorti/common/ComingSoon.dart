import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';

class ComingSoon extends StatelessWidget{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context){
    AapoortiUtilities al= AapoortiUtilities();
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

    home: Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
    appBar: AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor:Colors.teal,
    title: Text('IREPS',style: TextStyle(color: Colors.white,
    fontWeight: FontWeight.bold,),),

    ),
      drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey,context),
      body: Container(

        decoration: BoxDecoration(
          color: Colors.grey[100],
          image: DecorationImage(

            image: AssetImage("assets/comingsoon.jpg"),
            fit: BoxFit.fitWidth,

          ),
        ),
        child: null /* add child content here */,
      ),

    )
    );
  }
}