// import 'dart:convert';
// import 'dart:core';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/common/AapoortiConstants.dart';
// import 'package:flutter_app/common/AapoortiUtilities.dart';
// import 'package:flutter_app/common/NoConnection.dart';
// import 'package:flutter_app/dashboard/non_stock_demands_screen.dart' ;
// //import 'package:flutter_app/home/home_screen.dart' show setState;
// import 'package:progress_dialog/progress_dialog.dart';
// import 'home/Register.dart';
// import 'home/ResetPIN.dart';
// import 'home/UserHome.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart';
// import 'package:flutter_app/common/DatabaseHelper.dart';

// import 'package:crypto/crypto.dart';
// class LoginActivity extends StatefulWidget {
//   String logoutsucc;
//   LoginActivity(String logoutsucc)  {
//     this.logoutsucc=logoutsucc;
//   }

//   @override
//   _LoginActivityState createState() => _LoginActivityState(logoutsucc);
// }
// class _LoginActivityState extends State<LoginActivity> {
//   var jsonResult = null;
//   var errorcode = 0;
//   TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
//   var email, pin;
//   var connectivityresult;
//   ProgressDialog pr;
//   bool _check;
//   bool _check1=false;
//   String checkbox;
//   BuildContext context1;
//   String logoutsucc;

//   _LoginActivityState(String log)  {
//     this.logoutsucc=log;
//   }
//   initState() {
//     super.initState();
//     context1=context;

//     pr=new ProgressDialog(context);
//     print(logoutsucc);
//     print("init ==" + AapoortiConstants.loginUserEmailID);

//     if(AapoortiUtilities.loginflag==false)
//       showDialogBox(context1);


//   }

//   void showDialogBox(BuildContext context1)
//   {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await showDialog<String>(
//         barrierDismissible: false,
//         context: context1,
//         builder: (BuildContext context) => new AlertDialog(
//           content: new
//           Container(
//             height: 183,
//             child:
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Text("For better experience to users, login on APP is allowed using Email ID & PIN.", textAlign:TextAlign.justify,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15, )),
//                 Padding(padding: EdgeInsets.only(top: 10),),
//                 Text("Please visit www.ireps.gov.in to create/reset your PIN and then try to login using Email ID and PIN.",textAlign:TextAlign.justify,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,),),
//                 Padding(padding: EdgeInsets.only(top: 10),),
//                 Text("If successfully logged in using Email ID & PIN, please ignore this.",textAlign:TextAlign.justify,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
//               ],
//             ),
//           ),


//           actions: <Widget>[
//             new FlatButton(
//               child: new Text("OKAY",style: TextStyle(color: Colors.blueGrey[700],fontWeight: FontWeight.w700,fontSize: 15),),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ),
//       );
//     });
//   }

// // ----------------------------------------- Done by Gurmeet for Login Starts
//   static const platform = const MethodChannel('MyNativeChannel');
//   String hashPassOutput;
//   String hash2;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldState> _scaffoldkey=new GlobalKey<ScaffoldState>();
//   String userType = "";

//   Future<bool> _callLoginWebService(String email, String pin) async{

//     print('Function called ' + email.toString() + "-------" + pin.toString());
//     try{
//       var input = email + "#" + pin;
//       var hashPassInput = <String,String>{"input":input};
//       hashPassOutput = await platform.invokeMethod('getData', hashPassInput);
//      AapoortiConstants.hash=hashPassOutput.toString();
//      print("hashPass = " + hashPassOutput.toString());
//       var bytes = utf8.encode(input);

//       hash2 = sha1.convert(bytes).toString();
//       print(hash2);


//     }on PlatformException catch(e){
//       print("Failed to get data from native : '${e.message}'.");

//     }
//     var random = Random.secure();
//     String ctoken=random.nextInt(100).toString();

//     for (var i = 1; i < 10; i++) {
//       ctoken =ctoken+random.nextInt(100).toString();
//     }

//     //JSON VALUES FOR POST PARAM
//     Map<String, dynamic>  urlinput = {"userId":"$email","pass":"$hashPassOutput"+"~$hash2","cToken":"$ctoken","sToken":"","os":"Flutter","token4":"","token5":""};
//     String urlInputString = json.encode(urlinput);
//     print(urlinput);

//     //NAME FOR POST PARAM
//     String paramName = 'UserLogin';

//     //Form Body For URL
//     String formBody = paramName + '=' + Uri.encodeQueryComponent(urlInputString);

//     var url = AapoortiConstants.trialpath + 'Login/UserLogin';
//     print("url = " + url);

//     final response =   await http.post(url,
//         headers:{
//           "Accept" : "application/json",
//           "Content-Type" : "application/x-www-form-urlencoded"
//         },
//         body: formBody,
//         encoding: Encoding.getByName("utf-8")
//     );
//     jsonResult = json.decode(response.body);
//     print("form body = " + json.encode(formBody).toString());
//     print("json result = " + jsonResult.toString());
//     print("response code = " + response.statusCode.toString());


