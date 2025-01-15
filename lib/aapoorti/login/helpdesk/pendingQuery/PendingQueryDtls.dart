import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'PendingQuery.dart';

class PendingQueryDtls extends StatefulWidget {
  get path => null;
  String queryid,
      email,
      phno,
      desg,
      usertype,
      workarea,
      name,
      seqid,
      queryrowid;
  bool replied;

  PendingQueryDtls(
      this.queryid,
      this.email,
      this.phno,
      this.usertype,
      this.workarea,
      this.desg,
      this.name,
      this.seqid,
      this.queryrowid,
      this.replied);

  @override
  _PendingQueryDtlsState createState() => _PendingQueryDtlsState(queryid, email,
      phno, usertype, workarea, desg, name, seqid, queryrowid, replied);

//  PaymentDtls(String tenderno,String deptrlw,String closingdate,String tendertype,String tenderoid)
//  {
//    this.tenderno=tenderno;
//    this.tendertype=tendertype;
//    this.deptrlw=deptrlw;
//    this.closingdate=closingdate;
//    this.tenderoid=tenderoid;
//  }
}

class _PendingQueryDtlsState extends State<PendingQueryDtls> {
  String? quid, email, phno, desg, usertype, workarea, name, seqid, queryrowid;
  String? _query;
  bool? replied;
  double? maxscroll;
  _PendingQueryDtlsState(
      this.quid,
      this.email,
      this.phno,
      this.desg,
      this.usertype,
      this.workarea,
      this.name,
      this.seqid,
      this.queryrowid,
      this.replied);
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List<dynamic>? jsonResult, jsonResult2, jsonResult3;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;
  var scrollvalue;
  Color _backgroundColor = Colors.white;
  ScrollController? _scrollController;
  bool replytohelp = false, forwardtoexp = false;
  bool querysubmitted = false;
  String? _myselection;
  static double containerheight = 200;
  TextEditingController? controller;
  List dataOrganisation = [];
  void initState() {
    super.initState();
    containerheight = 200;
    if (name == null) {
      name = "Anonymous User";
    }
    if (desg == null) {
      desg = "Not Define";
    }
    if (workarea == null) {
      workarea = "No WorkArea";
    }
    controller = TextEditingController();
    _scrollController = ScrollController();
    _scrollController!.addListener(changeheight);
    replytohelp = false;
    forwardtoexp = false;

    callWebService();
    spinnerCall();
  }

