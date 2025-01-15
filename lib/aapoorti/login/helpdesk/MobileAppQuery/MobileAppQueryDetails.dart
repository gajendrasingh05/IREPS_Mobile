//---------------------MOBILE APP QUERIES----------------------------------------------------//
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';

import 'MobileAppQuery.dart';

class MobileAppQueryDetails extends StatefulWidget {
  get path => null;
  String? qid,
      qdate,
      qtime,
      name,
      email,
      mobile,
      category,
      description,
      status,
      comment;
  MobileAppQueryDetails(this.qid, this.qdate, this.qtime, this.name, this.email,
      this.mobile, this.category, this.description, this.status, this.comment);
  @override
  _MobileAppQueryDetailsState createState() => _MobileAppQueryDetailsState(
      qid!,
      qdate!,
      qtime!,
      name!,
      email!,
      mobile!,
      category!,
      description!,
      status!,
      comment!);
}

class _MobileAppQueryDetailsState extends State<MobileAppQueryDetails> {
  String? date,
      name,
      email,
      mobile,
      category,
      description,
      status,
      comment,
      qid,
      qdate,
      qtime;
  var arr_r1,
      arr_r2,
      arr_c1,
      arr_type,
      arr_rtype,
      arr_rtype2,
      arr_ctype,
      get_name,
      get_date,
      get_reply,
      get_reply2,
      get_cname,
      get_cdate,
      get_comment,
      get_rname,
      get_rdate,
      AddReply_val;

  int cnt_hash = 0;
  bool submit = false,
      markspam = false,
      querysubmitted = false,
      addReply = false;
  _MobileAppQueryDetailsState(
      this.qid,
      this.qdate,
      this.qtime,
      this.name,
      this.email,
      this.mobile,
      this.category,
      this.description,
      this.status,
      this.comment);

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  validateForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      submitQueryReply();

