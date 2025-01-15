
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';


class  ReportaproblemOpt extends StatefulWidget {
  static String? rec;
  @override
  ReportaproblemOptState createState() => new  ReportaproblemOptState();
}
class ReportaproblemOptState extends State<ReportaproblemOpt>{
  String animation="Fav";
  bool visibilityTag = false;
  bool visibilityObs = false;
  int counter=0;
  bool visibilityyes = false;
  bool visibilityno = false;
  int _buttonFilter = 0;
  int _filter = 1;
  // AapoortiUtilities a1=new AapoortiUtilities();

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "tag"){

        visibilityTag = visibility;
        visibilityObs=false;
      }

    });
  }
  void _changedtick(bool visibility, String field) {
    setState(() {
      if (field == "yestick"){
        visibilityyes = visibility;
        visibilityno=false;
      }
      if (field == "NOtick"){
        visibilityno = visibility;
        visibilityyes=false;
      }
    });
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


  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
    onWillPop: () async{
      return true;
    },

      child:new Scaffold(
      resizeToAvoidBottomInset: false,
      // //resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),

        backgroundColor:  (ReportaproblemOpt.rec!="0") ? Colors.teal:Colors.cyan[400],
        title: Text('Report A Problem',style: TextStyle(color:Colors.white),),

      ),
     // drawer: (ReportaproblemOpt.rec!="0") ? AapoortiUtilities.navigationdrawer(context):a1.navigationdrawerbeforLOgin(context),




      body: new Container(
        child: new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.all(20.0)),
            new Padding(padding: new EdgeInsets.only(bottom:15.0)),
            new Text("  Are you going to submit problem related to Mobile App?",
              style: new TextStyle(
                color: Colors.black,fontSize:15,fontWeight: FontWeight.w500,),textAlign: TextAlign.center,),

            new Padding(padding: new EdgeInsets.only(left:60.0,top: 30)),

            new Row(

              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: <Widget>[
                ElevatedButton(
                  onPressed:(){
                    if(counter==1) {

                    }
                    else {
                      _csfilter(1);
                      _changedtick(true, "yestick");
                      Navigator.pushNamed(context, "/report_yes");

                    }
                  },
                  //textColor: Colors.black,
                  //color: Colors.white,
                  //borderSide: const  BorderSide(color: Colors.black,style: BorderStyle.solid),
                  //padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 5.0)),
                      Text("Yes.  ", style: TextStyle(color:_filter == 1 ?  (ReportaproblemOpt.rec!="0" ? Colors.teal:Colors.cyan[400]) : Colors.grey)),
                      Padding(padding: EdgeInsets.only(left: 5.0)),
                      Visibility(
                        child: Image.asset(
                          'assets/check_box.png', width: 30,
                          height: 30,),
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: visibilityyes,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _csfilter(2);
                    _changedtick(true, "NOtick");
                    _changed(true, "tag");
                    counter++;
                  },
                  //textColor: Colors.black,

                  //color: Colors.white,
                  //borderSide: const  BorderSide(color: Colors.black),
                  //padding: const EdgeInsets.all(8.0),
                  //borderSide: const  BorderSide(color: Colors.black,style: BorderStyle.solid),
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 5.0)),
                      Text("No   ",style: new TextStyle(color:_filter != 1 ?  (ReportaproblemOpt.rec!="0" ? Colors.teal:Colors.cyan[400]) : Colors.grey)),
                      Padding(padding: EdgeInsets.only(left: 5.0)),
                      Visibility(
                        child: Image.asset(
                          'assets/check_box.png', width: 30,
                          height: 30,),
                        //Icon(Icons.assignment_turned_in),
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: visibilityno,
                      ),
                    ],
                  ) ,
                ),

                // new Text("Please Visit Helpdesk Link in IREPS Website\n(www.ireps.gov.in)",style: TextStyle(color: Colors.red),),

              ],

            ),

            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 60.0,)),
                Visibility(
                  child: new Text("\nPlease Visit Helpdesk Link in IREPS Website\n"
                    ,style: TextStyle(color: Colors.red),),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visibilityTag,
                ),
              ],
            ),


            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 130.0,top: 0.0)),
                Visibility(
                  child: new Text("(www.ireps.gov.in)",style: TextStyle(color: Colors.red),),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visibilityTag,
                ),
              ],
            )
          ],



        ),








      ),
    ));
  }
}