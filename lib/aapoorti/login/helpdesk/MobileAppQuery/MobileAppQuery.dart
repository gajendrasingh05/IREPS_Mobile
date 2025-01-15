//---------------------MOBILE APP QUERIES CODE- MADHVI----------------------------------------------------//
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/login/helpdesk/MobileAppQuery/MobileAppQueryDetails.dart';

class MobileAppQuery extends StatefulWidget {
  get path => null;

  @override
  _MobileAppQueryState createState() => _MobileAppQueryState();
}

class _MobileAppQueryState extends State<MobileAppQuery> {
  int _buttonFilter = 1;
  int _filter = 1;
  int nr = 0, j = 0, i = 0, l = 0, k = 0;
  var uid_array, qid, qdate, qtime;
  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;

  String? status;

  void initState() {
    super.initState();
    fetchPost();
  }

  void _csfilter(int value) {
    setState(() {
      _buttonFilter = value;
      switch (_buttonFilter) {
        case 1:
          _filter = 1;
          break;
        case 2:
          _filter = 2;
          break;
        case 3:
          _filter = 3;
          break;
      }
      print(_filter);
    });
  }

  void fetchPost() async {
    print('Fetching from service');
    String param1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    String param2 = AapoortiUtilities.user!.MAP_ID;

    //JSON VALUES FOR POST PARAM
    Map<String, dynamic> urlinput = {"param1": "$param1", "param2": "$param2"};
    String urlInputString = json.encode(urlinput);
    print("url_list =" + urlinput.toString());

    //NAME FOR POST PARAM
    String paramName = 'GetAllQuery';

    //Form Body For URL
    String formBody =
        paramName + '=' + Uri.encodeQueryComponent(urlInputString);

    var url = AapoortiConstants.webServiceUrl + 'Log/GetAllQuery';
    print("url = " + url);

    final response = await http.post(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: formBody,
        encoding: Encoding.getByName("utf-8"));

    jsonResult = json.decode(response.body);
    print("response_size =" + jsonResult!.length.toString());
    print("form body = " + json.encode(formBody).toString());
    print("json result = " + jsonResult.toString());
    print("response code = " + response.statusCode.toString());
    setState(() {
      for (int index = 0; index < jsonResult!.length; index++) {
        print("status" + jsonResult![index]['STATUS'].toString() == "2");
        status = jsonResult![index]['STATUS'].toString();
        if (status == "0") {
          print("success " + status!);
          nr++;
          j++;
          i++;
        } else if (jsonResult![index]['STATUS'].toString() == "1") {
          k++;
        } else if (jsonResult![index]['STATUS'].toString() == "2") {
          l++;
        }
      }
      print(j);
      print(k);
      print(l);
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    // Navigate to UserHome and replace the current route
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserHome('', '')),
    );

    // Return true to indicate that the pop action is allowed
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.teal,
              title: Text(
                "Mobile App Queries",
                style: TextStyle(color: Colors.white),
              )),
          backgroundColor: Colors.grey[200],
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                    width: 400,
                    height: 60,
                    color: Colors.grey[200],
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: new EdgeInsets.only(right: 5)),
                        MaterialButton(
                          onPressed: () {
                            _csfilter(1);
                          },
                          textColor:
                              (_filter == 1) ? Colors.white : Colors.black,
                          color: (_filter == 1) ? Colors.black : Colors.white,
                          child: Text(
                            " Not Replied ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(2.0),
                          ),
                        ),
                        Padding(
                            padding: new EdgeInsets.only(left: 10, right: 15)),
                        MaterialButton(
                          onPressed: () {
                            _csfilter(2);
                          },
                          textColor:
                              (_filter == 2) ? Colors.white : Colors.blue[900],
                          color:
                              (_filter == 2) ? Colors.blue[900] : Colors.white,
                          child: Text(
                            " Replied ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(2.0),
                          ),
                        ),
                        Padding(
                            padding: new EdgeInsets.only(left: 10, right: 15)),
                        MaterialButton(
                          onPressed: () {
                            _csfilter(3);
                          },
                          textColor:
                              (_filter == 3) ? Colors.white : Colors.red[700],
                          color:
                              (_filter == 3) ? Colors.red[700] : Colors.white,
                          child: Text(
                            " Spam ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(2.0),
                          ),
                        ),
                      ],
                    )),
                _filter == 1
                    ? Expanded(
                        child: jsonResult == null
                            ? SpinKitFadingCircle(
                                color: Colors.cyan,
                                size: 120.0,
                              )
                            : _myListView(context))
                    : (_filter == 2
                        ? Expanded(child: _myListView(context))
                        : Expanded(child: _myListView(context))),
              ],
            ),
          ),
        ));
    // );
  }

  Widget _myListView(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: jsonResult != null
            ? ((_filter == 1) ? nr : ((_filter == 2) ? k : l))
            : 0,
        itemBuilder: (context, index) {
          i = ((_filter == 1)
              ? index
              : ((_filter == 2) ? index + nr : index + nr + k));

          //String category=jsonResult[i]['CATEGORY'].toString();
          // print("CATEGORY---" + category);
          String desc = jsonResult![i]['DESCRIPTION'].toString();
          print("DESC--- " + desc);
          String reply = jsonResult![i]['COMMENT_REPLY'].toString();
          print("REPLY--- " + reply);
          print("STATUS---" + jsonResult![i]['STATUS'].toString());
          print("index =" + i.toString());
          print("STAt---" + jsonResult![index]['UID_DATE'].toString());
          print("index =" + index.toString());
          /*uid_array=jsonResult[i]['UID_DATE'].split(" ");
        qid=uid_array[0];
        qdate=uid_array[2];
        qtime=uid_array[3];*/
          return /*GestureDetector(
                child:*/
              Container(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      print("calling function");
                      if (_filter == 1) {
                        uid_array = jsonResult![index]['UID_DATE'].split(" ");
                        qid = uid_array[0];
                        qdate = uid_array[2];
                        qtime = uid_array[3];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MobileAppQueryDetails(
                                  qid,
                                  qdate,
                                  qtime,
                                  jsonResult![index]['NAME'],
                                  jsonResult![index]['EMAIL'],
                                  jsonResult![index]['MOBILE'],
                                  jsonResult![index]['CATEGORY_NAME'],
                                  jsonResult![index]['DESCRIPTION'],
                                  jsonResult![index]['STATUS'].toString(),
                                  jsonResult![index]['COMMENT_REPLY'])),
                        );
                      }
                      if (_filter == 2) {
                        uid_array =
                            jsonResult![index + nr]['UID_DATE'].split(" ");
                        qid = uid_array[0];
                        qdate = uid_array[2];
                        qtime = uid_array[3];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MobileAppQueryDetails(
                                  qid,
                                  qdate,
                                  qtime,
                                  jsonResult![index + nr]['NAME'],
                                  jsonResult![index + nr]['EMAIL'],
                                  jsonResult![index + nr]['MOBILE'],
                                  jsonResult![index + nr]['CATEGORY_NAME'],
                                  jsonResult![index + nr]['DESCRIPTION'],
                                  jsonResult![index + nr]['STATUS'].toString(),
                                  jsonResult![index + nr]['COMMENT_REPLY'])),
                        );
                      }
                      if (_filter == 3) {
                        uid_array =
                            jsonResult![index + nr + k]['UID_DATE'].split(" ");
                        qid = uid_array[0];
                        qdate = uid_array[2];
                        qtime = uid_array[3];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MobileAppQueryDetails(
                                  //jsonResult[index+nr+k]['UID_DATE'],
                                  qid,
                                  qdate,
                                  qtime,
                                  jsonResult![index + nr + k]['NAME'],
                                  jsonResult![index + nr + k]['EMAIL'],
                                  jsonResult![index + nr + k]['MOBILE'],
                                  jsonResult![index + nr + k]['CATEGORY_NAME'],
                                  jsonResult![index + nr + k]['DESCRIPTION'],
                                  jsonResult![index + nr + k]['STATUS']
                                      .toString(),
                                  jsonResult![index + nr + k]['COMMENT_REPLY'])),
                        );
                      }
                    },
                    child: /* Column(

                              children: <Widget>[*/
                        //return
                        Card(
                      elevation: 2,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              (index + 1).toString() + ". ",
                              style:
                                  TextStyle(color: Colors.teal, fontSize: 15),
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Container(
                                        height: 25,
                                        width: 115,
                                        child: Text(
                                          "Query ID/ Date",
                                          style: TextStyle(
                                              color: Colors.teal, fontSize: 15),
                                        ),
                                      ),
                                      Container(
                                        height: 25,
                                        child: Text(
                                          jsonResult![i]['UID_DATE'] != null
                                              ? jsonResult![i]['UID_DATE']
                                              : "",
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 15),
                                        ),
                                      )
                                    ]),
                                    Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Container(
                                            height: 25,
                                            width: 115,
                                            child: Text(
                                              "Name",
                                              style: TextStyle(
                                                  color: Colors.teal,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 25,
                                              child: Text(
                                                jsonResult![i]['NAME'] != null
                                                    ? jsonResult![i]['NAME']
                                                    : "",
                                                style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ]),
                                    Row(children: <Widget>[
                                      Container(
                                        height: 25,
                                        width: 115,
                                        child: Text(
                                          "E-mail",
                                          style: TextStyle(
                                              color: Colors.teal, fontSize: 15),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 25,
                                          child: Text(
                                            jsonResult![i]['EMAIL'] != null
                                                ? jsonResult![i]['EMAIL']
                                                : "",
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 15),
                                          ),
                                        ),
                                      )
                                    ]),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            height: 25,
                                            width: 115,
                                            child: Text(
                                              "Mobile No.",
                                              style: TextStyle(
                                                  color: Colors.teal,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          Container(
                                            height: 25,
                                            child: Text(
                                              jsonResult![i]['MOBILE'] != null
                                                  ? jsonResult![i]['MOBILE']
                                                  : "",
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 15),
                                            ),
                                          )
                                        ]),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            height: 25,
                                            width: 115,
                                            child: Text(
                                              "Category",
                                              style: TextStyle(
                                                  color: Colors.teal,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          Container(
                                            height: 25,
                                            child: Text(
                                              jsonResult![i]['CATEGORY_NAME'] !=
                                                      null
                                                  ? jsonResult![i]
                                                      ['CATEGORY_NAME']
                                                  : "",
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 15),
                                            ),
                                          )
                                        ]),
                                    Row(children: <Widget>[
                                      Container(
                                        height: 25,
                                        width: 115,
                                        child: Text(
                                          "Status",
                                          style: TextStyle(
                                              color: Colors.teal, fontSize: 15),
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        height: 25,
                                        child: Text(
                                          ((_filter == 1)
                                              ? 'Not Replied'
                                              : ((_filter == 2)
                                                  ? 'Replied'
                                                  : 'Spam')),
                                          style: TextStyle(
                                              color: (_filter == 1)
                                                  ? Colors.black
                                                  : ((_filter == 2)
                                                      ? Colors.blue[900]
                                                      : Colors.red[900]),
                                              fontSize: 15,
                                              fontWeight: (_filter == 1)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                      )),
                                    ]),
                                  ]),
                            ),
                          ]),
                      //  ]
                    ),

                    /* :SizedBox(
                                  height: 0.1,
                                )
                              ]*/
                  ));
          // );
          //);
        }
        /*separatorBuilder: (context, index) {
                return Divider(color:Colors.teal[600],thickness: 1.5,);
              }*/
        );
  }
}
//---------------------MOBILE APP QUERIES CODE ENDS----------------------------------------------------//