import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/home_screen.dart' as prefix0;

import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
/*import 'home_screen.dart';*/

List<dynamic>? jsonResult;

class SearchPoZonalDetails extends StatefulWidget {
  final int? pokey;
  SearchPoZonalDetails({this.pokey});
  @override
  SearchPoZonalDetailsState createState() =>
      SearchPoZonalDetailsState(this.pokey!);
}

class SearchPoZonalDetailsState extends State<SearchPoZonalDetails> {
  List<dynamic>? jsonResult;
  int? pokey;

  SearchPoZonalDetailsState(int pokey) {
    this.pokey = pokey;
  }

  void initState() {
    super.initState();
    this.fetchPost();
  }

  List data = [];

  Future<void> fetchPost() async {


    var v = AapoortiConstants.webServiceUrl + 'Tender/PODesc?param=${this.pokey}';

    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);

    setState(() {
      data = jsonResult!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Search PO Details',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          //resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.cyan[400],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                Text('Purchase Order Search',
                    style: TextStyle(color: Colors.white)),
                // Padding(padding: EdgeInsets.only(left: 30)),
                IconButton(
                  icon: new Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/common_screen", (route) => false);
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>prefix0.HomeScreen(scaffoldKey)));
                  },
                ),
              ],
            ),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: 400,
                  height: 30,
                  color: Colors.cyan.shade50,
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'List of Purchase Order Details',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: jsonResult == null
                        ? SpinKitFadingCircle(
                            color: Colors.cyan,
                            size: 120.0,
                          )
                        : _PoDetailsListView(context))
              ],
            ),
          ),
        ));
  }

  Widget _PoDetailsListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return ListView.separated(
        itemCount: jsonResult == null ? 0 : jsonResult!.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          "PO SI             ",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        child: Text(
                          data[index]['SR'] != null ? data[index]['SR'] : "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        flex: 6,
                      )
                    ]),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          "Supplier Name",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                        flex: 4,
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          data[index]['SUPPNM'] != null
                              ? data[index]['SUPPNM']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        flex: 6,
                      )
                    ]),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          "Item Description",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                        flex: 4,
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                          //Item Description
                          child: Text(
                        data[index]['DESC1'] != null
                            ? data[index]['DESC1']
                            : "",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ))
                    ]),
                    Divider(
                      color: Colors.grey,
                    ),
                    /*Padding(
                                    padding: EdgeInsets.all(5),
                                  ),

                                  Row(children: <Widget>[
                                    Expanded(
                                        child: Text(
                                          data[index]['LOC'] != null
                                              ? data[index]['LOC']
                                              : "",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ))
                                  ]),
                                  Divider(color: Colors.grey

                                    ,),*/
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          "Consignee",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        child: Text(
                          data[index]['CNSIGNEE'] != null
                              ? data[index]['CNSIGNEE']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        flex: 6,
                      )
                    ]),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          "PO Value",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        child: Text(
                          data[index]['PO_VALUE'] != null
                              ? data[index]['PO_VALUE'].toString()
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        flex: 6,
                      )
                    ]),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          "PO Qty/ Unit",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        child: Text(
                          data[index]['QTY'] != null
                              ? data[index]['QTY'].toString()
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        flex: 6,
                      )
                    ]),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          "T.U.R",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        child: Text(
                          data[index]['TUR'] != null
                              ? data[index]['TUR'].toString().trim()
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        flex: 6,
                      )
                    ]),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          "Dely Date",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        child: Text(
                          data[index]['DELAYDT'] != null
                              ? data[index]['DELAYDT']
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        flex: 6,
                      )
                    ]),
                  ]))
            ]),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 2.0,
            color: Colors.cyan[400],
          );
        });
  }
}