      showDialogBox(context);
    }
  }

  List<dynamic>? jsonResult, jsonResult2, jsonResult3;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;
  String? uid_value;
  TextEditingController? controller1;
  @override
  void dispose() {
    controller1!.dispose();
    // controller2.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    controller1 = new TextEditingController();
    // controller2=new TextEditingController();
    submit = false;
    markspam = false;
    // pr=ProgressDialog(context);

    //callWebService();
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin(
        'Log/GetAllQuery', 'GetAllQuery', inputParam1, inputParam2);
    print(jsonResult!.length);
    print(jsonResult.toString());
    if (jsonResult!.length == 0) {
      jsonResult = null;
      //Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      //Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoResponse()));
    }
    setState(() {});
  }

  void submitReplySpam() async {
//    if (jsonResult == null) {
//      new AlertDialog(
//        content: new Text('Please try again later'),
//        actions: <Widget>[
//          new FlatButton(
//            onPressed: () => Navigator.of(context).pop(false),
//            child: new Text('OKAY'),
//          ),
//        ],
//      );
//    } else {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    print("qid==" + qid.toString());
    String inputParam2 =
        AapoortiUtilities.user!.MAP_ID + "," + qid! + "," + "spam" + "," + "S";
    jsonResult2 = await AapoortiUtilities.fetchPostPostLogin(
        'Login/SubmitQueryReply', 'SubmitQueryReply', inputParam1, inputParam2);
    print("jsonResult2------");
    print(jsonResult2);
    //showDialogBox(context);
    setState(() {
      markspam = true;
      querysubmitted = true;
      submit = false;
    });
  }

  Future<void> submitQueryReply() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    //String uid_array=jsonResult[0]['UID_DATE'].split(" ");
    //String uid=uid_array[0];
    print("qidsubmit==" + qid.toString());
    String reply1 = AddReply_val; //value of reply
    String inputParam2 =
        AapoortiUtilities.user!.MAP_ID + "," + qid! + "," + reply1 + "," + "R";
    print(inputParam2);
    //if the whole layout is present means can reply more
    String reply2 = AddReply_val;
    jsonResult3 = await AapoortiUtilities.fetchPostPostLogin(
        'Login/SubmitQueryReply', 'SubmitQueryReply', inputParam1, inputParam2);
    print(jsonResult3!.length);
    print(jsonResult3.toString());
    if (jsonResult == null) {
      AlertDialog(
        content: Text('Please try again later'),
        actions: <Widget>[
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('OKAY'),
          ),
        ],
      );
    } else {
      uid_value = "Details submitted successfully with Query ID " +
          jsonResult3![0]['UID_DATE'].toString() +
          ".";
    }
    setState(() {
      submit = true;
      markspam = false;
      querysubmitted = true;
    });
  }

  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MobileAppQuery()),
    );
    // Return true to allow the pop action to complete
    return true;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Query Details", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
        ),
        // drawer: AapoortiUtilities.navigationdrawer(context),
        body: ListView(children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    Text(
                      qid.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
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
                                padding: EdgeInsets.only(top: 5.0, left: 20.0)),
                            Icon(
                              Icons.calendar_today,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                            Text(
                              qdate! + " " + qtime!,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        Row(
                          children: <Widget>[
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, left: 20.0)),
                            Icon(
                              Icons.person,
                            ),
                            Padding(padding: EdgeInsets.only(left: 15.0)),
                            Text(
                              name.toString() != null ? name.toString() : "",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        Row(
                          children: <Widget>[
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, left: 20.0)),
                            Icon(
                              Icons.mail,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                            Text(
                              email.toString() != null ? email.toString() : "",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 20.0)),
                            Icon(
                              Icons.phone_in_talk,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                            Text(
                                mobile.toString() != null
                                    ? mobile.toString()
                                    : "",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                )),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        Row(
                          children: <Widget>[
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, left: 20.0)),
                            Icon(
                              Icons.camera,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                            Text(
                              category.toString() != null
                                  ? category.toString()
                                  : "",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        Row(
                          children: <Widget>[
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, left: 20.0)),
                            Icon(
                              Icons.description,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 5.0, left: 15.0)),
                            Expanded(
                              child: Text(
                                  description.toString() != null
                                      ? description.toString()
                                      : "",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                      ],
                    ),
                    Padding(
                        padding: new EdgeInsets.fromLTRB(55.0, 0.0, 30.0, 2.0)),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  if (comment == "NA") Expanded(child: notRepliedView(context)),
                  if (comment != "NA" && status == "1")
                    Expanded(child: RepliedView(context)),
                  if (comment != "NA" && status == "2")
                    Expanded(child: SpamView(context)),

                  /*(status==0 )? Expanded(child: notRepliedView(context))  //not replied list
                          : ((status ==1) ?
                      (Expanded(child: RepliedView(context))) //replied list),
                          : (Expanded(child: SpamView(context)))),*/
                ],
              )
            ],
          )
        ]),
      ),
    );
  }

