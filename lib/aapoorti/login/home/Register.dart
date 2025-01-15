import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/home/home_screen.dart';
import 'package:flutter_app/main.dart';
class Register extends StatelessWidget
{
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          title:Text("Enable Login Access"),backgroundColor: Colors.cyan[400],
          actions: <Widget>[
            IconButton(icon: Icon(Icons.home), onPressed: () {
              //Navigator.pushNamed(context, "/home");
              // Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen(scaffoldKey)));
               //09.09.
              Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
            },),
          ],),
        body: Material(
            color: Colors.cyan[50],
            child:
            new ListView(
              children: <Widget>[
                new Padding(padding: new EdgeInsets.fromLTRB(35.0, 10.0, 30.0, 20.0)),
                new Card(
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      new Padding(padding: new EdgeInsets.all(5.0)),
                      new  Row(
                        children: <Widget>[
                          Text("   Note: ",style: TextStyle(fontSize:15.0,fontWeight: FontWeight.normal,color: Colors.red),)
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      //new Padding(padding: new EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                      new Row(
                        children: <Widget>[
                          Padding(padding: new EdgeInsets.only(left:15.0)),
                          Text("1. Login feature is available to users already \n    registered in IREPS.",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                          Padding(padding: new EdgeInsets.only(left:20.0)),
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      new Row(
                        children: <Widget>[
                          Padding(padding: new EdgeInsets.only(left:15.0)),
                          Text("2. Login feature is available on Mobile App for:\n",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                          //Padding(padding: new EdgeInsets.only(bottom: 35.0)),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          Padding(padding: new EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 10.0)),
                          //Padding(padding: new EdgeInsets.only(top:1.0)),
                          RichText(
                            text: TextSpan(
                              text: 'Vendor',
                              style: TextStyle(fontSize:15.0,color: Colors.blueGrey,),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '                              Launched',
                                    style: TextStyle(fontWeight:FontWeight.bold,color: Colors.green[500],)
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          Padding(padding: new EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 10.0)),
                          RichText(
                            text: TextSpan(
                              text: 'Railway User(Tender)',
                              style: TextStyle(fontSize:15.0,color: Colors.blueGrey,),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '     Launched',
                                    style: TextStyle(fontWeight:FontWeight.bold,color: Colors.green[500],)
                                ),
                              ],
                            ),
                          ),
                        ],
                      ), new Row(
                        children: <Widget>[
                          Padding(padding: new EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 10.0)),
                          RichText(
                            text: TextSpan(
                              text: 'Bidder',
                              style: TextStyle(fontSize:15.0,color: Colors.blueGrey,),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '                               Coming Soon',
                                    style: TextStyle(color: Colors.redAccent,)
                                ),
                              ],
                            ),
                          ),/*//Padding(padding: new EdgeInsets.only(top:1.0)),
                          Text("Bidder",style: TextStyle(fontSize:15.0,color: Colors.blueGrey,)),*/
                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                Card(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(8.0)),
                      Row(
                        children: <Widget>[
                          Text("   To enable Login access for IREPS: ",style: TextStyle(fontSize:15.0,fontWeight: FontWeight.normal),)
                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      //new Padding(padding: new EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left:30.0)),
                          Text("1. Login to www.ireps.gov.in",style: TextStyle(fontSize:15.0,color: Colors.blueGrey,)),
                          Padding(padding: EdgeInsets.only(left:35.0)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left:30.0)),
                          Text("2. Go to link on the right navigation (Enable\n    MobileApp Access for IREPS)",style: TextStyle(fontSize:15.0,color: Colors.blueGrey,)),
                          //Padding(padding: new EdgeInsets.only(bottom: 35.0)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left:30.0)),
                          Text("3. Complete the process.",style: TextStyle(fontSize:15.0,color: Colors.blueGrey,)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}