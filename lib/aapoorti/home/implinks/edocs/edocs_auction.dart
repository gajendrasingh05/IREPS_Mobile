import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Edocuments_func.dart';
import 'IREPSpucdocs.dart';
class edocs_auction extends StatelessWidget{
  String? name;
  List<String> Zonalrly=["Central Railways","East Coast Railways","East Central Railways","Eastern Railways","Kolkata Metro",
  "North Central Railwys","North Eastern Railways","Northern Railways","North Frontier Railways","North Western Railways",
  "South Central Railways","South Eastern Railways","South East Central Railways","Southern Railways","South Western Railways",
  "West Central Railways","Western Railways"];
  List<String> Production_unit=[
  "Chittranjan Locomotive Works","Diesel Locomotive Works / Varansi","Diesel Loco Modernisation Works / Patiala",
   "Integral Coach Factory / Chennai","Rail Coach Factory / Kapurthla","Rail Coach Factory / Raebrali","Rail Wheel Factory / Banglore",
  "Rail Wheel Plant / Bela"
    ];
  List<String> RlyBoard_otherUnt=["COFMOW","CRIS","Delhi Metro Rail Corp.","Konkan Railways","Mumbai Railways Vikas Corp."
  "Railway Board","CORE / Allahabad","RDSO"];



  Future _Overlaypdf(BuildContext context,List<String> pdf,String name)
  {
    this.name=name;
    return showDialog(
        context: context,
        builder: (_) => Material(
            type: MaterialType.transparency,
            child: Center(
                child:Container(
                    margin: EdgeInsets.only(top: 55),
                    padding: EdgeInsets.only( bottom: 50),
                    color: Color(0xAB000000),

                    // Aligns the container to center
                    child:Column(
                        children:<Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only( bottom: 20),
                              child:
                              Edocuments_func.OverlayList(context,pdf,name),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child:
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                },
                                child: Image(image: AssetImage('images/close_overlay.png'), height: 50, )
                            ),

                          )
                        ]
                    )

                )
            )

        )

    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // //resizeToAvoidBottomPadding: true,
          appBar: AppBar(
              iconTheme: new IconThemeData(color: Colors.white),

              backgroundColor: Colors.cyan[400],
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Text('Public Documents', style:TextStyle(
                          color: Colors.white
                      ))),
                  new Padding(padding: new EdgeInsets.only(right: 40.0)),
                  new IconButton(
                    icon: new Icon(
                      Icons.home,color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
                    },
                  ),
                ],
              )),
          /* MaterialApp(
        debugShowCheckedModeBanner: false,

        title: "About Us",*/



          body: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
              Container(
                width:370.0,
                height: 25.0,
                padding:  EdgeInsets.only(top: 5.0),
                child: Text("   Auction",style:
                TextStyle(fontSize: 15,color: Colors.white),
                  textAlign: TextAlign.start,),
                color: Colors.cyan[700],
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Container(
                height:30.0,
                child:
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top:90.0,left: 10.0),),
                    Image.asset('assets/web_edocs.jpg',width: 30,height: 30,),
                    GestureDetector(
                      child:  Container(
                        height: 20.0,
                        child:Text("   Zonal Railways",style: TextStyle(fontSize: 15,fontWeight:FontWeight.normal),) ,

                      ),
                      onTap: ()
                      {
                        _Overlaypdf(context,Zonalrly,"Zonal Railways");
                      },
                    ),

                  ],
                ),
              ),

                Padding(padding: EdgeInsets.only(top: 10.0,bottom: 1.0,left: 10.0),),
                Container(
                  color: Colors.cyan[700],
                  height: 2.0,
                  width: 345.0,
                ),
                Padding(padding: EdgeInsets.only(top:5.0),),
                Container(
                  height:30.0,
                  child:
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top:90.0,left: 10.0),),
                      Image.asset('assets/web_edocs.jpg',width: 30,height: 30,),
                      GestureDetector(
                        child:  Container(
                          height: 20.0,
                          child:Text("   Production Units",style: TextStyle(fontSize: 15,fontWeight:FontWeight.normal),) ,

                        ),
                        onTap: ()
                        {
                          _Overlaypdf(context,Production_unit,"Production_unit");
                        },
                      ),

                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10.0,top: 10.0,bottom: 1.0),),
                Container(
                  color: Colors.cyan[700],
                  height: 2.0,
                  width: 345.0,
                ),
                Padding(padding: EdgeInsets.only(top:5.0),),
                Container(
                  height:30.0,
                  child:
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top:90.0,left: 10.0),),
                      Image.asset('assets/web_edocs.jpg',width: 30,height: 30,),
                      GestureDetector(
                        child:  Container(
                          height: 20.0,
                          child:Text("   Railway Board and Other Units",style: TextStyle(fontSize: 15,fontWeight:FontWeight.normal),) ,

                        ),
                        onTap: ()
                        {
                          _Overlaypdf(context,RlyBoard_otherUnt,"RlyBoard_otherUnt");
                        },
                      ),

                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10.0,top: 10.0,bottom: 1.0),),
                Container(
                  color: Colors.cyan[700],
                  height: 2.0,
                  width: 345.0,
                ),
                Padding(padding: EdgeInsets.only(top:5.0),),
                Container(
                  height:30.0,
                  child:
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top:90.0,left: 10.0),),
                      Image.asset('assets/web_edocs.jpg',width: 30,height: 30,),
                      GestureDetector(
                        child:  Container(
                          height: 20.0,
                          child: Row(
                            children: <Widget>[
                              Text("  IREPS public Documents",style: TextStyle(fontSize: 15,fontWeight:FontWeight.normal),) ,
                             ],
                          ),
                        ),
                        onTap: ()
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => IREPSpubdocs()),
                          );
                        },
                      ),

                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10.0,top: 10.0,bottom: 1.0),),
                 Container(
                   color: Colors.cyan[700],
                   height: 2.0,
                   width: 345.0,
                 ),

                Padding(padding: EdgeInsets.only(top:5.0),),
              ],
            )
          ],
        ),
    )
    );
    }


}