//////////////////NOT REPLIED/////////////////////////
  Widget notRepliedView(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          Padding(padding: new EdgeInsets.all(3.0)),
          Row(
            children: <Widget>[
              Text(
                "Enter Your Reply",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.teal[400]),
              )
            ],
          ),
          Form(
            key: _formKey,
            child: Container(
              child: TextFormField(
                maxLength: 500,
                inputFormatters: [
                  FilteringTextInputFormatter(
                      RegExp('[\\~|\\^|\\%|\\#|\\!|\\+]'),
                      allow: false)
                  // new BlacklistingTextInputFormatter(new RegExp('[\\~|\\^|\\%|\\#|\\!|\\+]')),
//          new WhitelistingTextInputFormatter('[\\.|\\,|\\;|\\-|\\(|\\)|\\@|\\ ]')
                ],
                controller: controller1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ('Please enter your Reply');
                  } else if (value.length < 20) return ('Enter min. 20 chars');
                },
                onSaved: (value) {
                  AddReply_val = value;
                  print(AddReply_val);
                },
                decoration: InputDecoration(focusColor: Colors.grey),
                minLines: 2,
                maxLines: 5,
              ),
            ),
          ),
          new Padding(padding: new EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
          new Row(
            children: <Widget>[
              Text("Special chars not allowed except dot(.) & comma(,)",
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.blueGrey,
                  )),
              //Padding(padding: new EdgeInsets.only(bottom: 35.0)),
            ],
          ),
          Padding(padding: new EdgeInsets.only(bottom: 25.0)),
          Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.1,
                    0.3,
                    0.5,
                    0.7,
                    0.9
                  ],
                  colors: [
                    Colors.teal[400]!,
                    Colors.teal[400]!,
                    Colors.teal[800]!,
                    Colors.teal[400]!,
                    Colors.teal[400]!,
                  ]),
            ),
            child: MaterialButton(
              minWidth: 320,
              height: 20,
              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
              onPressed: () {
                setState(() {
                  AddReply_val = null;
                  querysubmitted = true;
                  markspam = false;
                });
                validateForm();
                // submitQueryReply();
                // showDialogBox(context);
              },
              child: Text("Submit",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ),
          Padding(padding: new EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
          Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.1,
                    0.3,
                    0.5,
                    0.7,
                    0.9
                  ],
                  colors: [
                    Colors.teal[400]!,
                    Colors.teal[400]!,
                    Colors.teal[800]!,
                    Colors.teal[400]!,
                    Colors.teal[400]!,
                  ]),
            ),
            child: MaterialButton(
              minWidth: 160,
              height: 5,
              padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
              onPressed: () {
                setState(() {
                  AddReply_val = null;
                  querysubmitted = true;
                  markspam = true;
                  submit = false;
                });
                //validateForm();
                showDialogBoxspam(context);
                // showDialogBox(context);
              },
              child: Text("Mark Spam",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ),
          new Padding(padding: new EdgeInsets.only(bottom: 12.0)),
          /*querysubmitted ? new Column(
  children: <Widget>[
    new Padding(padding: new EdgeInsets.all(5.0)),
    new Row(
    children: <Widget>[
    Text('      $get_name', textAlign:TextAlign.center,
    style: TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.normal,
    color: Colors.teal[600]),)
    ],
    ),
    new Padding(padding: new EdgeInsets.all(4.0)),
    Container(
    height: 0.5,
    padding: EdgeInsets.all(15),
    color: Colors.blueGrey[200],
  ),
  new Row(
  children: <Widget>[
  Expanded(child:
  Text('$AddReply_val', style: TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.normal,
  color: Colors.grey,))
  ),],
  ),
  ],
  ) : Column(
            children: <Widget>[
              new Padding(padding: new EdgeInsets.all(5.0)),
              new Row(
                children: <Widget>[
                  Text('      $get_name', textAlign:TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.teal[600]),)
                ],
              ),
              new Padding(padding: new EdgeInsets.all(4.0)),
              Container(
                height: 0.5,
                padding: EdgeInsets.all(15),
                color: Colors.blueGrey[200],
              ),
              new Row(
                children: <Widget>[
                  Expanded(child:
                  Text('$AddReply_val', style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,))
                  ),],
              ),
            ],
          )
*/
        ],
      ),
    );
  }

  //////////////////REPLIED VIEW//////////////////////
  Widget RepliedView(BuildContext context) {
    if (comment == null || comment!.isEmpty) {
      return Container(); // Return an empty container if comment is null or empty
    }

    int cntHash = comment!.length - comment!.replaceAll("#", "").length;

    print("cnt_hash = $cntHash");

    if (cntHash == 0) {
      List<String> arrR1 = comment!.split(",");
      if (arrR1.length < 4) return Container(); // Ensure valid data

      String getName = arrR1[1];
      String getDate = arrR1[2];
      String getReply = arrR1[3];

      return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(5.0)),
            Row(
              children: <Widget>[
                Text(
                  'Replied by- $getName $getDate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.teal[600],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Container(
              height: 0.5,
              color: Colors.blueGrey[200],
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Text(
              getReply,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (cntHash == 1) {
      List<String> arrType = comment!.split("#");
      if (arrType.length < 2) return Container(); // Ensure valid data

      List<String> arrR1 = arrType[0].split(",");
      List<String> arrC1 = arrType[1].split(",");

      if (arrR1.length < 4 || arrC1.length < 4) return Container(); // Ensure valid data

      String getName = arrR1[1];
      String getDate = arrR1[2];
      String getReply = arrR1[3];

      String getCName = arrC1[1];
      String getCDate = arrC1[2];
      String getComment = arrC1[3];

      return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(5.0)),
            Row(
              children: <Widget>[
                Text(
                  'Replied by- $getName $getDate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.teal[600],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Container(
              height: 0.5,
              color: Colors.grey,
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Text(
              getReply,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            Container(
              height: 2.5,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            Padding(padding: EdgeInsets.all(7.0)),
            Row(
              children: <Widget>[
                Text(
                  'Commented by- $getCName $getCDate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.teal[600],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(3.0)),
            Container(
              height: 0.5,
              color: Colors.grey,
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Text(
              getComment,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            MaterialButton(
              color: Colors.teal,
              minWidth: 130,
              height: 40,
              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
              child: Text(
                "Add Reply",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                // Handle add reply button action
              },
            ),
            // Optional: You can add logic for displaying AddReplyView here
          ],
        ),
      );
    }

    if (cntHash > 1) {
      List<String> arrType = comment!.split("#");
      if (arrType.length < 3) return Container(); // Ensure valid data

      List<String> arrR1 = arrType[0].split(",");
      List<String> arrC1 = arrType[1].split(",");
      List<String> arrR2 = arrType[2].split(",");

      if (arrR1.length < 4 || arrC1.length < 4 || arrR2.length < 4) return Container(); // Ensure valid data

      String getName = arrR1[1];
      String getDate = arrR1[2];
      String getReply = arrR1[3];

      String getCName = arrC1[1];
      String getCDate = arrC1[2];
      String getComment = arrC1[3];

      String getRName = arrR2[1];
      String getRDate = arrR2[2];
      String getReply2 = arrR2[3];

      return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(5.0)),
            Row(
              children: <Widget>[
                Text(
                  'Replied by- $getName $getDate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.teal[600],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(3.0)),
            Container(
              height: 0.5,
              color: Colors.blueGrey[200],
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Text(
              getReply,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            Container(
              height: 2.5,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            Padding(padding: EdgeInsets.all(7.0)),
            Row(
              children: <Widget>[
                Text(
                  'Commented by- $getCName $getCDate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.teal[600],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(3.0)),
            Container(
              height: 0.5,
              color: Colors.blueGrey[200],
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Text(
              getComment,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            Container(
              height: 2.5,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            Padding(padding: EdgeInsets.all(7.0)),
            Row(
              children: <Widget>[
                Text(
                  'Replied by- $getRName $getRDate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.teal[600],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(3.0)),
            Container(
              height: 0.5,
              color: Colors.blueGrey[200],
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Text(
              getReply2,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Container(); // Fallback for unexpected cases
  }

  ////////////////////SPAM REPLY//////////////////////
  Widget SpamView(BuildContext context) {
    arr_r1 = comment!.split(",");
    get_name = arr_r1[1];
    get_date = arr_r1[2];
    get_reply = arr_r1[3];
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!, width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.all(5.0)),
            new Row(
              children: <Widget>[
                Text(
                  '      Replied by- $get_name $get_date',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.teal[600]),
                )
              ],
            ),
            new Padding(padding: new EdgeInsets.all(3.0)),
            Container(
              height: 0.5,
              padding: EdgeInsets.all(15),
              color: Colors.blueGrey[200],
            ),
            new Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 25),
                ),
                Text('$get_reply',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ))
              ],
            ),
          ],
        ));
  }

///////////////////ADD REPLY////////////////////////
  Widget AddReplyView(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
              ),
              TextFormField(
                controller: controller1,
                validator: (value) {
                  if (value!.isEmpty) return ('Enter min. 20 chars');
                },
                textAlign: TextAlign.left,
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  String reply2 = value!;
                  print("reply2" + reply2.toString());
                },
                decoration: InputDecoration(
                  hintText: 'Enter your Reply',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              MaterialButton(
                color: Colors.teal,
                minWidth: 200,
                height: 40,
                padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                child: Text("Submit",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                onPressed: () {
                  validateForm();
                  //   submitQueryReply();
                  //qid pass
                  //  showDialogBox(context);
                },
              ),
            ]));
  }

  void showDialogBox(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          content: new Container(
            height: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Data submitted successfully for Query ID $qid",
                    style: TextStyle(fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text(
                "OKAY",
                style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MobileAppQuery()));
                //Navigator.of(context).pop();
                //Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
  }

  void showDialogBoxspam(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          content: new Container(
            height: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Are you Sure to Mark this Query as Spam ?",
                    style: TextStyle(fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text(
                "Yes",
                style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
              onPressed: () {
                submitReplySpam();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MobileAppQuery()));
                //Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
            ),
           MaterialButton(
              child: Text(
                "No",
                style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
  }
}
