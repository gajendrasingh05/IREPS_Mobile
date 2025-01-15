import 'package:flutter/material.dart';
import 'package:flutter_app/udm/animations/animations.dart';
import 'package:flutter_app/udm/providers/change_visibility_provider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/view_model/StockHistoryViewModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';

class StockConsumptionDetailScreen extends StatefulWidget {
  const StockConsumptionDetailScreen({Key? key}) : super(key: key);

  @override
  State<StockConsumptionDetailScreen> createState() =>
      _StockConsumptionDetailScreenState();
}

class _StockConsumptionDetailScreenState extends State<StockConsumptionDetailScreen> {
  ScrollController listScrollController = ScrollController();
  late LanguageProvider language;

  void _onScrollEvent() {
    _onScrollBottomEvent();
    final extentAfter = listScrollController.position.pixels;
    if (extentAfter > listScrollController.position.maxScrollExtent / 3) {
      Provider.of<ChangeVisibilityProvider>(context, listen: false).setScrollValue(true);
    } else {
      Provider.of<ChangeVisibilityProvider>(context, listen: false).setScrollValue(false);
    }
  }

  void _onScrollBottomEvent() {
    final position = listScrollController.position.maxScrollExtent;
    final extendValue = listScrollController.position.pixels;
    if(position.abs() == extendValue.abs()) {
      Provider.of<ChangeVisibilityProvider>(context, listen: false).setScrollBottomValue(true);
      Future.delayed(Duration(seconds: 4)).then((value) => bottomdheetSnackBar(context));
    } else {
      //dismissBottomSheet(context);
      Provider.of<ChangeVisibilityProvider>(context, listen: false).setScrollBottomValue(false);
    }
  }