  void changeheight() {
    scrollvalue = _scrollController!.offset.round();
    maxscroll = _scrollController!.position.maxScrollExtent;
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "~" + quid!;
    print(inputParam2);
    jsonResult = await AapoortiUtilities.fetchPostPostLogin(
        'HDPostLogin/QueryDetails', 'input', inputParam1, inputParam2);
    if (jsonResult!.length == 0) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoResponse()));
    }
    setState(() {});
  }

  void submitreply() async {
    String ipaddress = "56.92.185.68";
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID +
        "~" +
        "$queryrowid^$seqid^$_query^$ipaddress";
    jsonResult2 = await AapoortiUtilities.fetchPostPostLogin(
        'HDPostLogin/ReplyToHDByExpert', 'input', inputParam1, inputParam2);
    setState(() {
      replytohelp = false;
      forwardtoexp = false;
      querysubmitted = true;
    });
  }

  void submitforward() async {
    String ipaddress = "56.92.185.68";
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID +
        "~" +
        "$_myselection^$queryrowid^$_query^$ipaddress";
    print(inputParam2);
    jsonResult3 = await AapoortiUtilities.fetchPostPostLogin(
        'HDPostLogin/FwrdToExpertByExpert', 'input', inputParam1, inputParam2);
    setState(() {
      replytohelp = false;
      forwardtoexp = false;
      querysubmitted = true;
    });
  }

  void validateAndLogin() async {
    var res;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (replytohelp == true) {
        submitreply();
      } else if (forwardtoexp == true) {
        if (_myselection == null) {
          ScaffoldMessenger.of(context).showSnackBar(snackbar1);
        } else
          submitforward();
      }
    }
  }

  void spinnerCall() async {
    List<String> inputArray = new List.empty();
    inputArray[0] = "SPINNERS";
    inputArray[1] = "EXPERT_LIST_HD";
    inputArray[2] = "";
    inputArray[3] = "";
    inputArray[4] = "";
    inputArray[5] = "";
    var url = AapoortiConstants.webServiceUrl +
        "/getData?input=" +
        inputArray.toString();
    var v = AapoortiConstants.webServiceUrl +
        '/getData?input=SPINNERS,EXPERT_LIST_HD,,,';
    final response1 = await http.post(Uri.parse(v));
    //  final response1 =   await http.post(u);
    List<dynamic> jsonResult1 = json.decode(response1.body);

    setState(() {
      dataOrganisation = jsonResult1;
    });

//    final response =   await http.post(url,
//        headers:{
//          "Accept" : "application/json",
//          "Content-Type" : "application/x-www-form-urlencoded"
//        },
//        body: formBody,
//        encoding: Encoding.getByName("utf-8")
//    );
//    List<dynamic> jsonResult = json.decode(response.body);
//    print("Form body = " + json.encode(formBody).toString());
//    print("Json result = " + jsonResult.toString());
//    https://trial.ireps.gov.in/Aapoorti/ServiceCall/getData?input=SPINNERS,EXPERT_LIST_HD,,,,
  }

  Future<bool> _onWillPop(BuildContext context) async {
    // Replace the current route with the new route
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PendingQuery()),
    );
    // Prevent the current route from being popped
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
            key: _scaffoldkey,
            appBar: AppBar(
              backgroundColor: Colors.teal,
              iconTheme: IconThemeData(color: Colors.white),
              title:
                  Text('Reply to Query', style: TextStyle(color: Colors.white)),
            ),
            drawer: AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
            body: Builder(
                    builder: (context) => Column(
                          children: <Widget>[
                            Container(
                                child: Expanded(
                              child: jsonResult == null
                                  ? SpinKitFadingCircle(
                                      color: Colors.teal,
                                      size: 120.0,
                                    )
                                  : _myListView(context),
                            )),
                          ],
                        ))));
  }

  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    return ListView.builder(
      controller: _scrollController,
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        var color;

        var pdfinfo = jsonResult![index]['PDF_INFO'].toString().split("#");
        if (jsonResult![index]['COLOR'] == "#688ECE") {
          color = Colors.blue;
        } else if (jsonResult![index]['COLOR'] == "#FFFFFF") {
          color = Colors.grey;
        }
        if (jsonResult![index]['COLOR'] == "#ECA490") {
          color = Colors.deepOrange[200];
        }

        return Container(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                print("calling tp functn");
              },
              child: Column(
                children: <Widget>[
                  if (index == 0)
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
//                    border: Border(
//                      top: BorderSide(color: Colors.black)
                          border: Border.all(color: Colors.grey, width: 2),
//                    ),

                          borderRadius: BorderRadius.circular(5)),
                      child: new Column(
                        children: <Widget>[
                          // new  Image.asset('assets/main.jpg'),

//                      new Padding(padding: new EdgeInsets.only(top: 5,bottom: 5)),

                          new Text(
                            quid.toString(),
                            style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          new Padding(padding: new EdgeInsets.all(5.0)),
                          Container(
                            height: 0.5,
                            padding: EdgeInsets.all(15),
                            color: Colors.grey,
                          ),
                          new Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, left: 20.0)),
                                  Image.asset(
                                    'assets/name.png',
                                    width: 30,
                                    height: 40,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.0, left: 15.0)),
                                  InkWell(
                                    child: Text(name!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        )),
                                    onTap: () {},
                                  ),
//                        Text("+91-11-23761525",
//                            style: TextStyle(color: Colors.indigo,fontSize: 15,
//                              decoration: TextDecoration.underline,)),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 10.0)),
                              Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, left: 20.0)),
                                  Image.asset(
                                    'assets/email_profile.png',
                                    width: 30,
                                    height: 40,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.0, left: 15.0)),
                                  InkWell(
                                    child: Text(email!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        )),
                                    onTap: () {},
                                  ),
//                        Text("+91-11-23761525",
//                            style: TextStyle(color: Colors.indigo,fontSize: 15,
//                              decoration: TextDecoration.underline,)),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 10.0)),
                              Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, left: 20.0)),
                                  Image.asset(
                                    'assets/phone_icon.png',
                                    width: 30,
                                    height: 40,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.0, left: 15.0)),
                                  InkWell(
                                    child: Text(phno!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        )),
                                    onTap: () {},
                                  ),
//                        Text("+91-11-23761525",
//                            style: TextStyle(color: Colors.indigo,fontSize: 15,
//                              decoration: TextDecoration.underline,)),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 10.0)),
                              Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, left: 20.0)),
                                  Image.asset(
                                    'assets/name_profile.png',
                                    width: 30,
                                    height: 40,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.0, left: 15.0)),
                                  InkWell(
                                    child: Text(usertype!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        )),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 10.0)),
                              Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, left: 20.0)),
                                  Image.asset(
                                    'assets/workarea.png',
                                    width: 30,
                                    height: 40,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.0, left: 15.0)),
                                  InkWell(
                                    child: Text(workarea!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        )),
                                    onTap: () {},
                                  ),
