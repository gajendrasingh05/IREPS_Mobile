import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EdocsGSdata extends StatefulWidget {
  final String? item1, item2, item3;
  EdocsGSdata({this.item1, this.item2, this.item3});

  @override
  EdocsGSdataState createState() =>
      EdocsGSdataState(this.item1!, this.item2!, this.item3!);
}

class EdocsGSdataState extends State<EdocsGSdata> {
  String? item1, item2, item3;
  BuildContext? context1;
  List data = [];
  List<dynamic>? jsonResult;
  EdocsGSdataState(
    String item1,
    String item2,
    String item3,
  ) {
    this.item1 = item1;
    this.item2 = item2;
    this.item3 = item3;
  }
  void initState() {
    super.initState();
    // jsonResult=null;
    Future.delayed(Duration.zero, () {
      fetchPostOrganisation();
      // context1=context;
    });
  }

  Future<void> fetchPostOrganisation() async {
    print('Fetching from service first spinner');
    var u = AapoortiConstants.webServiceUrl +
        'Docs/PublicDocs?ORGCODE=${this.item1}&ORGZONE=${this.item2}&DEPTCODE=${this.item3}';
    print("ur1-----" + u);
    //  var u=AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,${myselection1}';

    final response1 = await http.post(Uri.parse(u));
    //  final response1 =   await http.post(u);
    // jsonResult = json.decode(response1.body);
    // jsonResult1 = json.decode(response1.body);
    print("jsonresult1===");
    print(jsonResult);
//    print("jsonresult1===");
//    print(jsonResult1);

    setState(() {
      //  data = jsonResult;
      jsonResult = json.decode(response1.body);
      data = jsonResult!;
      print("jsonresult1===");
      print(jsonResult);
//data1=jsonResult1;
    });
  }

  var _snackKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: true,
        appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.white),
            backgroundColor: Colors.cyan[400],
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text('Public Documents',
                        style: TextStyle(color: Colors.white))),
                // new Padding(padding: new EdgeInsets.only(right: 40.0)),
                new IconButton(
                  icon: new Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/common_screen", (route) => false);
                  },
                ),
              ],
            )),
        /* MaterialApp(
        debugShowCheckedModeBanner: false,

        title: "About Us",*/

        //  backgroundColor: Colors.cyan[400],
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 370.0,
                height: 25.0,
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  "   Goods and Services >> Document List",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  textAlign: TextAlign.start,
                ),
                color: Colors.cyan[700],
              ),

              // Expanded(
              // child:
              // new Row(
              // children: <Widget>[
              //   new
              Expanded(
                  child: jsonResult == null
                      ? SpinKitFadingCircle(
                          color: Colors.cyan,
                          size: 40.0,
                        )
                      : _myListView(context))

              // ],
              // ),
              //
            ],
          ),
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    print("jsonresult");

    return jsonResult!.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset("assets/nodatafound.png"),
              Text(
                ' No Response Found ',
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              )
            ],
          )
        : ListView.builder(
            // scrollDirection: Axis.vertical,
            shrinkWrap: true,

            itemCount: jsonResult != null ? jsonResult!.length : 0,

            itemBuilder: (context, index) {
              return InkWell(
                child: Container(
                    child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            (index + 1).toString() + ". ",
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 16),
                          ),
                          Container(
                            height: 30,
                            width: 100,
                            child: Text(
                              "Doc Desc",
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            //height: 30,

                            child: Text(
                              jsonResult![index]['FILE_DESCRIPTION'] != null
                                  ? jsonResult![index]['FILE_DESCRIPTION']
                                  : "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ]),
                    Row(children: <Widget>[
                      Container(
                        height: 30,
                        width: 117,
                        child: Text(
                          "     Doc Type",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['DOC_TYPE'] != null
                              ? jsonResult![index]['DOC_TYPE']
                              : "",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ]),

                    Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Container(
                        height: 30,
                        width: 117,
                        child: Text(
                          "     Uploaded",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: Text(
                            jsonResult![index]['UPLOAD_TIME'] != null
                                ? (jsonResult![index]['UPLOAD_TIME'].toString())
                                : "",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ]),

                    Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                      Container(
                        height: 30,
                        width: 117,
                        child: Text(
                          "     File Details",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),

                      /*Expanded(
                          child:*/
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['FILE_SIZE'] != null
                              ? (jsonResult![index]['FILE_SIZE'].toString() +
                                  "Kb/V1")
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),

                      //),
                    ]),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),
                    Row(children: <Widget>[
                      Container(
                        height: 30,
                        width: 125,
                        child: Text(
                          "     PDF",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (jsonResult![index]['FILE_NAME'] != 'NA') {
                                    String url = jsonResult![index]['FILE_NAME'];
                                    url = 'https://ireps.gov.in' + url;
                                    print(url);
                                    var fileName =
                                        url.substring(url.lastIndexOf("/"));
                                    AapoortiUtilities.ackAlert(
                                        context, url, fileName);

                                    //Dismiss dialog
                                    //  Navigator.of(context, rootNavigator: true).pop('dialog');
                                  } else {
                                    AapoortiUtilities.showInSnackBar(context,
                                        "No PDF attached with this Tender!!");
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  child: Image(
                                      image: AssetImage('images/pdf_home.png'),
                                      height: 30,
                                      width: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 0),
                              ),
                            ]),
                      ),
                    ]),
                    //new Padding(padding: EdgeInsets.only(left: 150)),

                    /*  Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 117,
                          child: Text("     PDF:",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),

                        Expanded(
                          child:
                              InkWell(
                                onTap: (){
                                  print('tapping the value');
                                  String url=jsonResult[index]['FILE_NAME'];
                                  url='https://ireps.gov.in'+url;
                                  print(url);
                                  var fileName = url.substring(url.lastIndexOf("/"));
                                  AapoortiUtilities.ackAlert(context, url, fileName);
                                },
                                child: Image(
                                    image: AssetImage('images/pdf_home.png'),
                                    height: 30,
                                    width: 20
                                ),

                              )


                        ),

                      ]
                  ),*/
                    Container(
                      color: Colors.cyan[600],
                      height: 2.0,
                    )
                  ],
                )),
                onTap: () {
//            print('tapping the value');
//              String url=jsonResult[index]['FILE_NAME'];
//              url='https:/'+url;
//              print(url);
//              var fileName = url.substring(url.lastIndexOf("/"));
//              AapoortiUtilities.ackAlert(context, url, fileName);
                },
              );
            },
          );
  }
}
