import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';

class ComingSoonLogin extends StatelessWidget{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context){
    AapoortiUtilities al=new AapoortiUtilities();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        primaryColor: Colors.cyan[400],
        textTheme: TextTheme(
        /* headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.green),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic,color: Colors.red),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind',color: Colors.orange),*/
        //caption:  TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.blueGrey),
    ),
    primarySwatch: Colors.cyan,

    ),
    home: Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      // //resizeToAvoidBottomPadding: true,
    appBar: AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor:Colors.cyan[400],
    title: Text('IREPS',style: TextStyle(color: Colors.white,
    fontWeight: FontWeight.bold,),),

    ),
    drawer :AapoortiUtilities.navigationdrawerbeforLOgin(_scaffoldKey, context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
        decoration: BoxDecoration(
          //color: Colors.grey[100],
          image: DecorationImage(
            image: AssetImage("assets/comingsoon.jpg"),
            fit: BoxFit.fitHeight,

          ),
        ),
        padding: EdgeInsets.only(top: 230),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('\nLogin on Apple devices will be available soon.',style: TextStyle(fontSize: 17),),
            ]),
      ),])),
        bottomNavigationBar:AapoortiUtilities.dummyBottomNavigationBar(context),
    )
    );
  }
}