//     if(response.statusCode == 200)
//     {
//       print(jsonResult[0]['ErrorCode'].toString());
//       if(jsonResult[0]['ErrorCode'] == null)
//       {
//         AapoortiUtilities.setUserDetails(jsonResult); //To save user details in shared object
//         userType = jsonResult[0]['USER_TYPE'].toString();
//         return true;
//       }  else
//         return false;
//     }else
//       return false;

//   }
//   GlobalKey _snackKey = GlobalKey<ScaffoldState>();

//   void validateAndLogin()async{
//     var res;
//     if (_formKey.currentState.validate()) {
//       _formKey.currentState.save();
//       //AapoortiUtilities.getProgressDialog(pr);
//       AapoortiUtilities.getProgressDialog(pr);
//       _check = await _callLoginWebService(email, pin);
//       res=_check;
//       AapoortiUtilities.stopProgress(pr);
//       if(res==true)

//       {
//         _check=true;
//         AapoortiUtilities.loggedin=false;

//         Navigator.pop(context);
//         AapoortiConstants.ans="true";
//         print("dfhgbfhdgjryj");
//         print(_check1);
//         if(_check1==true)
//           checkbox="true";
//         else
//           checkbox="false";
//         AapoortiConstants.check=checkbox;
//         AapoortiConstants.date=DateTime.now().add(new Duration(days: 1)).toString();

//         Navigator.push(context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     UserHome(userType, email)));}
//       else
//         _scaffoldkey.currentState.showSnackBar(snackbar);

// //       else
// //         return res;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     AapoortiUtilities al=new AapoortiUtilities();
//     return WillPopScope(
//       onWillPop: () async {
//         //Navigator.pop(context);
//         Navigator.pushNamed(context, "/home");
//       },

//       child:  Scaffold(
//         resizeToAvoidBottomInset: false,
//         //resizeToAvoidBottomPadding: true,
//         key:_scaffoldkey,
//         appBar: AppBar(
//           iconTheme: new IconThemeData(color: Colors.white),
//           backgroundColor: Colors.cyan[400],
//           title: Text('आपूर्ति (IREPS)',
//             style: new TextStyle(color: Colors.white,
//               fontWeight: FontWeight.bold,),),
//         ),
//         drawer :al.navigationdrawerbeforLOgin(context),
//         body: Builder(builder: (context)=>
//             Center(
//                 child: Form(
//                     key: _formKey,
//                     child:

