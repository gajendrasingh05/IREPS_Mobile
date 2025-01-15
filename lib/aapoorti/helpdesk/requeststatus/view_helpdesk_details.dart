import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/home/home_screen.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

List<dynamic>? jsonResult;
List<dynamic>? uid_date_sep;

class Details extends StatefulWidget {
  final String? queryid, mailid;
  Details({this.queryid, this.mailid});

  @override
  DetailsState createState() => DetailsState(this.queryid!, this.mailid!);
}

class DetailsState extends State<Details> {
  String? queryid, mailid;
  String uid = "";
  String date = "";
  String uid_date = "";

  DetailsState(String queryid, String mailid) {
    this.queryid = queryid;
    this.mailid = mailid;
  }
  void initState() {
    super.initState();
    this.fetchPost();
  }

  List data = [];
  Future<void> fetchPost() async {
    var v = AapoortiConstants.webServiceUrl +
        'HD/viewReply?QUERYID=${this.queryid}&EMAILID=${this.mailid}';
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);
    uid_date = jsonResult![0]['UID_DATE'];
    uid_date_sep = uid_date.split(" ");
    for (int i = 0; i < uid_date_sep!.length; i++) {
      debugPrint(uid_date_sep![i]);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.cyan[400],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Query Search Result', style: TextStyle(color: Colors.white)),
            // Padding(padding: EdgeInsets;.only(left: 10)),
            Expanded(child: SizedBox(width: 5)),
            IconButton(
              alignment: Alignment.centerLeft,
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/common_screen", (route) => false,
                    arguments: [2, '']);
                // Navigator.push(context, MaterialPageRoute(
                //     builder: (context) => HomeScreen(scaffoldKey)));
              },
            ),
          ],
        ),
      ),
      body: Container(
          child: jsonResult == null
              ? SpinKitFadingCircle(
                  color: Colors.cyan,
                  size: 120.0,
                )
              : _myListView(context),
          color: Colors.blue[50]),
    );
  }
}

Widget _myListView(BuildContext context) {
  //Dismiss spinner
  SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
  return ListView.separated(
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        print(index);
        if (jsonResult![index]['UID_DATE'] == null ||
            jsonResult![index]['NAME'] == null ||
            jsonResult![index]['EMAIL'] == null ||
            jsonResult![index]['MOBILE'] == null ||
            jsonResult![index]['DESCRIPTION'] == null ||
            jsonResult![index]['COMMENT_REPLY'] == null) {
          return Card(
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/no_data.png',
                  width: 500,
                  height: 500,
                ),
                Text(
                  "Sorry no data found!!!!! ",
                  style: TextStyle(fontSize: 17),
                )
              ],
            ),
            color: Colors.white,
          );
        } else {
          return Container(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                  top: 15.0,
                )),
                Card(
                  child: Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 60.0)),
                        Text(
                            "                                         " +
                                uid_date_sep![0],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      Container(
                        color: Colors.grey,
                        height: 2.0,
                      ),
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      Row(children: <Widget>[
                        Icon(Icons.date_range),
                        Text("    "),
                        Container(
                          height: 30,
                          child: Text(uid_date_sep![1]),
                        )
                      ]),
                      Row(children: <Widget>[
                        Icon(Icons.person),
                        Text("    "),
                        Container(
                          height: 30,
                          child: Text(
                            jsonResult![index]['NAME'] != null
                                ? jsonResult![index]['NAME']
                                : "",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        )
                      ]),
                      Row(children: <Widget>[
                        Icon(Icons.email),
                        Text("    "),
                        Container(
                          height: 30,
                          child: Text(
                            jsonResult![index]['EMAIL'] != null
                                ? jsonResult![index]['EMAIL']
                                : "",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        )
                      ]),
                      Row(children: <Widget>[
                        Icon(Icons.phone_in_talk),
                        Text("    "),
                        Container(
                          height: 30,
                          child: Text(
                            jsonResult![index]['MOBILE'] != null
                                ? jsonResult![index]['MOBILE']
                                : "",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        )
                      ]),
                      Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                        Icon(Icons.description),
                        Text("    "),
                        Expanded(
                          child: Container(
                            height: 30,
                            child: Text(
                              jsonResult![index]['DESCRIPTION'] != null
                                  ? jsonResult![index]['DESCRIPTION']
                                  : "",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                Card(
                    child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Padding(padding: new EdgeInsets.only(top: 60.0)),
                      Text("        "),
                      Container(
                        height: 30,
                        child: Text(
                          jsonResult![index]['COMMENT_REPLY'] != "NA"
                              ? jsonResult![index]['COMMENT_REPLY']
                              : "                 Presently there is no reply",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      )
                    ]),
                  ],
                ))
              ],
            ),
          );
        }
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.blue);
      });
}
