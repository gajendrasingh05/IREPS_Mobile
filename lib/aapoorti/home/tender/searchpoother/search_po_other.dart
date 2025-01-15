//dependencies url_launcher: ^5.0.2

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
String? url;

enum ConfirmAction { AGREE, DISAGREE }


class SearchPoOther extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: true,
      // backgroundColor: Colors.grey[300],
      // appBar:AppBar(iconTheme: IconThemeData(color: Colors.white),
      //     backgroundColor: Colors.cyan[400],
      //     title: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Container(
      //             child: Text('Supply Contracts ', style:TextStyle(
      //                 color: Colors.white
      //             ))),
      //         // new Padding(padding: new EdgeInsets.only(right: 35.0)),
      //         new IconButton(
      //           icon: new Icon(
      //             Icons.home,color: Colors.white,
      //           ),
      //           onPressed: () {
      //             Navigator.of(context, rootNavigator: true).pop();
      //           },
      //         ),
      //       ],
      //     )),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                width: 400,
                height: 25,
                color: Colors.cyan.shade600,
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  ' Other Zonal Railways',
                  style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.cyan.shade600,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child:
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: (MediaQuery.of(context).size.width-40)/2,
                            height: (MediaQuery.of(context).size.height-40)/5,
                            margin: const EdgeInsets.only(top:10.0,left: 10.0),
                            //  padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
                            child:Column(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
                                Text("DLW",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
                                Text("Varanasi",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
                              ],
                            ),
                          ),
                          onTap: (){
                            url ="http://dlw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,299,446,722";
                            _asyncConfirmDialog(context);
                          },),
        
        
                        InkWell(child: Container(
                          width: (MediaQuery.of(context).size.width-40)/2,
                          height: (MediaQuery.of(context).size.height-40)/5,
                          margin: const EdgeInsets.only(top:10.0,left: 10.0),
                          //  padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
                          child:Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
                              Text("ICF",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
                              Text("Perambur",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
                            ],
                          )
        
                          ,
                        ),
        
                          onTap: (){
                            url ="http://icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,297";
                            _asyncConfirmDialog(context);
                          },)
        
                      ],
                    ),
                    Row(  children: <Widget>[
                      InkWell(child: Container(
                        width: (MediaQuery.of(context).size.width-40)/2,
                        height: (MediaQuery.of(context).size.height-40)/5,
                        margin: const EdgeInsets.only(top:10.0,left: 10),
                        //padding: const EdgeInsets.all(38),
                        decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
                        child:Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
                            Text("RCF",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
                            Text("Kapurthala",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
                          ],
                        )
        
                        ,
                      ),   onTap: (){
                        url ="http://www.rcf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,299,586";
                        _asyncConfirmDialog(context);
                      },),
        
                      InkWell(
                        child:    Container(
                          width: (MediaQuery.of(context).size.width-40)/2,
                          height: (MediaQuery.of(context).size.height-40)/5,
                          margin: const EdgeInsets.only(top:10.0,left: 10.0),
                          //  padding: const EdgeInsets.all(38),
                          decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
                          child:Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
                              Text("MCF",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
                              Text("Raebareli",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
                            ],
                          )
        
                          ,
                        ) ,
                        onTap: (){
                          url ="http://mcf.indianrailways.gov.in/storerblDeptTenderFinal.jsp?lang=0&id=0,299";
                          _asyncConfirmDialog(context);
                        },
                      )
                    ],),
                    Row(  children: <Widget>[
        
        
                      InkWell(child: Container(
                        width: (MediaQuery.of(context).size.width-40)/2,
                        height: (MediaQuery.of(context).size.height-40)/5,
                        margin: const EdgeInsets.only(top:10.0,left: 10.0),
                        //  padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
                        child:Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
                            Text("CLW",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
                            Text("Chittranjan",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
                          ],
                        )
        
                        ,
                      ), onTap: (){
                        url ="http://clw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,299,421";
                        _asyncConfirmDialog(context);
                      },),
                      InkWell(child:  Container(
                        width: (MediaQuery.of(context).size.width-40)/2,
                        height: (MediaQuery.of(context).size.height-40)/5,
                        margin: const EdgeInsets.only(top:10.0,left: 10.0),
                        // padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
                        child:Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
                            Text("DMW",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
                            Text("Patiala",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
                          ],
                        )
        
                        ,
                      ), onTap: (){
                        url ="http://dmw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,299,317,388";
                        _asyncConfirmDialog(context);
                      }, ),
        
        
                    ],),
        
                    Row(  children: <Widget>[
        
        
                      InkWell(child: Container(
                        width: (MediaQuery.of(context).size.width-40)/2,
                        height: (MediaQuery.of(context).size.height-40)/5,
                        // width: 170,
                        // height: 105,
                        margin: const EdgeInsets.only(top:10.0,left: 10.0),
                        //  padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
                        child:Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
                            Text("RWF",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
                            Text("Bangalore",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
                          ],
                        ),
                      ), onTap: (){
                        url ="http://www.rwf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295,403,423";
                        _asyncConfirmDialog(context);
                      },),
                      InkWell(child:  Container(
                        width: (MediaQuery.of(context).size.width-40)/2,
                        height: (MediaQuery.of(context).size.height-40)/5,
                        margin: const EdgeInsets.only(top:10.0,left: 10.0),
                        // padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
                        child:Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
                            Text("CORE",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
                            Text("Allahabad",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
                          ],
                        )
        
                        ,
                      ), onTap: (){
                        url ="http://core.indianrailways.gov.in/coreContractPublic.jsp?lang=0&id=0,299";
                        _asyncConfirmDialog(context);
                      }, ),
        
        
                    ],),
        
                  ],
                ),
              )
            ],
          ),
        ),
      ),


    );
    // return WillPopScope(
    //     onWillPop: () async {
    //   Navigator.of(context, rootNavigator: true).pop();
    //   return false;
    // },
    // child: Scaffold(   resizeToAvoidBottomInset: false,
    //   //resizeToAvoidBottomPadding: true,
    //   backgroundColor: Colors.grey[300],
    // appBar:AppBar(
    //     iconTheme: new IconThemeData(color: Colors.white),
    //
    //     backgroundColor: Colors.cyan[400],
    // title: new Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // children: [
    // Container(
    // child: Text('Supply Contracts ', style:TextStyle(
    // color: Colors.white
    // ))),
    // // new Padding(padding: new EdgeInsets.only(right: 35.0)),
    // new IconButton(
    // icon: new Icon(
    // Icons.home,color: Colors.white,
    // ),
    // onPressed: () {
    // Navigator.of(context, rootNavigator: true).pop();
    // },
    // ),
    // ],
    // )),
    //   body: Container(
    //
    //     child: Column(
    //
    //       children: <Widget>[
    //         Container(
    //           width: 400,
    //           height: 25,
    //           color: Colors.cyan.shade600,
    //           padding: const EdgeInsets.only(top: 7),
    //           child: Text(
    //             ' Other Zonal Railways',
    //             style: new TextStyle(
    //                 color: Colors.white,
    //                 backgroundColor: Colors.cyan.shade600,
    //                 fontSize: 15),
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //         Expanded(
    //           child:
    //           Column(
    //             children: <Widget>[
    //               Row(
    //                 children: <Widget>[
    //                   InkWell(
    //                     child: Container(
    //                       width: (MediaQuery.of(context).size.width-40)/2,
    //                       height: (MediaQuery.of(context).size.height-40)/5,
    //                     margin: const EdgeInsets.only(top:10.0,left: 10.0),
    //                     //  padding: const EdgeInsets.all(40),
    //                     decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
    //                     child:Column(
    //                       children: <Widget>[
    //                         Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
    //                         Text("DLW",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
    //                         Text("Varanasi",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
    //                       ],
    //                     ),
    //                   ),
    //                     onTap: (){
    //                       url ="http://dlw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,299,446,722";
    //                       _asyncConfirmDialog(context);
    //                     },),
    //
    //
    //                   InkWell(child: Container(
    //                     width: (MediaQuery.of(context).size.width-40)/2,
    //                     height: (MediaQuery.of(context).size.height-40)/5,
    //                     margin: const EdgeInsets.only(top:10.0,left: 10.0),
    //                     //  padding: const EdgeInsets.all(40),
    //                     decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
    //                     child:Column(
    //                       children: <Widget>[
    //                         Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
    //                         Text("ICF",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
    //                         Text("Perambur",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
    //                       ],
    //                     )
    //
    //                     ,
    //                   ),
    //
    //                     onTap: (){
    //                       url ="http://icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,297";
    //                       _asyncConfirmDialog(context);
    //                     },)
    //
    //                 ],
    //               ),
    //               Row(  children: <Widget>[
    //                 InkWell(child: Container(
    //                   width: (MediaQuery.of(context).size.width-40)/2,
    //                   height: (MediaQuery.of(context).size.height-40)/5,
    //                   margin: const EdgeInsets.only(top:10.0,left: 10),
    //                   //padding: const EdgeInsets.all(38),
    //                   decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
    //                   child:Column(
    //                     children: <Widget>[
    //                       Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
    //                       Text("RCF",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
    //                       Text("Kapurthala",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
    //                     ],
    //                   )
    //
    //                   ,
    //                 ),   onTap: (){
    //                   url ="http://www.rcf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,299,586";
    //                   _asyncConfirmDialog(context);
    //                 },),
    //
    //                 InkWell(
    //                   child:    Container(
    //                     width: (MediaQuery.of(context).size.width-40)/2,
    //                     height: (MediaQuery.of(context).size.height-40)/5,
    //                     margin: const EdgeInsets.only(top:10.0,left: 10.0),
    //                     //  padding: const EdgeInsets.all(38),
    //                     decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
    //                     child:Column(
    //                       children: <Widget>[
    //                         Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
    //                         Text("MCF",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
    //                         Text("Raebareli",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
    //                       ],
    //                     )
    //
    //                     ,
    //                   ) ,
    //                   onTap: (){
    //                     url ="http://mcf.indianrailways.gov.in/storerblDeptTenderFinal.jsp?lang=0&id=0,299";
    //                     _asyncConfirmDialog(context);
    //                   },
    //                 )
    //               ],),
    //               Row(  children: <Widget>[
    //
    //
    //                 InkWell(child: Container(
    //                   width: (MediaQuery.of(context).size.width-40)/2,
    //                   height: (MediaQuery.of(context).size.height-40)/5,
    //                   margin: const EdgeInsets.only(top:10.0,left: 10.0),
    //                   //  padding: const EdgeInsets.all(32),
    //                   decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
    //                   child:Column(
    //                     children: <Widget>[
    //                       Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
    //                       Text("CLW",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
    //                       Text("Chittranjan",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
    //                     ],
    //                   )
    //
    //                   ,
    //                 ), onTap: (){
    //                   url ="http://clw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,299,421";
    //                   _asyncConfirmDialog(context);
    //                 },),
    //                 InkWell(child:  Container(
    //                   width: (MediaQuery.of(context).size.width-40)/2,
    //                   height: (MediaQuery.of(context).size.height-40)/5,
    //                   margin: const EdgeInsets.only(top:10.0,left: 10.0),
    //                   // padding: const EdgeInsets.all(32),
    //                   decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
    //                   child:Column(
    //                     children: <Widget>[
    //                       Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
    //                       Text("DMW",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
    //                       Text("Patiala",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
    //                     ],
    //                   )
    //
    //                   ,
    //                 ), onTap: (){
    //                   url ="http://dmw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,299,317,388";
    //                   _asyncConfirmDialog(context);
    //                 }, ),
    //
    //
    //               ],),
    //
    //               Row(  children: <Widget>[
    //
    //
    //                 InkWell(child: Container(
    //                   width: (MediaQuery.of(context).size.width-40)/2,
    //                   height: (MediaQuery.of(context).size.height-40)/5,
    //                  // width: 170,
    //                  // height: 105,
    //                   margin: const EdgeInsets.only(top:10.0,left: 10.0),
    //                   //  padding: const EdgeInsets.all(32),
    //                   decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
    //                   child:Column(
    //                     children: <Widget>[
    //                       Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
    //                       Text("RWF",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
    //                       Text("Bangalore",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
    //                     ],
    //                   ),
    //                 ), onTap: (){
    //                   url ="http://www.rwf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295,403,423";
    //                   _asyncConfirmDialog(context);
    //                 },),
    //                 InkWell(child:  Container(
    //                   width: (MediaQuery.of(context).size.width-40)/2,
    //                   height: (MediaQuery.of(context).size.height-40)/5,
    //                   margin: const EdgeInsets.only(top:10.0,left: 10.0),
    //                   // padding: const EdgeInsets.all(32),
    //                   decoration: BoxDecoration(border: Border.all(color: Colors.teal[700]!,width: 6),borderRadius: BorderRadius.circular(6.0),color: Colors.white),
    //                   child:Column(
    //                     children: <Widget>[
    //                       Padding(padding: EdgeInsets.only(top:20.0,bottom: 10)),
    //                       Text("CORE",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900],fontSize: 25.0)) ,
    //                       Text("Allahabad",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.indigo[900]),)
    //                     ],
    //                   )
    //
    //                   ,
    //                 ), onTap: (){
    //                   url ="http://core.indianrailways.gov.in/coreContractPublic.jsp?lang=0&id=0,299";
    //                   _asyncConfirmDialog(context);
    //                 }, ),
    //
    //
    //               ],),
    //
    //             ],
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    //
    //
    // ));
  }
}
