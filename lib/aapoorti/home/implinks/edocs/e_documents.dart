import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';

import 'Edocuments_func.dart';


class Edocs  extends StatelessWidget{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  String urlSystem_settings="https://ireps.gov.in/ireps/upload/resources/SystemSettings.pdf";
  List<String> pdfGeneral=[ "Security Aspects for use of E-tokens",
    "Procedure for Public Key Export from E-token",
    "List of Special Characters Not Allowed  as Input \n    /Upload",
    "Getting Your System Ready for IREPS Application",
    "IREPS Security Tips",
    "Guidelines for Procurement, Use and managem-\n  ent of Encryption Certificate Version 2.0 \n ( for Railway Users )",
    "Procedure for Mapping Party Codes and Viewing\n  Status of Bills",
    "User Manual for Contractors/ Suppliers for Online\n  Bill Tracking Version 1.0",
    "User Manual for Registration of New Vendors \n  and Contractors Version 1.0",
    "User Manual for creation/Change of Primary\n user(Vendors)"];

  List<String> pdfGoodsandServices=[ "User Manual for Vendors (Goods and Services) \n  Version 1.0",
    "How to Turn Off Compatibility View Settings",
    "User manual for vendors on Post Contract \n  Activities",
    "User Manual for Vendors- for Reverse Auction\n  (Goods and Services Module) Version 2",
    "User Manual for On-line Submission of \nSupplementary Bills by Vendors(Version-1.0)"];

  List<String> pdfWorks=[ "User Manual for Contractors",
    "User Manual for Standard Railway User\n  ( Version 1.0 )",
    "User Manual for Department Admins(Version 1.0)\n  ( for Railway Users )",
    "Creation and Management of SOR and NS Item\n  Directories ( for Railway Users )",
    "User Manual for Contractors - For Two Stage \n  Reverse Auction (Works Module) Version 2.0"];

  List<String> pdfEarningLeasing=[ "User Manual for Contractors (Earning / Leasing)\n  Version 1.0"];

  List<String> pdfE_Auction=[ "Bidder User Manual",
    "Guide For SBI Corporate Account User",
    "User Manual of Balance Sale Value and Invoice \n  Generation",
    "User Manual for Bidders On Lot Publishing\n Module"];

  List<String> pdf_iMMS=[ "User Manual for HQ users (HQ Module)",
    "User Manual for Depot users Depot Module)",
    "User Manual for Depot and Division users \n  (LP Module)",
    "User Manual for System Administrator",
    "Procedure For Installation of Java And PKI Server",
    "Procedure For Change Digital Certificate(DSC)"];

