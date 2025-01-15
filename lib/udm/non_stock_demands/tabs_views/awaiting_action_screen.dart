import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/non_stock_demands/providers/change_scroll_visibility_provider.dart';
import 'package:html/parser.dart';
import 'package:flutter_app/udm/non_stock_demands/view_model/non_stock_demand_view_model.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AwaitingActionScreen extends StatefulWidget {
  const AwaitingActionScreen({Key? key}) : super(key: key);

  @override
  State<AwaitingActionScreen> createState() => _AwaitingActionScreenState();
}

class _AwaitingActionScreenState extends State<AwaitingActionScreen> {

  String fromdate = "";
  String todate = "";

  ScrollController listScrollController = ScrollController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    if(extentAfter == listScrollController.position.maxScrollExtent){
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitVisibilityValue(false);
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitScrollValue(true);
    }
    else if(extentAfter > listScrollController.position.maxScrollExtent/3){
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitVisibilityValue(true);
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitScrollValue(true);
    }
    else if(extentAfter > listScrollController.position.maxScrollExtent/5){
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitVisibilityValue(true);
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitScrollValue(false);
    }
    else{
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitVisibilityValue(true);
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitScrollValue(false);
    }
  }

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    super.initState();
    //Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitScrollValue(false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
           DateTime frdate = DateTime.now().subtract(const Duration(days: 92));
           DateTime tdate = DateTime.now();
           final DateFormat formatter = DateFormat('dd-MM-yyyy');
           fromdate = formatter.format(frdate);
           todate = formatter.format(tdate);
           Provider.of<NonStockDemandViewModel>(context, listen: false).getAwaitingData("Awaiting_My_Action", fromdate, todate, context);
           Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitVisibilityValue(false);
           Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setAwaitScrollValue(false);
    });
  }

  @override
  void didChangeDependencies() {
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<SearchScreenProvider>(context, listen: false).updateScreen(false);
    //   Provider.of<ChangeUiProvider>(context, listen: false).setVisibility(false);
    // });
    super.didChangeDependencies();
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
      backgroundColor: Colors.white,
      floatingActionButton: Consumer<ChangeScrollVisibilityProvider>(builder: (context, value, child){
        if(value.getawaitUiVisibilityValue == true){
          return Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21.5),
                color: Colors.blue
            ),
            child: FloatingActionButton(
                onPressed: () {
                  if(listScrollController.hasClients){
                    if(value.getAwaitUiScrollValue == false){
                      final position = listScrollController.position.maxScrollExtent;
                      listScrollController.jumpTo(position);
                      value.setAwaitScrollValue(true);
                    }
                    else{
                      final position = listScrollController.position.minScrollExtent;
                      listScrollController.jumpTo(position);
                      value.setAwaitScrollValue(false);
                    }
                  }
                }, child: value.getAwaitUiScrollValue == true ? Icon(Icons.arrow_upward, color: Colors.white) : Icon(Icons.arrow_downward_rounded, color: Colors.white)),
          );
        }
        else{
          return SizedBox();
        }
      }),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(language.text('dmddtfrom'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 5.0),
                        FormBuilderDateTimePicker(
                          name: 'FromDate',
                          initialDate: DateTime.now().subtract(const Duration(days: 92)),
                          initialValue: DateTime.now().subtract(const Duration(days: 92)),
                          inputType: InputType.date,
                          format: DateFormat('dd-MM-yyyy'),
                          onChanged: (datevalue){
                            final DateFormat formatter = DateFormat('dd-MM-yyyy');
                            fromdate = formatter.format(datevalue!);
                            //value.checkdateDiff(fromdate, todate, formatter, context);
                            //_checkdateDiff(formatter.format(value!), todate, formatter);
                          },
                          decoration: InputDecoration(
                            //labelText: language.text('datefrom'),
                            //hintText: language.text('datefrom'),
                            contentPadding: EdgeInsetsDirectional.all(10),
                            suffixIcon: Icon(Icons.calendar_month),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(language.text('dmddtto'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 5.0),
                        FormBuilderDateTimePicker(
                          name: 'ToDate',
                          initialDate: DateTime.now(),
                          initialValue: DateTime.now(),
                          inputType: InputType.date,
                          format: DateFormat('dd-MM-yyyy'),
                          onChanged: (datevalue){
                            final DateFormat formatter = DateFormat('dd-MM-yyyy');
                            todate = formatter.format(datevalue!);
                            //value.checkdateDiff(fromdate, todate, formatter, context);
                          },
                          decoration: InputDecoration(
                            //labelText: language.text('dateto'),
                            //hintText: language.text('dateto'),
                            contentPadding: EdgeInsetsDirectional.all(10),
                            suffixIcon: Icon(Icons.calendar_month),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: SizedBox(
              width: size.width,
              height: 45,
              child: MaterialButton(
                  child: Text(language.text('proceed')),
                  shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.black12)),
                  onPressed: (){
                    Provider.of<NonStockDemandViewModel>(context, listen: false).getAwaitingData("Awaiting_My_Action", fromdate, todate, context);
                  }, color: Colors.blue, textColor: Colors.white),
            )),
            Expanded(
                child: Consumer<NonStockDemandViewModel>(builder: (context, value, child){
                   if(value.awaitingState == AwaitingDataState.Busy){
                     return Shimmer.fromColors(
                         baseColor: Colors.grey[300]!,
                         highlightColor: Colors.grey[100]!,
                         child: ListView.builder(
                             itemCount: 4,
                             shrinkWrap: true,
                             padding: EdgeInsets.all(5),
                             itemBuilder: (context, index){
                               return Card(
                                 elevation: 8.0,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(4.0),
                                 ),
                                 child: SizedBox(height: size.height * 0.45),
                               );
                             }
                         )
                     );
                     // return Center(
                     //   child: Column(
                     //     crossAxisAlignment: CrossAxisAlignment.center,
                     //     mainAxisAlignment: MainAxisAlignment.center,
                     //     children: [
                     //       CircularProgressIndicator(strokeWidth: 3, color: Colors.blueAccent),
                     //       SizedBox(height: 3.0),
                     //       Text(language.text('pw'), style: TextStyle(color: Colors.black, fontSize: 16))
                     //     ],
                     //   ),
                     // );
                   }
                   else if(value.awaitingState == AwaitingDataState.Finished){
                      return ListView.builder (
                          itemCount: value.awaitingactionitems.length,
                          shrinkWrap: true,
                          controller: listScrollController,
                          itemBuilder: (BuildContext context, int index){
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Stack(
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
                                                            child: value.awaitingactionitems[index].dmdno == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : value.awaitingactionitems[index].demandref != null ? Wrap(
                                                              alignment: WrapAlignment.start,
                                                              children: <Widget>[
                                                                Text("${value.awaitingactionitems[index].dmdno.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                                Text("Dt. ${value.awaitingactionitems[index].dmddate.toString().split(" ").first} ", style: TextStyle(fontSize: 16, color: Colors.black)),
                                                                Text("${value.awaitingactionitems[index].demandref.toString()}", style: TextStyle(fontSize: 16, color: Colors.indigo.shade500)),
                                                                //getCoveredDuePoDetail(value.coveredDueData[index].podt.toString(), value.coveredDueData[index].firm.toString(), value.coveredDueData[index].pocat.toString().trim())

                                                              ],
                                                            ) : Wrap(
                                                              alignment: WrapAlignment.start,
                                                              children: <Widget>[
                                                                Text("${value.awaitingactionitems[index].dmdno.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                                Text("Dt. ${value.awaitingactionitems[index].dmddate.toString().split(" ").first} ", style: TextStyle(fontSize: 16, color: Colors.black)),
                                                              ],
                                                            ),
                                                          ),
                                                          // ConstrainedBox(
                                                          //   constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                          //   child: value.awaitingactionitems[index].dmdno == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Wrap(
                                                          //     alignment: WrapAlignment.start,
                                                          //     children: <Widget>[
                                                          //       Text("${value.awaitingactionitems[index].dmdno.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                          //       Text("Dt. ${value.awaitingactionitems[index].dmddate.toString().split(" ").first} ", style: TextStyle(fontSize: 16, color: Colors.black)),
                                                          //       Text("${value.awaitingactionitems[index].demandref.toString()}", style: TextStyle(fontSize: 16, color: Colors.indigo.shade500)),
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
                                                          Text(language.text('indentor'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                          SizedBox(height: 4.0),
                                                          ConstrainedBox(
                                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                            child: value.awaitingactionitems[index].indentorname == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :  Wrap(
                                                              alignment: WrapAlignment.start,
                                                              children: <Widget>[
                                                                Text("${value.awaitingactionitems[index].indentorname.toString().split("<br/>").first} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                                Text("${value.awaitingactionitems[index].indentorname.toString().split("<br/>").last}", style: TextStyle(fontSize: 16, color: Colors.black)),
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
                                                          Text(language.text('itemdetails'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                          SizedBox(height: 4.0),
                                                          ConstrainedBox(
                                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                            child: value.awaitingactionitems[index].itemdescription == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :  Wrap(
                                                              alignment: WrapAlignment.start,
                                                              children: <Widget>[
                                                                Text(parse(parse(value.awaitingactionitems[index].itemdescription.toString()).body!.text).documentElement!.text, style: TextStyle(color: Colors.black, fontSize: 16)),
                                                                //Text("${value.awaitingactionitems[index].itemdescription.toString()}", style: TextStyle(color: Colors.black, fontSize: 16)),
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
                                                          Text(language.text('valuemav'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                          SizedBox(height: 4.0),
                                                          ConstrainedBox(
                                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                            child: value.awaitingactionitems[index].demandestval == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Wrap(
                                                              alignment: WrapAlignment.start,
                                                              children: <Widget>[
                                                                Text("Rs. ${value.awaitingactionitems[index].demandestval.toString()}/-", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                                Text(" ${value.awaitingactionitems[index].approvalvalue.toString()}", style: TextStyle(fontSize: 16, color: Colors.green.shade500)),
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
                                                          Text(language.text('crnwith'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                          SizedBox(height: 4.0),
                                                          ConstrainedBox(
                                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                            child: value.awaitingactionitems[index].username == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Wrap(
                                                              alignment: WrapAlignment.start,
                                                              children: <Widget>[
                                                                Text("${value.awaitingactionitems[index].username.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                                Text("${value.awaitingactionitems[index].currentlywith.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                                Text("${value.awaitingactionitems[index].useremail.toString()}", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
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
                                                          Text(language.text('status'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                          SizedBox(height: 4.0),
                                                          ConstrainedBox(
                                                            constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                            child: value.awaitingactionitems[index].dmdstatusval == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Wrap(
                                                              alignment: WrapAlignment.start,
                                                              children: <Widget>[
                                                                Text("${value.awaitingactionitems[index].dmdstatusval.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                                //Text("on 30/11/22 ", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
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
                              ),
                            );
                          });
                   }
                   else if(value.awaitingState == AwaitingDataState.NoData){
                     return Center(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Container(
                               height: 85,
                               width: 85,
                               child: Image.asset('assets/no_data.png')
                           ),
                           Text(language.text('dnf'), style: TextStyle(color: Colors.black, fontSize: 16))
                         ],
                       ),
                     );
                   }
                   else{
                     return SizedBox();
                   }
                })
            )
          ],
        ),
      ),
    );
  }
}