//                     new Container(
//                       decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               stops: [0.1,0.5,0.7,0.9],
//                               colors: [
//                                 Colors.teal[800],
//                                 Colors.teal[600],
//                                 Colors.teal[300],
//                                 Colors.teal[100],
//                               ]
//                           )
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(26.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[


//                             Card(
//                               shape: RoundedRectangleBorder(side: BorderSide(width: 0.0,color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
//                               child: new Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(15.0),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: <Widget>[

//                                         SizedBox(height: 20.0),
//                                         AapoortiUtilities.customTextView(logoutsucc!=null?logoutsucc:'', Colors.red),
//                                         TextFormField(
//                                           initialValue: AapoortiConstants.loginUserEmailID != "" ? AapoortiConstants.loginUserEmailID : null ,
//                                           validator: (value) {
//                                             // bool emailValid = RegExp("^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
//                                             bool emailValid = RegExp("^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})\$").hasMatch(value);
//                                             if (value.isEmpty) {
//                                               return ('Please enter valid Email-ID');
//                                             }
//                                             else if(!emailValid){
//                                               return ('Please enter valid Email-ID');
//                                             }
//                                           },
//                                           onSaved: (value) {
//                                             email = value;
//                                           },
//                                           style: style,
//                                           decoration: InputDecoration(
// //                                        contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 1.0),
//                                             hintText: "Enter Registered Email ID",
//                                             icon: Icon(Icons.mail, color:Colors.black,),
//                                           ),),
//                                         SizedBox(height: 35.0),
//                                         TextFormField(
//                                           initialValue: null,
//                                           keyboardType: TextInputType.number,
//                                           validator: (pin){
//                                             if (pin.isEmpty) {
//                                               return ('Please enter 6-12 digit PIN');
//                                             }
//                                             else if(pin.length < 6 || pin.length >12){
//                                               return ('Please enter 6-12 digit PIN');
//                                             }
//                                           },
//                                           onSaved: (value){
//                                             pin=value;
//                                           },
//                                           obscureText: true,
//                                           style: style,
//                                           decoration: InputDecoration(
// //                                        contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
//                                             hintText: "Enter PIN",
//                                             icon: Icon(Icons.lock,color: Colors.black,),

//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 10.0,
//                                         ),
//                                         Padding(padding: EdgeInsets.only(left: 3)),
//                                         Column(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: <Widget>[
//                                             Row(
//                                               children: <Widget>[
//                                                 new Column(
//                                                   children: <Widget>[
//                                                     Checkbox(
//                                                         value: _check1,
//                                                         onChanged: (bool value)
//                                                         {
//                                                           print(value);


//                                                           setState(()
//                                                           {
//                                                             _check1 = value;
//                                                             print(value);}
//                                                           );
//                                                         })

//                                                   ],
//                                                 ),
//                                                 Padding(padding: EdgeInsets.only(left: 3)),
//                                                 new Column(
//                                                   children: <Widget>[
//                                                     Text('Save login credentials for 5 days',
//                                                       style: TextStyle(fontSize: 14),),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 40,
//                                           child: Container(
//                                             decoration: new BoxDecoration(
//                                               borderRadius: BorderRadius.circular(10.0),
//                                               gradient: LinearGradient(
//                                                   begin: Alignment.topCenter,
//                                                   end: Alignment.bottomCenter,
//                                                   stops: [0.1,0.3,0.5,0.7,0.9],
//                                                   colors: [
//                                                     Colors.teal[400],
//                                                     Colors.teal[400],
//                                                     Colors.teal[800],
//                                                     Colors.teal[400],
//                                                     Colors.teal[400],
//                                                   ]
//                                               ),

//                                             ),


//                                             child: MaterialButton(
//                                               minWidth: 250,
//                                               height:20,
//                                               padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
//                                               onPressed:()
//                                               async {
//                                                 try {
//                                                   connectivityresult =
//                                                   await InternetAddress.lookup(
//                                                       'google.com');
//                                                   if(connectivityresult!=null)
//                                                   {
//                                                     validateAndLogin();
//                                                   }
//                                                 }on SocketException catch(_)
//                                                 {
//                                                   print('internet not available');
//                                                   Navigator.push(context,
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                           new NoConnection()));
//                                                   //_scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("You are not connected to the internet!"),duration: const Duration(seconds: 1), backgroundColor: Colors.red[800],));
//                                                 }
//                                                 //  AapoortiUtilities.stopProgress(pr);
//                                               },

//                                               child: Text("Login",
//                                                   textAlign: TextAlign.center,
//                                                   style: style.copyWith(
//                                                       color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))
//                                               ,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 20.0,
//                                         ),

//                                         InkWell(
//                                             child: RichText(
//                                               text: TextSpan(
//                                                 text: 'How to ',
//                                                 style: TextStyle(decoration: TextDecoration.underline, color: Colors.teal[900],),
//                                                 children: <TextSpan>[
//                                                   TextSpan(
//                                                       text: 'enable login ',
//                                                       style: TextStyle(fontWeight:FontWeight.bold,decoration: TextDecoration.underline, color: Colors.teal[900],)
//                                                   ),
//                                                   TextSpan(text: 'access for Aapoorti?'),
//                                                 ],
//                                               ),
//                                             ),
//                                             onTap: ()
//                                             {
//                                               Navigator.push(context, MaterialPageRoute(
//                                                   builder: (context) => Register()));
//                                             }
//                                         ),
//                                         SizedBox(
//                                           height: 21.0,
//                                         ),
//                                         InkWell(
//                                             child: RichText(
//                                               text: TextSpan(
//                                                 text: 'How to ',
//                                                 style: TextStyle(decoration: TextDecoration.underline, color: Colors.teal[900],),
//                                                 children: <TextSpan>[
//                                                   TextSpan(
//                                                       text: 'reset PIN? ',
//                                                       style: TextStyle(fontWeight:FontWeight.bold,decoration: TextDecoration.underline, color: Colors.teal[900],)
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             onTap: ()
//                                             {
//                                               Navigator.push(context, MaterialPageRoute(
//                                                   builder: (context) => ResetPIN()));
//                                             }
//                                         ),
//                                         SizedBox(
//                                           height: 5.0,
//                                         ),
//                                       ],
//                                     ),

//                                   )
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                     )
//                 )
//             ),
//         ),
//         //////Bottom Navigation Bar//////////////
//         bottomNavigationBar: AapoortiUtilities.bottomnavigationbar(context),
//       ),
//     );
//   }
//   final snackbar=   SnackBar(

//     backgroundColor: Colors.redAccent[100],
//     content: Container(
//       child: Text('Invalid Credentials!',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.white),),
//     ),

//   );

//   final snackbar1=   SnackBar(

//     backgroundColor: Colors.redAccent[100],
//     content: Container(

//       child: Text('Internet not available',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.white),),
//     ),
//   );

// }//d4041248bed11ad5185ad135efc4068512306440
// //5c384d99432ce4466b1d4c9869a919b6922381ca