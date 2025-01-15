import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/home/auction/upcoming/upcomingnextpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class upcoming3 extends StatefulWidget {
  final Userup1? value3;
//  final   String livecatid, liveArray;
//  live2({this.livecatid,this.liveArray});
  upcoming3({Key? key, this.value3}) : super(key: key);
  @override
  _upcoming3State createState() => _upcoming3State();
}

class _upcoming3State extends State<upcoming3> {
  List<dynamic>? jsonResult;

  void initState() {
    super.initState();
    fetchPost();
  }

  void fetchPost() async {
    var v = AapoortiConstants.webServiceUrl +
        'Auction/LotDesc?LOTID=${widget.value3!.lotid}';
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);

    setState(() {});
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
                  '   Auction Catalogue>> Lot Details',
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
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Text(
                            (jsonResult![index]['ACCNM'] != null &&
                                    jsonResult![index]['DEPTNM'] != null)
                                ? (jsonResult![index]['ACCNM'] +
                                    "/" +
                                    jsonResult![index]['DEPTNM'])
                                : "",
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          //<widget>
                        ),
                      )
                    ]),
                    Divider(
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Container(
                        child: Text(
                          "Lot Number                ",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          jsonResult![index]['LOTNO'] != null
                              ? jsonResult![index]['LOTNO']
                              : "",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ]),
                    Divider(
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Container(
                        child: Text(
                          "Category/Part             ",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          jsonResult![index]['CATNM'] != null
                              ? jsonResult![index]['CATNM']
                              : "",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    ]),
                    Divider(
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Container(
                        child: Text(
                          "PL Number                  ",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          jsonResult![index]['PLN'] != null
                              ? jsonResult![index]['PLN']
                              : "",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    ]),
                    Divider(
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Description",
                              style:
                                  TextStyle(color: Colors.indigo, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              jsonResult![index]['LOTMATDESC'] != null
                                  ? jsonResult![index]['LOTMATDESC']
                                  : "",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ],
                      )
                    ]),
                    Divider(
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Special Condition",
                              style:
                                  TextStyle(color: Colors.indigo, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              jsonResult![index]['SPCLCOND'] != null
                                  ? jsonResult![index]['SPCLCOND']
                                  : "",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ],
                      )
                    ]),
                    Divider(
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Container(
                        child: Text(
                          "Custodian                   ",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          jsonResult![index]['CUST'] != null
                              ? jsonResult![index]['CUST']
                              : "",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    ]),
                    Divider(
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Container(
                        child: Text(
                          "Location                      ",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          jsonResult![index]['LOC'] != null
                              ? jsonResult![index]['LOC']
                              : "",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    ]),
                    Divider(
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Container(
                        child: Text(
                          "GST                               ",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          jsonResult![index]['GST'] != null
                              ? jsonResult![index]['GST'].toString() + "%"
                              : "",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    ]),
                    Divider(
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Container(
                        child: Text(
                          "Excluded items           ",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          jsonResult![index]['EXCLDITMS'] != null
                              ? jsonResult![index]['EXCLDITMS']
                              : "",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    ]),
                    Divider(
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(children: <Widget>[
                      Container(
                        child: Text(
                          "Approx Lot Qty            ",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          jsonResult![index]['LOTQTY'] != null
                              ? jsonResult![index]['LOTQTY'].toString()
                              : "",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    ]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