  onWillPop() {
    bool check = Provider.of<ChangeVisibilityProvider>(context, listen: false).getScrollValue;
    if(check == true) {
      Provider.of<ChangeVisibilityProvider>(context, listen: false).setScrollValue(false);
      return true;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    //listScrollController.addListener(_onScrollBottomEvent);
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.removeListener(_onScrollEvent);
    //listScrollController.addListener(_onScrollBottomEvent);
    super.dispose();
  }


  void bottomdheetSnackBar(context){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
          onPressed: (){
            totconsumptionBottomSheet(context);
          },
          label: language.text('snackerview'),
          textColor: Colors.white,
        ),
        content: Text(language.text('consumptionsnackertitle'), style: TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.blue),
    );
  }

  Future<bool> totconsumptionBottomSheet(context) async {
    return await showModalBottomSheet(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.32,
                child: Consumer<StockHistoryViewModel>(builder: (context, value, child){
                   return Container(
                     clipBehavior: Clip.hardEdge,
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                         border: Border.all(color: Colors.blue, width: 2.0)
                     ),
                     padding: EdgeInsets.all(10.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Align(
                               alignment: Alignment.center,
                               child: Text(language.text('totconhed'),
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                       color: Colors.blue,
                                       decoration: TextDecoration.underline,
                                       fontSize: 20,
                                       fontWeight: FontWeight.w400)),
                             ),
                             Align(
                               alignment: Alignment.topRight,
                               child: InkWell(
                                 onTap: () {
                                   Navigator.pop(context);
                                 },
                                 child: Container(
                                   height: 32,
                                   width: 32,
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(16),
                                       color: Colors.blue),
                                   alignment: Alignment.center,
                                   child: Icon(Icons.clear,
                                       color: Colors.white, size: 16),
                                 ),
                               ),
                             ),
                           ],
                         ),
                         SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("${language.text('year')} (${getPreviousYears(2)})",
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                         fontWeight: FontWeight.w500)),
                                 SizedBox(height: 4.0),
                                 value.totyr1920 == 0
                                     ? Text("NA",
                                     style: TextStyle(
                                         color: Colors.black, fontSize: 14))
                                     : Text(
                                     value.totyr1920
                                         .toString()
                                         .split(".")
                                         .first,
                                     style: TextStyle(
                                         color: Colors.black, fontSize: 14))
                               ],
                             ),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("${language.text('year')} (${getPreviousYears(1)})",
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                         fontWeight: FontWeight.w500)),
                                 SizedBox(height: 4.0),
                                 value.totyr2021 == 0
                                     ? Text("NA",
                                     style: TextStyle(
                                         color: Colors.black, fontSize: 14))
                                     : Text(
                                     value.totyr2021
                                         .toString()
                                         .split(".")
                                         .first,
                                     style: TextStyle(
                                         color: Colors.black, fontSize: 14))
                               ],
                             )
                           ],
                         ),
                         SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("${language.text('year')} (${getPreviousYears(0)})",
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                         fontWeight: FontWeight.w500)),
                                 SizedBox(height: 4.0),
                                 value.totyr2122 == 0
                                     ? Text("NA",
                                     style: TextStyle(
                                         color: Colors.black, fontSize: 14))
                                     : Text(
                                     value.totyr2122
                                         .toString()
                                         .split(".")
                                         .first,
                                     style: TextStyle(
                                         color: Colors.black, fontSize: 14))
                               ],
                             ),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("${language.text('year')} (${getPreviousYears(-1)})",
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                         fontWeight: FontWeight.w500)),
                                 SizedBox(height: 4.0),
                                 value.totyr2223 == 0 ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.totyr2223.toString().split(".").first, style: TextStyle(color: Colors.black, fontSize: 14))
                               ],
                             )
                           ],
                         ),
                         SizedBox(height: 10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(language.text('aacncp'),
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                         fontWeight: FontWeight.w500)),
                                 SizedBox(height: 4.0),
                                 value.accncpvalue == 0
                                     ? Text("0",
                                     style: TextStyle(
                                         color: Colors.blue, fontSize: 14))
                                     : Text(
                                     "${value.accncpvalue.toString().split(".").first} (Cat-10, MDP)",
                                     style: TextStyle(
                                         color: Colors.blue, fontSize: 14))
                               ],
                             ),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(language.text('stockmonth'),
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                         fontWeight: FontWeight.w500)),
                                 SizedBox(height: 4.0),
                                 value.stockvalue == 0 ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 14)) :
                                 Text("${value.stockvalue.toString().split(".").first} (${value.monthvalue.toStringAsFixed(1)} months)",
                                     style: TextStyle(
                                         color: Colors.red, fontSize: 14))
                               ],
                             )
                           ],
                         ),
                       ],
                     ),
                   );
                }),
              );
              // ignore: unnecessary_statements
            }) ??
        false;
  }

  void dismissBottomSheet(context){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    language = Provider.of<LanguageProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(language.text('sacdetails'), style: TextStyle(color: Colors.white)),
        actions: [
          Consumer<ChangeVisibilityProvider>(builder: (context, value, child) {
            return InkWell(
              onTap: () {
                if (listScrollController.hasClients) {
                  if (value.getScrollValue == false) {
                    final position =
                        listScrollController.position.maxScrollExtent;
                    listScrollController.jumpTo(position);
                    //value.setScrollBottomValue(true);
                    value.setScrollValue(true);
                  } else {
                    final position =
                        listScrollController.position.minScrollExtent;
                    listScrollController.jumpTo(position);
                    //value.setScrollBottomValue(false);
                    value.setScrollValue(false);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: value.getScrollValue == false
                      ? Icon(Icons.arrow_downward, color: Colors.white)
                      : Icon(Icons.arrow_upward, color: Colors.white,),
                ),
              ),
            );
          })
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          bool backStatus = onWillPop();
          if(backStatus) {
            Navigator.pop(context);
          }
          return false;
        },
        child: Container(
          height: size.height,
          width: size.width,
          child: Consumer<StockHistoryViewModel>(builder: (context, value, child) {
            if (StockSelHistoryConsumptionViewModelDataState.Idle == value.selConsumptionhisstate) {
              return SizedBox();
            } else if (StockSelHistoryConsumptionViewModelDataState.Finished == value.selConsumptionhisstate) {
              return ListView.builder(
                  itemCount: value.consumptiondetailData.length,
                  padding: EdgeInsets.all(5),
                  shrinkWrap: true,
                  controller: listScrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(
                                color: Colors.blue.shade500,
                                width: 1.0,
                              )),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(4.0))
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Container(
                                //   height: 30,
                                //   padding: EdgeInsets.symmetric(horizontal: 5),
                                //   width: double.infinity,
                                //   alignment: Alignment.centerLeft,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                //       color: Colors.blue
                                //   ),
                                //   child: Text(language.text('matunderacc'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                // ),
                                SizedBox(height: 8.0),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(language.text('depot'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                value
                                                            .consumptiondetailData[
                                                                index]
                                                            .dp ==
                                                        null
                                                    ? Text("NA",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14))
                                                    : Text(
                                                        "${value.consumptiondetailData[index].dp.toString()} | ${value.consumptiondetailData[index].dpSname.toString()}",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(language.text('wd'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                value.consumptiondetailData[index].wd == null
                                                    ? Text("NA",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                                    : Text(value.consumptiondetailData[index].wd.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(language.text('cat'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                value
                                                            .consumptiondetailData[
                                                                index]
                                                            .cat ==
                                                        null
                                                    ? Text("NA",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                                    : Text(
                                                        value
                                                            .consumptiondetailData[
                                                                index]
                                                            .cat
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(language.text('mdp'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                value
                                                            .consumptiondetailData[
                                                                index]
                                                            .mainDp ==
                                                        null
                                                    ? Text("NA",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                                    : Text(value.consumptiondetailData[index].mainDp.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${language.text('aac')} | ${language.text('ncp')}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                value.consumptiondetailData[index].aac == null
                                                    ? Text("NA",
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 14))
                                                    : value.consumptiondetailData[index].aacNext != null ? Text(
                                                        "${value.consumptiondetailData[index].aac.toString()} | ${value.consumptiondetailData[index].aacNext.toString()}",
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 14)) : Text(
                                                    "${value.consumptiondetailData[index].aac.toString()} | 0",
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('stockmonth'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500)), value.consumptiondetailData[index].stock == null
                                                    ? Text("NA",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14))
                                                    : value.consumptiondetailData[index].month1 == null ? Text("${value.consumptiondetailData[index].stock.toString()} (0)", style: TextStyle(color: Colors.red, fontSize: 14)) : Text("${value.consumptiondetailData[index].stock.toString()} (${value.consumptiondetailData[index].month1.toString()})", style: TextStyle(color: Colors.red, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(language.text('spare'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                value
                                                            .consumptiondetailData[
                                                                index]
                                                            .sparestock ==
                                                        null
                                                    ? Text("NA",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                                    : Text(
                                                        value
                                                            .consumptiondetailData[
                                                                index]
                                                            .sparestock
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${language.text('lidt')} | ${language.text('lrdt')}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                value
                                                            .consumptiondetailData[
                                                                index]
                                                            .lidt ==
                                                        null
                                                    ? Text("NA",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                                    : Text(
                                                        "${value.consumptiondetailData[index].lidt.toString()} | ${value.consumptiondetailData[index].lrdt.toString()}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(language.text('brate'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                value
                                                            .consumptiondetailData[
                                                                index]
                                                            .bar ==
                                                        null
                                                    ? Text("NA",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                                    : Text(
                                                        "${value.consumptiondetailData[index].bar.toString()}  ${value.consumptiondetailData[index].udes.toString()}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            Column(
                                              children: [
                                                Text(language.text('consales'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(height: 5.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("${language.text('year')} (${getPreviousYears(2)})",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        value.consumptiondetailData[index].issueYr3 == null
                                                            ? Text("NA",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14))
                                                            : Text(
                                                                "${value.consumptiondetailData[index].issueYr3.toString()}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14))
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "${language.text('year')} (${getPreviousYears(1)})",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        value
                                                                    .consumptiondetailData[
                                                                        index]
                                                                    .issueYr2 ==
                                                                null
                                                            ? Text("NA",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14))
                                                            : Text(
                                                                "${value.consumptiondetailData[index].issueYr2.toString()}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 6.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "${language.text('year')} (${getPreviousYears(0)})",
                                                            style: TextStyle(color: Colors.black,
                                                                fontSize: 14, fontWeight: FontWeight.w500)),
                                                        value
                                                                    .consumptiondetailData[
                                                                        index]
                                                                    .issueYr1 ==
                                                                null
                                                            ? Text("NA",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14))
                                                            : Text(
                                                                "${value.consumptiondetailData[index].issueYr1.toString()}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14))
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "${language.text('year')} (${getPreviousYears(-1)})",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        value
                                                                    .consumptiondetailData[
                                                                        index]
                                                                    .issueYr0 ==
                                                                null
                                                            ? Text("NA",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14))
                                                            : Text(
                                                                "${value.consumptiondetailData[index].issueYr0.toString()}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            // SizedBox(height: 10),
                                            // Align(
                                            //   alignment: Alignment.topRight,
                                            //   child: InkWell(
                                            //     onTap: (){
                                            //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockConsumptionDetailScreen()));
                                            //     },
                                            //     child: Container(
                                            //       height: 40,
                                            //       width: 40,
                                            //       alignment: Alignment.center,
                                            //       decoration: BoxDecoration(
                                            //           borderRadius: BorderRadius.circular(20),
                                            //           color: Colors.blue
                                            //       ),
                                            //       child: Icon(Icons.arrow_forward, color: Colors.white),
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ]))
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
                                '${index + 1}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ), //Text
                            ))
                      ],
                    );
                  });
            }
            return SizedBox();
          }),
        ),
      ),
    );
  }

  String getCurrentYear() {
    int currentYear = DateTime.now().year;
    return currentYear.toString();
  }

  String getPreviousYears(int index) {
    int currentYear = DateTime.now().year;
    int previousYear = currentYear - index - 1;
    return '${previousYear.toString().substring(2)}-${(previousYear + 1).toString().substring(2)}';
  }
}
