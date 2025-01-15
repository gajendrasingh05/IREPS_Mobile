import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:html/parser.dart';
import 'package:flutter_app/udm/non_stock_demands/providers/change_scroll_visibility_provider.dart';
import 'package:flutter_app/udm/non_stock_demands/providers/change_ui_provider.dart';
import 'package:flutter_app/udm/non_stock_demands/providers/search_screen_provider.dart';
import 'package:flutter_app/udm/non_stock_demands/view_model/non_stock_demand_view_model.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

class DashBoardDataScreen extends StatefulWidget {
  static const routeName = "/dashboardData-screen";

  final String status;
  final String statuscode;
  final String demandno;
  final String indentor;
  final String indentorcode;
  final String consignee;
  final String consigneecode;
  final String datefrom;
  final String dateto;
  final String itemdesc;
  DashBoardDataScreen(this.status, this.statuscode, this.demandno, this.indentor, this.indentorcode, this.consignee, this.consigneecode, this.datefrom, this.dateto, this.itemdesc);

  @override
  State<DashBoardDataScreen> createState() => _DashBoardDataScreenState();
}

class _DashBoardDataScreenState extends State<DashBoardDataScreen> {

  ScrollController listScrollController = ScrollController();
  final _textsearchController = TextEditingController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    if(extentAfter == listScrollController.position.maxScrollExtent){
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashUiVisibilityValue(false);
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashScrollValue(true);
    }
    else if(extentAfter > listScrollController.position.maxScrollExtent/3){
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashUiVisibilityValue(true);
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashScrollValue(true);
    }
    else if(extentAfter > listScrollController.position.maxScrollExtent/5){
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashUiVisibilityValue(true);
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashScrollValue(false);
    }
    else{
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashUiVisibilityValue(true);
      Provider.of<ChangeScrollVisibilityProvider>(context, listen: false).setdashScrollValue(false);
    }
  }

  onWillPop() {
      bool check = Provider.of<ChangeUiProvider>(context, listen: false).getScrollValue;
      if(check == true) {
        //Provider.of<ChangeVisibilityProvider>(context, listen: false).setScrollValue(false);
        return true;
   } else {
        return true;
      }
  }

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    super.initState();
    print("Status code ${widget.statuscode}");
    print("indentor code ${widget.indentorcode}");
    print("consignee code ${widget.consigneecode}");
    print("From Date ${widget.datefrom}");
    print("To Date ${widget.dateto}");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(widget.status.toString() != "All" || widget.indentor.toString() != "All" || widget.consignee.toString() != "All" || widget.demandno.trim().length > 0 || widget.itemdesc.length > 0){
        Provider.of<NonStockDemandViewModel>(context, listen: false).getDashBoardData("DashBoard_", widget.statuscode, widget.demandno, widget.indentorcode, widget.consigneecode, widget.datefrom, widget.dateto, widget.itemdesc, context);
      }
      else {
        Provider.of<NonStockDemandViewModel>(context, listen: false).getDefaultDBData("DashBoard", widget.datefrom, widget.dateto, context);
      }
    });
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
    final updatechangeprovider = Provider.of<SearchScreenProvider>(context, listen: false);
    return WillPopScope(child: Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Consumer<ChangeScrollVisibilityProvider>(builder: (context, value, child){
        if(value.getdashUiVisibilityValue == true){
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
                    if(value.getDashUiScrollValue == false){
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
                }, child: value.getDashUiScrollValue == true ? Icon(Icons.arrow_upward, color: Colors.white) : Icon(Icons.arrow_downward_rounded, color: Colors.white)),
          );
        }
        else{
          return SizedBox();
        }
      }),
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        automaticallyImplyLeading: false,
        title: Consumer<SearchScreenProvider>(
            builder: (context, value, child) {
              if(value.getSearchValue) {
                return Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                  child: Center(child: TextField(
                    cursorColor: Colors.red[300],
                    controller: _textsearchController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.red[300]),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, color: Colors.red[300]),
                          onPressed: () {
                            updatechangeprovider.updateScreen(false);
                            _textsearchController.text = "";
                            Provider.of<NonStockDemandViewModel>(context, listen: false).searchingDBData(_textsearchController.text.trim(), context);
                          },
                        ),
                        hintText: language.text('search'),
                        border: InputBorder.none),
                    onChanged: (query) {
                      Provider.of<NonStockDemandViewModel>(context, listen: false).searchingDBData(_textsearchController.text.trim(), context);
                    },
                  ),
                  ),
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          //Navigator.of(context, rootNavigator: true).pushNamed(UserHomeScreen.routeName);
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, color: Colors.white)),
                    SizedBox(width: 10),
                    Text(language.text('dashboard'), maxLines: 1, style: TextStyle(color: Colors.white))
                  ],
                );
              }
            }),
        actions: [
          Consumer<SearchScreenProvider>(builder: (context, value, child){
            if(value.getSearchValue){
              return SizedBox();
            }
            else{
              return IconButton(
                  onPressed: () {
                    updatechangeprovider.updateScreen(true);
                  },
                  icon: Icon(Icons.search, color: Colors.white));
            }
          })
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Consumer<NonStockDemandViewModel>(builder: (context, value, child){
            if(DashboardDataState.Busy == value.dashboardstate){
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
            }
            else if(DashboardDataState.Finished == value.dashboardstate){
              return ListView.builder(
                  itemCount: value.dashboarditems.length,
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
                                                  child: value.dashboarditems[index].dmdno == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : value.dashboarditems[index].demandref != null ? Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("${value.dashboarditems[index].dmdno.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text("Dt. ${value.dashboarditems[index].dmddate.toString().split(" ").first} ", style: TextStyle(fontSize: 16, color: Colors.black)),
                                                      Text("${value.dashboarditems[index].demandref.toString()}", style: TextStyle(fontSize: 16, color: Colors.indigo.shade500)),
                                                      //getCoveredDuePoDetail(value.coveredDueData[index].podt.toString(), value.coveredDueData[index].firm.toString(), value.coveredDueData[index].pocat.toString().trim())

                                                    ],
                                                  ) : Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("${value.dashboarditems[index].dmdno.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text("Dt. ${value.dashboarditems[index].dmddate.toString().split(" ").first} ", style: TextStyle(fontSize: 16, color: Colors.black)),
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
                                                Text(language.text('indentor'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                SizedBox(height: 4.0),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                  child: value.dashboarditems[index].indentorname == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :  Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("${value.dashboarditems[index].indentorname.toString().split("<br/>").first} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text("${value.dashboarditems[index].indentorname.toString().split("<br/>").last}", style: TextStyle(fontSize: 16, color: Colors.black)),
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
                                                  constraints: BoxConstraints(maxWidth: size.width),
                                                  child: value.dashboarditems[index].itemdescription == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :  Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      //Text(parse(parse(value.dashboarditems[index].itemdescription.toString()).body!.text).documentElement!.text, style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text("${value.dashboarditems[index].itemdescription.toString()}", style: TextStyle(color: Colors.black, fontSize: 16)),
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
                                                  child: value.dashboarditems[index].demandestval == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("Rs. ${value.dashboarditems[index].demandestval.toString()}/-", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text(" ${value.dashboarditems[index].approvalvalue.toString()}", style: TextStyle(fontSize: 16, color: Colors.green.shade500)),
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
                                                  child: value.dashboarditems[index].username == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : value.dashboarditems[index].useremail == null ? Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("${value.dashboarditems[index].username.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text("${value.dashboarditems[index].currentlywith.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      //Text("${value.dashboarditems[index].useremail.toString()}", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
                                                      //getCoveredDuePoDetail(value.coveredDueData[index].podt.toString(), value.coveredDueData[index].firm.toString(), value.coveredDueData[index].pocat.toString().trim())

                                                    ],
                                                  ) : Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("${value.dashboarditems[index].username.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text("${value.dashboarditems[index].currentlywith.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text("${value.dashboarditems[index].useremail.toString()}", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
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
                                                  child: value.dashboarditems[index].dmdstatusval == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("${value.dashboarditems[index].dmdstatusval.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
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
                    );
                  });
            }
            else if(DashboardDataState.NoData == value.dashboardstate){
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
            else {
              return SizedBox();
            }
        }),
      ),
    ), onWillPop: () async{
      bool backStatus = onWillPop();
      if(backStatus){
        Navigator.pop(context);
      }
      return false;
    });
  }
}
