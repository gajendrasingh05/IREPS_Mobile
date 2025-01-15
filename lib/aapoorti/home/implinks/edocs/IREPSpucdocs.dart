import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
class IREPSpubdocs extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        title: "my APP",
        home: Scaffold(   resizeToAvoidBottomInset: false,
          //resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.white),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   new IconButton(
                alignment: Alignment.centerLeft,
                icon: new Icon(
                  Icons.arrow_back,color: Colors.white
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
                  Container(
                      child: Text('Public Documents', style:TextStyle(
                          color: Colors.white
                      ))),
                  // new Padding(padding: new EdgeInsets.only(right: 40.0)),
                  Expanded(child:Container()),
                  new IconButton(
                    icon: new Icon(
                      Icons.home,color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
                    },
                  ),
                ],
              ),
            backgroundColor: Colors.cyan,),
          backgroundColor: Colors.white,
          body: Material(
              child:  ListView(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      Container(
                        width:370.0,
                        height: 25.0,
                        padding:  EdgeInsets.only(top: 5.0),
                        child: Text("   Auction>>Document List ",style:
                        TextStyle(fontWeight:FontWeight.bold,fontSize: 15,color: Colors.white),
                          textAlign: TextAlign.start,),
                        color: Colors.cyan[700],
                      ),


                      Column(

                        children: <Widget>[
                          GestureDetector(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[
                                    Text("1.   Doc Desc",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Expanded(
                                                                          child: Text("      Guidelines for Encription Certificate",
                                          style: TextStyle(fontSize:15,color: Colors.black)),
                                    ),

                                  ],
                                ),
                                SizedBox(height:5),

                                Row(
                                  children: <Widget>[

                                    Text("       Uploaded",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("      10/02/2015 17:30",
                                        style: TextStyle(fontSize:15,color: Colors.black)),


                                  ],
                                ),
                                SizedBox(height:5),


                                Row(
                                  
                                  children: <Widget>[
                                    Text("       File Size",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("         2682 KB",
                                        style: TextStyle(fontSize:15,color: Colors.black)),
                                    Image.asset('images/pdf_home.png',width: 25,height: 25,),                                ],
                                ),
                                SizedBox(height:5)

                              ],
                            ),
                            onTap: ()
                            {
                              var fileUrl ="https://www.ireps.gov.in/html/misc/DECGuidelines.pdf";
                              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                              AapoortiUtilities.ackAlert(context, fileUrl, fileName);

                            },
                          ),
                          Divider(color: Colors.cyan[600],thickness: 2,indent: 15,endIndent: 15,),
                          // Padding(padding: EdgeInsets.only(top: 10.0)),
                          // Container(
                          //   color: Colors.cyan[600],
                          //   width: 350.0,
                          //   height: 2.0,
                          // ),
                            SizedBox(height:5),
                          GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("2.   Doc Desc",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("      Bidder Registration Form",
                                        style: TextStyle(fontSize:15,color: Colors.black)),

                                  ],
                                ),
                                  SizedBox(height:5),






                                //2nd row

                                Row(
                                  children: <Widget>[

                                    Text("       Uploaded",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("      15/01/2013 18:33",
                                        style: TextStyle(fontSize:15,color: Colors.black)),


                                  ],
                                ),
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[
                                    Text("       File Size",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("          375K KB",
                                        style: TextStyle(fontSize:15,color: Colors.black)),
                                    Image.asset('images/pdf_home.png',width: 25,height: 25,),
                                  ],
                                ),
                                  SizedBox(height:5),
                              ],
                            ),
                            onTap: ()
                            {
                              var fileUrl ="https://www.ireps.gov.in/ireps/upload/files/e17/epsadmin_doc/BiddeRegistrationForm_2.pdf";
                              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                              AapoortiUtilities.ackAlert(context, fileUrl, fileName);


                            },
                          ),
                            Divider(color: Colors.cyan[600],thickness: 2,indent: 15,endIndent: 15,),
                         
                          GestureDetector(
                            child: Column(
                              children: <Widget>[
                                //3rd line
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[
                                    Text("3.   Doc Desc",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("      Vendor Registration Form",
                                        style: TextStyle(fontSize:15,color: Colors.black)),

                                  ],
                                ),
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[

                                    Text("       Uploaded",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("      15/01/2013 18:28",
                                        style: TextStyle(fontSize:15,color: Colors.black)),


                                  ],
                                ),
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[
                                    Text("       File Size",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("         394 KB",
                                        style: TextStyle(fontSize:15,color: Colors.black)),
                                    Image.asset('images/pdf_home.png',width: 25,height: 25,),
                                  ],
                                ),
                                  SizedBox(height:5),
                              ],
                            ),
                            onTap: ()
                            {
                              var fileUrl ="https://www.ireps.gov.in/ireps/upload/files/e17/epsadmin_doc/VendorRegistrationForm_1.pdf";
                              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                              AapoortiUtilities.ackAlert(context, fileUrl, fileName);


                            },
                          ),
                          // Container(
                          //   color: Colors.cyan[600],
                          //   width: 350.0,
                          //   height: 2.0,
                          // ),
                            Divider(color: Colors.cyan[600],thickness: 2,indent: 15,endIndent: 15,),
                          GestureDetector(
                            child: Column(
                              children: <Widget>[
                                //4th line
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[
                                    Text("4.   Doc Desc",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("      User Manual for Reverse auction",
                                        style: TextStyle(fontSize:15,color: Colors.black)),

                                  ],
                                ),
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[

                                    Text("       Uploaded",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("      23/01/2014 15:46",
                                        style: TextStyle(fontSize:15,color: Colors.black)),


                                  ],
                                ),
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[
                                    Text("       File Size",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("         920 KB",
                                        style: TextStyle(fontSize:15,color: Colors.black)),
                                    Image.asset('images/pdf_home.png',width: 25,height: 25,),
                                  ],
                                ),
                                  SizedBox(height:5),
                              ],
                            ),
                            onTap: ()
                            {
                              var fileUrl ="https://www.ireps.gov.in/ireps/upload/files/e17/epsadmin_doc/UsermanualforRAver11.pdf";
                              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                              AapoortiUtilities.ackAlert(context, fileUrl, fileName);

                            },
                          ),
                          // Container(
                          //   color: Colors.cyan[600],
                          //   width: 350.0,
                          //   height: 2.0,
                          // ),
                            Divider(color: Colors.cyan[600],thickness: 2,indent: 15,endIndent: 15,),
                          GestureDetector(
                            child: Column(
                              children: <Widget>[
//5th line
                                    SizedBox(height:5),
                                Row(
                                  children: <Widget>[
                                    Text("5.   Doc Desc",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("      Important Notice for Vendor Users",
                                        style: TextStyle(fontSize:15,color: Colors.black)),

                                  ],
                                ),
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[

                                    Text("       Uploaded",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("      05/02/2014 18:00",
                                        style: TextStyle(fontSize:15,color: Colors.black)),


                                  ],
                                ),
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[
                                    Text("       File Size",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("         540 KB",
                                        style: TextStyle(fontSize:15,color: Colors.black)),
                                    Image.asset('images/pdf_home.png',width: 25,height: 25,),
                                  ],
                                ),
                                  SizedBox(height:5),
                              ],
                            ),
                            onTap: ()
                            {
                              var fileUrl ="https://www.ireps.gov.in/ireps/upload/files/e17/epsadmin_doc/ImportantNoticeforVendorUsers06022014.pdf";
                              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                              AapoortiUtilities.ackAlert(context, fileUrl, fileName);


                            },
                          ),
                          // Container(
                          //   color: Colors.cyan[600],
                          //   width: 350.0,
                          //   height: 2.0,
                          // ),
                            Divider(color: Colors.cyan[600],thickness: 2,indent: 15,endIndent: 15,),
                          GestureDetector(
                            child: Column(
                              children: <Widget>[
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[
                                    Text("6.   Doc Desc",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("      Request Form for Railway Users",
                                        style: TextStyle(fontSize:15,color: Colors.black)),

                                  ],
                                ),
                                Row(
                                  children: <Widget>[

                                    Text("       Uploaded",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("      06/02/2014 18:00",
                                        style: TextStyle(fontSize:15,color: Colors.black)),


                                  ],
                                ),
                                  SizedBox(height:5),
                                Row(
                                  children: <Widget>[
                                    Text("       File Size",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.indigo),),
                                    Text("         540 KB",
                                        style: TextStyle(fontSize:15,color: Colors.black)),
                                    Image.asset('images/pdf_home.png',width: 25,height: 25,),
                                  ],
                                ),
                                  SizedBox(height:5),
                              ],
                            ),
                            onTap: ()
                            {
                              var fileUrl ="https://www.ireps.gov.in/ireps/upload/resources/REQUESTFORM.pdf";
                              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                              AapoortiUtilities.ackAlert(context, fileUrl, fileName);


                            },
                          )
                        ],
                      )


                    ],

                  ),
                ],
              )



          ),

        )
    )
    ;
  }


}