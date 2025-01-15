import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String? url;

enum ConfirmAction { AGREE, DISAGREE }

_launchURL(String url) async {

  // const _url = 'https://flutter.dev';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        title: Text('Alert!'),
        content: const Text(
            'You are being redirected to an external Link/ Website.'),
        actions: <Widget>[
          MaterialButton(
            child: const Text('DISAGREE', style: TextStyle(color: Color(0xFF00695C),),),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.DISAGREE);
            },
          ),
          MaterialButton(
            child: const Text('AGREE', style: TextStyle(color: Color(0xFF00695C),),),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.AGREE);
              _launchURL(url!);
            },
          )
        ],
      );
    },
  );
}

class Approvedvendors extends StatelessWidget
{
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar( iconTheme: new IconThemeData(color: Colors.white),
            backgroundColor: Colors.cyan[400],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text('Approved Vendors', style:TextStyle(
                        color: Colors.white
                    ))),
                IconButton(
                  icon: Icon(
                    Icons.home,color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
                    //Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            )),
        body: Material(
            color: Colors.grey[300],
            child: ListView(
              children: <Widget>[
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/railway.png',width: 35.0,height: 35.0,),
                            SizedBox(width:8),
                            Expanded(
                              child: InkWell(
                                child: Text("Research, Design and Standards Organisation (RDSO), Lucknow",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
                                onTap: (){
                                  url ="http://www.rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269";
                                  _asyncConfirmDialog(context);
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.0),
                        //Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 15.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 0.0)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,770";
                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),

                                Text("Civil",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(left: 0.0)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,771";
                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
                                Text("QA(Electrical)",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(left: 0.0)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,772";
                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),

                                Text("Mechanical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),

                          ],

                        ),
                        //Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,826";
                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30)),

                                Text("QA(S and T)",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                                Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0)),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://rdso.indianrailways.gov.in/index.jsp?lang=0";

                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),

                                Text("Works",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                                Padding(padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0)),
                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/railway.png',width: 35.0,height: 35.0,),
                            SizedBox(width:8),
                            InkWell(
                              child: Text("Integral Coach Factory (ICF), Perambur",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
                              onTap: (){
                                url ="http://icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295";
                                _asyncConfirmDialog(context);

                              },
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 15.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //Padding(padding: EdgeInsets.only(left:27.0)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://www.icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295,329,387";
                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
                                Text("Mechanical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),
                            //Padding(padding: EdgeInsets.only(left:27.0)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://www.icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295,329,384";

                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),

                                Text("Paints",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),
                            //Padding(padding: EdgeInsets.only(left:27.0)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://www.icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295,330,729";

                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),

                                Text("Electrical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),

                          ],

                        ),
                        Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/railway.png',width: 35.0,height: 35.0,),
                            SizedBox(width:8),
                            InkWell(
                              child: Text("Rail Coach Factory(RCF),Kapurthala",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
                              onTap: (){
                                url ="http://www.rcf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,562,567";
                                _asyncConfirmDialog(context);

                              },
                            ),
                            // new Text("   Rail Coach Factory(RCF),Kapurthala",style: TextStyle(fontSize:15.0,color: Colors.indigo[900],fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 15.0)),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://www.rcf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,562,563";

                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),

                                Text("Mechanical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),
                            Padding(padding: new EdgeInsets.only(left:27.0)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://www.rcf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,562,564";

                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),

                                Text("Electrical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),
                            Padding(padding: new EdgeInsets.only(left:27.0)),
                          ],

                        ),
                        Padding(padding: new EdgeInsets.all(8.0)),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/railway.png',width: 35.0,height: 35.0,),
                            SizedBox(width:8),
                            Expanded(
                              child: InkWell(
                                child: Text("Diesel Loco Modernization Works (DMW), Patiala",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
                                onTap: (){
                                  url ="http://dmw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376";
                                  _asyncConfirmDialog(context);

                                },
                              ),
                            )
                            //new Text("   Diesel Loco Modernization Works (DMW), Patiala",style: TextStyle(fontSize:15.0,color: Colors.indigo[900],fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 15.0)),
                        Row(
                          children: <Widget>[
                            //Padding(padding: new EdgeInsets.only(left:27.0)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://dmw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,557";
                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
                                Text("Phase 1",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),
                            Padding(padding: new EdgeInsets.only(left:27.0)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://dmw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,558";
                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
                                new Text("Phase 2",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),
                            Padding(padding: new EdgeInsets.only(left:27.0)),
                          ],

                        ),
                        Padding(padding: new EdgeInsets.all(8.0)),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/railway.png',width: 35.0,height: 35.0),
                            SizedBox(width:8),
                            Expanded(
                              child: InkWell(
                                child: Text("Central Organisation for Railway Electrification (CORE),Allahabad",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
                                onTap: (){
                                  url ="http://www.core.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376";
                                  _asyncConfirmDialog(context);

                                },
                              ),
                            )
                            //new Text("   Central Organisation for Railway \n   Electrification(CORE),Allahabad",style: TextStyle(fontSize:15.0,color: Colors.indigo[900],fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 15.0)),
                        Row(
                          children: <Widget>[
                            //Padding(padding: EdgeInsets.only(left:27.0)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://www.core.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,444";
                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
                                // new  Image.asset('assets/zone_coloured.png',width: 45.0,height: 35.0,),
                                Text("Electrical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(left:27.0)),
                            Column(
                              children: <Widget>[
                                MaterialButton( onPressed:(){
                                  _asyncConfirmDialog(context);
                                  url="http://www.core.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,445";
                                },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
                                Text("Stores",style: TextStyle(fontSize:15.0,color: Colors.black,)),
                              ],
                            ),
                            Padding(padding: new EdgeInsets.only(left:27.0)),
                          ],

                        ),
                        Padding(padding: new EdgeInsets.all(8.0)),
                      ],
                    ),
                  ),

                ),
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        //Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0,15.0)),
                        Row(
                          children: <Widget>[
                            Image.asset('assets/railway.png',width: 35.0,height: 35.0),
                            SizedBox(width:8),
                            InkWell(
                              child: Text("Diesel Locomotive Works(DLW), Varanasi",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
                              onTap: (){
                                url ="http://www.dlw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,714,743";
                                _asyncConfirmDialog(context);

                              },
                            ),
                            // new Text("   Diesel Locomotive Works(DLW), Varanasi",style: TextStyle(fontSize:15.0,color: Colors.indigo[900],fontWeight: FontWeight.bold),)
                          ],
                        ),
                        //Padding(padding: new EdgeInsets.fromLTRB(5.0, 0.0, 30.0, 15.0)),
                      ],
                    ),
                  ),),
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/railway.png',width: 35.0,height: 35.0,),
                            SizedBox(width:8),
                            Expanded(
                              child: InkWell(
                                child: Text("Chittaranjan Locomotive Works (CLW), Chittaranjan",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
                                onTap: (){
                                  url ="http://www.clw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376";
                                  _asyncConfirmDialog(context);

                                },
                              ),
                            ),
                          ],
                        ),
                        ],
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}