//                        Text("+91-11-23761525",
//                            style: TextStyle(color: Colors.indigo,fontSize: 15,
//                              decoration: TextDecoration.underline,)),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 10.0)),
                              Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, left: 20.0)),
                                  Image.asset(
                                    'assets/work_area.png',
                                    width: 30,
                                    height: 40,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.0, left: 15.0)),
                                  InkWell(
                                    child: Text(desg!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        )),
                                    onTap: () {},
                                  ),
//                        Text("+91-11-23761525",
//                            style: TextStyle(color: Colors.indigo,fontSize: 15,
//                              decoration: TextDecoration.underline,)),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 10.0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: new EdgeInsets.only(bottom: 0),
                            color: Colors.black,
                            height: 0.75,
                          ),
                          Container(
                            margin: new EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              jsonResult![index]['REMARK_TITLE'],
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),

//                                    Container(
//
//                                          padding: new EdgeInsets.only(left: 10,top: 5,bottom: 5),
//                                      width: double.maxFinite,
//                                      color: Colors.grey[100],
//                                      child:AapoortiUtilities.customTextView(/*jsonResult[index]['REMARK_TITLE']*/finalremarktitle, Colors.black),
//                                    ),
                          Padding(
                            padding: new EdgeInsets.only(top: 10, left: 10),
                          ),
                          Container(
                            margin: new EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              jsonResult![index]['REMARK'],
                              style: TextStyle(color: color, fontSize: 15),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 10),
                          ),
                          if (pdfinfo.length > 0 && pdfinfo[0] != "NIL")
                            Row(children: <Widget>[
                              Container(
                                height: 30,
                                width: 105,
                                margin: new EdgeInsets.only(left: 10),
                                child: Text(
                                  "Documents: ",
                                  style: TextStyle(
                                      color: Colors.teal, fontSize: 16),
                                ),
                              ),
                              for (int i = 0; i < pdfinfo.length; i++)
                                if (pdfinfo[i] != "NIL")
                                  Expanded(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              print(pdfinfo[i] +
                                                  "bvknmkn................................................");
                                              if (pdfinfo[i] != "NIL") {
                                                var fileUrl =
                                                    pdfinfo[i].toString();
                                                var fileName =
                                                    fileUrl.substring(fileUrl
                                                        .lastIndexOf("/"));

                                                AapoortiUtilities.ackAlert(
                                                    context, fileUrl, fileName);
                                              } else {
                                                AapoortiUtilities.showInSnackBar(
                                                    context,
                                                    "No PDF attached with this Tender!!");
                                              }
                                            },
                                            child: Container(
                                              height: 30,
                                              child: Image(
                                                  image: AssetImage(
                                                      'images/pdf_home.png'),
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
                          Padding(
                            padding: new EdgeInsets.only(bottom: 10),
                          )
                        ],
                      ))
                    ],
                  ),
                  Container(
                    height: 0.75,
                    color: Colors.black,
                    margin: new EdgeInsets.only(bottom: 10),
                  ),
                  if (replied == true && index == jsonResult!.length - 1)
                    Text('You have already replied to this query'),
                  if (index == jsonResult!.length - 1 &&
                      querysubmitted == false &&
                      replied == false)
                    Container(
                        child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 40,
                              margin: new EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [
                                        0.1,
                                        0.5,
                                        0.8
                                      ],
                                      colors: [
                                        Colors.cyan[400]!,
                                        Colors.cyan[600]!,
                                        Colors.cyan[400]!,
                                      ])),
                              child: MaterialButton(
                                onPressed: () {
                                  if (scrollvalue > 4 - 50)
                                    _scrollController!.jumpTo(maxscroll! + 150);
                                  _scrollController!.jumpTo(maxscroll! + 150);
                                  setState(() {
                                    _myselection = null;
                                    _query = null;
                                    replytohelp = true;
                                    forwardtoexp = false;
                                    containerheight = 200;
                                  });
                                },
                                child: Text(
                                  "Reply To HelpDesk",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                            Padding(
                              padding: new EdgeInsets.only(left: 10),
                            ),
                            Container(
                              height: 0.75,
                              color: Colors.black,
                              margin: new EdgeInsets.only(bottom: 10),
                            ),
                            Container(
                              height: 40,
                              margin: new EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [
                                        0.1,
                                        0.5,
                                        0.8
                                      ],
                                      colors: [
                                        Colors.cyan[400]!,
                                        Colors.cyan[600]!,
                                        Colors.cyan[400]!,
                                      ])),
                              child: MaterialButton(
                                onPressed: () {
                                  _scrollController!.jumpTo(maxscroll! + 200);
                                  _scrollController!.jumpTo(maxscroll! + 200);
                                  setState(() {
                                    forwardtoexp = true;
                                    _myselection = null;
                                    _query = null;
                                    replytohelp = false;
                                    containerheight = 280;
//                        _scrollController.jumpTo(maxscroll);

//                        _scrollController.jumpTo(4700);
                                  });
                                },
                                child: Text(
                                  "Forward To Expert",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (replytohelp || forwardtoexp)
                          Form(
                            key: _formKey,
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: TextFormField(
                                controller: controller,
                                maxLength: 300,
                                inputFormatters: [
                                  FilteringTextInputFormatter(
                                      RegExp('[\\~|\\^|\\%|\\#|\\!|\\+]'),
                                      allow: false)
                                  // new BlacklistingTextInputFormatter(new RegExp('[\\~|\\^|\\%|\\#|\\!|\\+]')),
//          new WhitelistingTextInputFormatter('[\\.|\\,|\\;|\\-|\\(|\\)|\\@|\\ ]')
                                ],
                                validator: (value) {
//                  bool emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                                  if (value!.isEmpty) {
                                    return ('Please enter your Query');
                                  }
//                  else if(!emailValid){
//                    return ('Please enter valid Email-ID');
//                  }
                                },
                                onSaved: (value) {
                                  print(value);
                                  _query = value;
                                },
                                decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 1.0),
                                  hintText: "Enter your Query Here..",
                                  icon: Icon(
                                    Icons.question_answer,
                                    color: Colors.black,
                                  ),
                                ),
                                minLines: 1,
                                maxLines: 5,
                              ),
                            ),
                          ),
                        if (forwardtoexp)
                          Container(
                            margin: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 20),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.person_add,
                                    color: Colors.black,
                                    textDirection: TextDirection.ltr),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                Expanded(
                                    child: Container(
                                  width: double.maxFinite,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text('Select Expert'),
                                    items: dataOrganisation.map((item) {
                                      return DropdownMenuItem(
                                          child: Text(item['NAME']),
                                          value: item['USER_ID'].toString());
                                    }).toList(),
                                    onChanged: (newVal1) {
                                      setState(() {
                                        _myselection = newVal1 as String?;
                                        print("my selection first" +
                                            _myselection!);
                                      });
                                    },
                                    value: _myselection,
                                  ),
                                ))
                              ],
                            ),
                          ),
                        if(forwardtoexp || replytohelp)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 40,
                                margin: new EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [
                                          0.1,
                                          0.5,
                                          0.8
                                        ],
                                        colors: [
                                          Colors.cyan[400]!,
                                          Colors.cyan[600]!,
                                          Colors.cyan[400]!,
                                        ])),
                                child: MaterialButton(
                                  onPressed: () {
                                    validateAndLogin();
                                    print(_query);
                                    setState(() {
                                    });
                                  },
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: new EdgeInsets.only(left: 20),
                              ),
                              Container(
                                height: 0.75,
                                color: Colors.black,
                                margin: new EdgeInsets.only(bottom: 10),
                              ),
                              Container(
                                height: 40,
                                margin: new EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [
                                          0.1,
                                          0.5,
                                          0.8
                                        ],
                                        colors: [
                                          Colors.cyan[400]!,
                                          Colors.cyan[600]!,
                                          Colors.cyan[400]!,
                                        ])),
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      forwardtoexp = false;
                                      replytohelp = false;
                                      _myselection = null;
                                      _query = null;
                                      containerheight = 200;
                                    });
                                  },
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    )),
                  if (index == jsonResult!.length - 1 && querysubmitted == true)
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: AapoortiUtilities.customTextView(
                          'Query Submitted Succesfully', Colors.teal),
                    )
                ],
              ),

//                          Row(
//                            children: <Widget>[
//
//                            ],
//                          ),
//                          Padding(padding: new EdgeInsets.only(bottom: 10),),
            ));
      },
    );
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        ' Please enter Query',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.teal),
      ),
    ),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  final snackbar1 = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Please select expert',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.teal),
      ),
    ),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}
