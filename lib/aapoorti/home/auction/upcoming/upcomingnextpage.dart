import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/home/auction/upcoming/upcomingthirdpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/home/auction/upcoming/Upcoming.dart';

class Userup1 {
  final String? lotid, des;

  const Userup1({this.lotid, this.des});
}

class upcoming2 extends StatefulWidget {
  final Userup? value1;

  upcoming2({Key? key, this.value1}) : super(key: key);

  @override
  _upcoming2State createState() => _upcoming2State();
}

class _upcoming2State extends State<upcoming2> {
  List<dynamic>? jsonResult;

  void initState() {
    super.initState();

    var fetchPost = this.fetchPost();
  }

  List data = [];
  Future<void> fetchPost() async {
    var url = AapoortiConstants.webServiceUrl +
        'Auction/CatalogueDesc?CID=${widget.value1!.upid}&CATEGORY=${widget.value1!.category}';
    final response = await http.post(Uri.parse(url));
    jsonResult = json.decode(response.body);

    setState(() {
      data = jsonResult!;
    });
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
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.cyan[400],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text('Upcoming Auctions(Sale)',
                        style: TextStyle(color: Colors.white))),
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/common_screen", (route) => false);
                    // Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            )),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 30,
                color: Colors.cyan.shade600,
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '   Auction Catalogue',
                  style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.cyan.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                  child: jsonResult == null
                      ? SpinKitFadingCircle(
                          color: Colors.cyan,
                          size: 120.0,
                        )
                      : _myListView(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return ListView.separated(
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        return GestureDetector(
            child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(width: 1, color: Colors.grey[300]!),
                ),
                child: Column(children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 6)),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Padding(padding: EdgeInsets.only(left: 8)),
                            Text(
                              (index + 1).toString() + ". ",
                              style:
                                  TextStyle(color: Colors.indigo, fontSize: 16),
                            ),
                          ],
                        ),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Row(children: <Widget>[
                                Container(
                                  height: 30,
                                  child: Text(
                                    "Lot No.:  ",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  child: Text(
                                    jsonResult![index]['LOTNO'] != null
                                        ? jsonResult![index]['LOTNO']
                                        : "",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ]),
                              Row(children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    child: Text(
                                      "Status:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  flex: 4,
                                ),
                                Expanded(
                                  child: Container(
                                      child: Text(
                                    jsonResult![index]['LOT_STATUS'] != null
                                        ? jsonResult![index]['LOT_STATUS']
                                        : "",
                                    style: TextStyle(
                                        color: Colors.blue.shade800,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  flex: 6,
                                )
                              ]),

                              Row(children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    child: Text(
                                      'Lot Start:',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  flex: 4,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult![index]['LOT_START_DATETIME'] !=
                                              null
                                          ? jsonResult![index]
                                                  ['LOT_START_DATETIME'] +
                                              "-"
                                          : "",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 16),
                                    ),
                                  ),
                                  flex: 6,
                                ),
                              ]),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 30,
                                      child: Text(
                                        'Lot End:',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                    flex: 4,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 30,
                                      child: Text(
                                        jsonResult![index]['LOT_END_DATETIME'] !=
                                                null
                                            ? jsonResult![index]
                                                ['LOT_END_DATETIME']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 16),
                                      ),
                                    ),
                                    flex: 6,
                                  ),
                                ],
                              ),

                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    child: Text(
                                      "Quantity: ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),

                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult![index]['LOT_QTY'] != null
                                          ? jsonResult![index]['LOT_QTY']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      "                 ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),

                                  Container(
                                    height: 30,
                                    child: Text(
                                      "Min Inc.(Rs.): ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult![index]['MIN_INCR_AMT'] != null
                                          ? jsonResult![index]['MIN_INCR_AMT']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              Column(children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Description",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(3),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      jsonResult![index]['LOTMATDESC'] != null
                                          ? jsonResult![index]['LOTMATDESC']
                                          : "",
                                      textAlign: TextAlign.justify,
                                      maxLines: 3,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    )),
                                  ],
                                ),
                              ]),
                            ]))
                      ])
                ])),
            onTap: () {
              if (jsonResult![index]['LOTMATDESC'] != 'NA') {
                Container(
                    child: Center(
                        child: Container(
                            child: Column(children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 0),
                      child: livelotid(
                        context,
                        jsonResult![index]['LOTMATDESC'],
                        jsonResult![index]['LOTID'].toString(),
                      ),
                    ),
                  ),
                ]))));
              }
            });
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 10,
        );
      },
    );
  }

  Widget livelotid(BuildContext context, String Description, String livelotid) {
    var lotid = livelotid;
    var des = Description;

    var route = MaterialPageRoute(
      builder: (BuildContext context) => upcoming3(
          value3: Userup1(
        lotid: lotid,
        des: des,
      )),
    );
    Navigator.of(context).push(route);
    return Container();
  }

}
