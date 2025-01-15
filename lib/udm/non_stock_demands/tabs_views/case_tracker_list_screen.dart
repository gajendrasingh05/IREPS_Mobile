import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';

class CaseTrackerDataScreen extends StatefulWidget {
  const CaseTrackerDataScreen({Key? key}) : super(key: key);

  @override
  State<CaseTrackerDataScreen> createState() => _CaseTrackerDataScreenState();
}

class _CaseTrackerDataScreenState extends State<CaseTrackerDataScreen> {

  ScrollController listScrollController = ScrollController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    if(extentAfter > listScrollController.position.maxScrollExtent/3){
      //Provider.of<ChangeVisibilityProvider>(context, listen: false).setScrollValue(true);
    }
    else{
      //Provider.of<ChangeVisibilityProvider>(context, listen: false).setScrollValue(false);
    }
  }

  onWillPop() {
    // bool check = Provider.of<ChangeVisibilityProvider>(context, listen: false).getScrollValue;
    //  if(check == true) {
    //    //Provider.of<ChangeVisibilityProvider>(context, listen: false).setScrollValue(false);
    //    return true;
    //  } else {
    //    return true;
    //  }
  }

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(language.text('casetracker'), style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: ListView.builder(
            itemCount: 5,
            padding: EdgeInsets.all(5),
            shrinkWrap: true,
            controller: listScrollController,
            itemBuilder: (context, index){
              return Stack(
                children: [
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(
                          color: Colors.blue.shade500,
                          width: 1.0,
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          color: Colors.white
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Column(children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(language.text('dmdnodt'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4.0),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              children: <Widget>[
                                                Text("IREPS-36640-22-00094 ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                Text("Dt. 23/11/22", style: TextStyle(fontSize: 16, color: Colors.black)),
                                                Text("Test/231122", style: TextStyle(fontSize: 16, color: Colors.blue.shade200)),
                                                //getCoveredDuePoDetail(value.coveredDueData[index].podt.toString(), value.coveredDueData[index].firm.toString(), value.coveredDueData[index].pocat.toString().trim())

                                              ],
                                            ),
                                          ),
                                          // value.coveredDueData[index].poNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                          // ConstrainedBox(
                                          //   constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                          //   child: Wrap(
                                          //     alignment: WrapAlignment.start,
                                          //     children: <Widget>[
                                          //       Text("P.O.No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                          //       Text("${value.coveredDueData[index].poNo.toString()} ", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
                                          //       //getCoveredDuePoDetail(value.coveredDueData[index].podt.toString(), value.coveredDueData[index].firm.toString(), value.coveredDueData[index].pocat.toString().trim())
                                          //
                                          //     ],
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(language.text('itemsr'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4.0),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              children: <Widget>[
                                                Text("RISHI MEENA", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                Text("SSE/EPS/UD", style: TextStyle(fontSize: 16, color: Colors.black)),
                                                //getCoveredDuePoDetail(value.coveredDueData[index].podt.toString(), value.coveredDueData[index].firm.toString(), value.coveredDueData[index].pocat.toString().trim())

                                              ],
                                            ),
                                          ),
                                          //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(language.text('consignee'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4.0),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              children: <Widget>[
                                                Text("Item No.1: ELECTRONIC BALLAST (EB) F.... [Qty: 40 Nos.]", style: TextStyle(color: Colors.black, fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                          //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(language.text('stknon'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4.0),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              children: <Widget>[
                                                Text("Rs.16,772/-", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                Text("Jr. Scale", style: TextStyle(fontSize: 16, color: Colors.green.shade500)),
                                                //getCoveredDuePoDetail(value.coveredDueData[index].podt.toString(), value.coveredDueData[index].firm.toString(), value.coveredDueData[index].pocat.toString().trim())

                                              ],
                                            ),
                                          ),
                                          //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(language.text('itemdesc'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4.0),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              children: <Widget>[
                                                Text("MOHAN LAL ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                Text("Sr.DME/EPS/UD ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                Text("test.srdme1@gmail.com", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
                                                //getCoveredDuePoDetail(value.coveredDueData[index].podt.toString(), value.coveredDueData[index].firm.toString(), value.coveredDueData[index].pocat.toString().trim())

                                              ],
                                            ),
                                          ),
                                          //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(language.text('casefile'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4.0),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              children: <Widget>[
                                                Text("Sent for further action ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                Text("on 30/11/22 ", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
                                                //getCoveredDuePoDetail(value.coveredDueData[index].podt.toString(), value.coveredDueData[index].firm.toString(), value.coveredDueData[index].pocat.toString().trim())

                                              ],
                                            ),
                                          ),
                                          //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(language.text('tendercls'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 4.0),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              children: <Widget>[
                                                Text("Sent for further action ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                Text("on 30/11/22 ", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
                                                //getCoveredDuePoDetail(value.coveredDueData[index].podt.toString(), value.coveredDueData[index].firm.toString(), value.coveredDueData[index].pocat.toString().trim())

                                              ],
                                            ),
                                          ),
                                          //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ])
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 1,
                      left: 2,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.shade500,
                        radius: 12,
                        child: Text(
                          '${index+1}',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ), //Text
                      )
                  )
                ],
              );
            }),
      ),
    );
  }
}