  List<String> pdfFaq=[
    "E-Tender",
    "E-Auction",
    "E-Payment"];
  String? name;
  //var String a = '["one", "two", "three", "four"]';
  Future _Overlaypdf(BuildContext context,List<String> pdf,String name) {
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
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.cyan[400],
          textTheme: TextTheme(),
          primarySwatch: Colors.cyan,
        ),
        debugShowCheckedModeBanner:false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
          appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
                //Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
          backgroundColor:Colors.cyan[400],
          title: Text('E-Documents', style: TextStyle(color: Colors.white))),
            backgroundColor: Colors.grey[200],
            drawer : AapoortiUtilities.navigationdrawerbeforLOgin(_scaffoldKey,context),
            body: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Card(
                      color: Colors.white,
                      surfaceTintColor: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Row(
                            children: <Widget>[
                              Text("                                      Learning Centre",
                                style:TextStyle(fontWeight:FontWeight.bold,
                                  fontSize: 17,color: Colors.indigo),textAlign:TextAlign.center,)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 20.0)),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(right: 10.0)),
                              MaterialButton( onPressed:(){
                                _Overlaypdf(context,pdfGeneral,"General");
                              },
                                  padding: EdgeInsets.all(0.0),
                                  child: Image.asset('assets/general.jpg',width: 40,height: 40,)
                              ),
                              Padding(padding: EdgeInsets.only(right: 30.0)),
                              MaterialButton( onPressed:(){
                                _Overlaypdf(context,pdfGoodsandServices,"Goods and services");

                              },
                                  padding: EdgeInsets.all(0.0),
                                  child: Image.asset('assets/trolly.png',width: 40,height: 40,)
                              ),
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              MaterialButton( onPressed:(){
                                _Overlaypdf(context,pdfWorks,"works");

                              },
                                  padding: EdgeInsets.all(0.0),
                                  child: Image.asset('assets/trolly.png',width: 40,height: 40,)
                              ),

                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(right: 35.0)),
                              Text('General',style: TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 60.0)),
                              Text('E-Tender',style: TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 70.0)),
                              Text('E-Tender',style: TextStyle(color: Colors.black,fontSize:15),),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(right: 60.0)),
                              Text('      \n',style: TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              Text('(Goods&Services)\n',style: TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              Text('(Works)\n',style: TextStyle(color: Colors.black,fontSize:15),),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 20.0)),

                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(right: 0.0)),
                              MaterialButton( onPressed:(){
                                _Overlaypdf(context,pdfEarningLeasing,"EarningLeasing");
                              },
                                  padding: EdgeInsets.all(0.0),
                                  child: Image.asset('assets/trolly.png',width: 40,height: 40,)
                              ),
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              MaterialButton( onPressed:(){
                                _Overlaypdf(context,pdfE_Auction,"Auction");

                              },
                                  padding: EdgeInsets.all(0.0),
                                  child: Image.asset('assets/hammer.png',width: 40,height: 40,)
                              ),
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              MaterialButton( onPressed:(){
                                _Overlaypdf(context,pdf_iMMS,"iMMS");
                              },
                                  padding: EdgeInsets.all(0.0),
                                  child: Image.asset('assets/mms.png',width: 40,height: 40,)
                              ),

                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              Text('E-Tender',style: TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 55.0)),
                              Text('E-Auction',style: TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 70.0)),
                              Text('iMMS',style: TextStyle(color: Colors.black,fontSize:15),),
                            ],
                          ),
                          Row(children: <Widget>[
                            Padding(padding: EdgeInsets.only(right: 10.0)),
                              Text('(Earning/Leasing)\n',style: TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              Text('         \n',style: TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              Text('         \n',style: TextStyle(color: Colors.black,fontSize:15),),
                           ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 20.0)),

                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(right: 10.0)),
                              MaterialButton( onPressed:(){
                                _Overlaypdf(context,pdfFaq,"Faq");

                              },
                                  padding: EdgeInsets.all(0.0),
                                  child: Image.asset('assets/faq.jpg',width: 40,height: 40,)
                              ),
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              MaterialButton( onPressed:(){
                                var fileUrl="https://ireps.gov.in/ireps/upload/resources/SystemSettings.pdf";
                                var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                AapoortiUtilities.ackAlert(context,fileUrl,fileName);

                              },
                                  padding: EdgeInsets.all(0.0),
                                  child: Image.asset('assets/pdf.png',width: 38,height: 38,)
                              ),
                              Padding(padding: EdgeInsets.only(right: 35.0)),
                              new Text("          ")

                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              new  Text('FAQ',style: new TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 60.0)),
                              new  Text('System Settings',style: new TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 70.0)),
                              new  Text('         ',style: new TextStyle(color: Colors.black,fontSize:15),),
                            ],
                          ),
                          Row(children: <Widget>[
                              Padding(padding: EdgeInsets.only(right: 60.0)),
                              Text('      \n',style: new TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              Text('           \n',style: new TextStyle(color: Colors.black,fontSize:15),),
                              Padding(padding: EdgeInsets.only(right: 40.0)),
                              Text('          \n',style: new TextStyle(color: Colors.black,fontSize:15),),
                            ],
                          )
                        ],
                      ),

                    ),
                    Padding(padding: EdgeInsets.all(2.0)),
                    Card(
                      color: Colors.white,
                      surfaceTintColor: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Row(children: <Widget>[
                              Text("                            Public Documents",style:TextStyle(fontWeight:FontWeight.bold,
                                  fontSize: 17,color: Colors.indigo),textAlign:TextAlign.center,)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 20.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              // Padding(padding: EdgeInsets.only(right: 10.0)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    onPressed:(){
                                    Navigator.pushNamed(context, "/edocs_GandS");

                                  },
                                      padding: EdgeInsets.all(0.0),
                                      child: Image.asset('assets/general.jpg',width: 40,height: 40,)
                                  ),
                                   Text('Goods & Services',style: new TextStyle(color: Colors.black,fontSize:15),),
                                ],
                              ),
                              // Padding(padding: EdgeInsets.only(right: 35.0)),
                              Column(
                                children: [
                                  MaterialButton( onPressed:(){
                                    Navigator.pushNamed(context, "/edocs_auction");

                                  },
                                      padding: EdgeInsets.all(0.0),
                                      child: Image.asset('assets/trolly.png',width: 40,height: 40,)
                                  ),
                                  Text('Auction',style: new TextStyle(color: Colors.black,fontSize:15),),

                                ],
                              ),
                              // Padding(padding: EdgeInsets.only(right: 30.0)),
                              Column(
                                children: [
                                  MaterialButton( onPressed:(){
                                    Navigator.pushNamed(context, "/edocs_works");

                                  },
                                      padding: EdgeInsets.all(0.0),
                                      child: Image.asset('assets/trolly.png',width: 40,height: 40,)
                                  ),
                                  Text('Works',style: new TextStyle(color: Colors.black,fontSize:15),),
                                ],
                              ),

                            ],
                          ),
                          SizedBox(height:8)


                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10.0))
                  ],
                )
              ],
            )));
  }

}