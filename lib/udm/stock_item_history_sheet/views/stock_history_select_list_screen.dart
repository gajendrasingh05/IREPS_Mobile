import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/providers/change_visibility_provider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/pdfVIewForPoSeach.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/providers/stockhistory_updatechange_screen_provider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/view_model/StockHistoryViewModel.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views/stock_po_detail_screen.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views_view/covered_due_detail_screen.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views_view/intent_detail_screen.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views_view/material_rejected_screen.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views_view/material_under_accountal_screen.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views_view/orderplaced_screen.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views_view/overstock_screen.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views_view/rly_board_indent_screen.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views_view/stock_consumption_detail_screen.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views_view/uncovered_due_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import 'package:readmore/readmore.dart';

class StockHistorySelectlistScreen extends StatefulWidget {
  static const routeName = "/stockhistoryselect-screen";

  final String rlycode;
  final String inputvalue;
  final String plNum;
  StockHistorySelectlistScreen(this.rlycode, this.inputvalue, this.plNum);

  @override
  State<StockHistorySelectlistScreen> createState() => _StockHistorySelectlistScreenState();
}

class _StockHistorySelectlistScreenState extends State<StockHistorySelectlistScreen> {

  final _textsearchController = TextEditingController();

  final plController = TextEditingController();

  String rlyname = "--Select Railway--";

  @override
    void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
       getAllData();
    });

  }

  Future<void> getAllData() async{
      await Future.delayed(Duration(milliseconds: 400)).then((value){
        Provider.of<StockHistoryViewModel>(context, listen: false).getStockSelectItemData(widget.rlycode, widget.plNum, 'ItemDetails', context);
      });
      await Future.delayed(Duration(milliseconds: 400)).then((value){
        Provider.of<StockHistoryViewModel>(context, listen: false).getStockSelectConsumptionData(widget.rlycode, widget.plNum, 'Stock_Consumption_Details', context);
      });
      await Future.delayed(Duration(milliseconds: 400)).then((value){
        Provider.of<StockHistoryViewModel>(context, listen: false).getStockSelectAvailableStockData(widget.rlycode, widget.plNum, 'Stock_Details', context);
      });
      await Future.delayed(Duration(milliseconds: 400)).then((value){
        Provider.of<StockHistoryViewModel>(context, listen: false).getStockSelectUnCoveredStockData(widget.rlycode, widget.plNum, 'UncovDues_Details', context);
      });
      await Future.delayed(Duration(milliseconds: 400)).then((value){
        Provider.of<StockHistoryViewModel>(context, listen: false).getStockSelectIntentStockData(widget.rlycode, widget.plNum, 'Indent_Details', context);
      });
      await Future.delayed(Duration(milliseconds: 400)).then((value){
        Provider.of<StockHistoryViewModel>(context, listen: false).getStockSelectRlyCoverageIntentData(widget.rlycode, widget.plNum, 'Rly_Board_Indent_Coverage_Details', context);
      });
      await Future.delayed(Duration(milliseconds: 400)).then((value){
        Provider.of<StockHistoryViewModel>(context, listen: false).getStockSelectCoveredDueData(widget.rlycode, widget.plNum, 'Covered_Due_details', context);
      });
      await Future.delayed(Duration(milliseconds: 400)).then((value){
        Provider.of<StockHistoryViewModel>(context, listen: false).getStockSelectUnderAccData(widget.rlycode, widget.plNum, 'Details_material_Under_Accountal', context);
      });
      await Future.delayed(Duration(milliseconds: 400)).then((value){
        Provider.of<StockHistoryViewModel>(context, listen: false).getStockSelectMaterialRejData(widget.rlycode, widget.plNum, 'Details_Material_Rejected', context);
      });
      await Future.delayed(Duration(milliseconds: 400)).then((value){
        Provider.of<StockHistoryViewModel>(context, listen: false).getStockSelectOrderPlacedData(widget.rlycode, widget.plNum, 'Last_Five_Years_Orders', context);
      });
      await Future.delayed(Duration(milliseconds: 400)).then((value){
        Provider.of<StockHistoryViewModel>(context, listen: false).getStockSelectOverStockData(widget.rlycode, widget.plNum, 'Overstock_Surplus', context);
      });

    }

  @override
  void dispose() {
    super.dispose();
  }

  void updateContainer(){
    bool value = Provider.of<ChangeVisibilityProvider>(context, listen: false).getChangeColorValue;
    if(value == true){
      Provider.of<ChangeVisibilityProvider>(context, listen: false).setChangeColorValue(false);
    }
    else{
      Provider.of<ChangeVisibilityProvider>(context, listen: false).setChangeColorValue(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    final updatechangeprovider = Provider.of<StockHistoryupdateChangesScreenProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        automaticallyImplyLeading: false,
        actions: [
          Consumer<StockHistoryupdateChangesScreenProvider>(builder: (context, value, child){
            if(value.getSearchValue){
              return SizedBox();
            }
            else{
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'clear',
                        child: Text(language.text('clear'), style: TextStyle(color: Colors.black)),
                      ),
                      PopupMenuItem(
                        value: 'refresh',
                        child: Text(language.text('refresh'), style: TextStyle(color: Colors.black)),
                      ),
                      PopupMenuItem(
                        value: 'exit',
                        child: Text(language.text('exit'), style: TextStyle(color: Colors.black)),
                      ),
                    ],
                    color: Colors.white,
                    onSelected: (value) {
                      if(value == 'clear') {
                        Provider.of<StockHistoryViewModel>(context, listen: false).clearSelAllData(context);
                        //UdmUtilities.showInSnackBar(context, "Data cleared successfully.");
                      }
                      else if(value == 'refresh') {
                        if(Provider.of<StockHistoryViewModel>(context, listen: false).selhisstate == StockSelHistoryViewModelDataState.ClearData){
                           Provider.of<StockHistoryViewModel>(context, listen: false).loadData(context);
                        }
                        else{
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            getAllData();
                          });
                        }
                      }
                      else if(value == 'exit') {
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              );
            }
          })
        ],
        title: Consumer<StockHistoryupdateChangesScreenProvider>(builder: (context, value, child){
          if(value.getSearchValue){
            return Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  cursorColor: Colors.red[300],
                  controller: _textsearchController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.red[300]),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: Colors.red[300]),
                        onPressed: () {
                          updatechangeprovider.updateScreen(false);
                        },
                      ),
                      hintText: language.text('search'),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none),
                      onChanged: (query) {
                  },
                ),
              ),
            );
          }
          else{
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      //Provider.of<StockHistoryViewModel>(context, listen: false).clearOnBack(context).then((value) =>  Navigator.pop(context));
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white)),
                SizedBox(width: 5),
                Container(
                    height: size.height * 0.10,
                    width: size.width/1.5,
                    child: Marquee(
                      text: "${language.text('stkitemtitle')}",
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      blankSpace: 30.0,
                      velocity: 100.0,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      pauseAfterRound: Duration(seconds: 1),
                      accelerationDuration: Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    )
                )

                // Text(language.text('stkitemtitle').length > 20
                //     ? '${language.text('stkitemtitle').substring(0, 20)}...'
                //     : language.text('stkitemtitle'))

              ],
            );
          }
        }),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Consumer<StockHistoryViewModel>(builder: (context, value, child){
          if(StockSelHistoryViewModelDataState.Idle == value.selhisstate){
            return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 3.0),
                    SizedBox(height: 3.0),
                    Text(language.text('pw'), style: TextStyle(color: Colors.black, fontSize: 16))
                  ],
                )
            );
          }
          else if(StockSelHistoryViewModelDataState.Finished == value.selhisstate){
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 1 Item Detail
                    Consumer<StockHistoryViewModel>(builder: (context, value, child){
                      if(StockHistoryItemlistViewModelDataState.Idle == value.selItemhisstate){
                        return SizedBox();
                      }
                      else if(StockHistoryItemlistViewModelDataState.Finished == value.selItemhisstate){
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      value.itemdetailData[0].shortname == null ? Text("${language.text('railname')} : NA", style: TextStyle(color: Colors.white)) : Text("${language.text('railname')} : ${value.itemdetailData[0].shortname}", style: TextStyle(color: Colors.white)),
                                      Expanded(child: Text(language.text('historysheet'), textAlign: TextAlign.center,   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                                      value.itemdetailData[0].dt1 == null ? Text("${language.text('date')} : NA", style: TextStyle(color: Colors.white)) : Text("${language.text('date')} : ${value.itemdetailData[0].dt1.toString().split(" ").first}", style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('plnum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                Text(widget.plNum, style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('oldplnum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].oldplno == null ? Text("NA") : Text(value.itemdetailData[0].oldplno.toString())
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('uniplnum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].uplNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].uplNo.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('uniyn'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].uniyn == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].uniyn.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('sec'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].purSec == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].purSec.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('file'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].fileSrNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].fileSrNo.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('cp'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].cpMm == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].cpMm.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('srs'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].srsMm == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].srsMm.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('vitsaf'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].vs == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) :
                                                Text(value.itemdetailData[0].vs.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('abc'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].abcCat == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].abcCat.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('pasnct'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].pam == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].pam.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('mustchg'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].mustchg == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].mustchg.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('self'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].shelf == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].shelf.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('source'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].source == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].source.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('unfrly'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].rlyname == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) :
                                                Text(value.itemdetailData[0].rlyname.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('wtkg'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.itemdetailData[0].weightKg == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].weightKg.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(language.text('desc'), textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                  SizedBox(height: 4.0),
                                                  value.itemdetailData[0].des == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : ReadMoreText(value.itemdetailData[0].des.toString().trim(),
                                                      trimLines: 4,
                                                      colorClickableText: Colors.red[300],
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: '... More',
                                                      trimExpandedText: '...less',  style: TextStyle(color: Colors.black, fontSize: 14))
                                                  //value.itemdetailData[0].des == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.itemdetailData[0].des.toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      else if(StockHistoryItemlistViewModelDataState.NoData == value.selItemhisstate){
                        return SizedBox();
                        // return Container(
                        //     height: size.height,
                        //     child: Center(child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Container(
                        //             height: 85,
                        //             width: 85,
                        //             child: Image.asset('assets/no_data.png')
                        //         ),
                        //         Text(language.text('dnf'), style: TextStyle(color: Colors.black, fontSize: 16))
                        //       ],
                        //     ))
                        // );
                      }
                      return SizedBox();
                    }),

                    // 2 Consumption Detail
                    Consumer<StockHistoryViewModel>(builder: (context, value, child){
                      if(StockSelHistoryConsumptionViewModelDataState.Idle == value.selConsumptionhisstate){
                        return SizedBox();
                      }
                      else if(StockSelHistoryConsumptionViewModelDataState.Finished == value.selConsumptionhisstate){
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: Text(language.text('sacdetails'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                SizedBox(height: 5.0),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(language.text('totconhed'), textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 18, fontWeight: FontWeight.w400)),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment : CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${language.text('year')} (${getPreviousYears(2)})", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    value.totyr1920 == 0 ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.totyr1920.toString().split(".").first, style: TextStyle(color: Colors.black, fontSize: 14))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment : CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${language.text('year')} (${getPreviousYears(1)})", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    value.totyr2021 == 0 ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.totyr2021.toString().split(".").first, style: TextStyle(color: Colors.black, fontSize: 14))
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment : CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${language.text('year')} (${getPreviousYears(0)})", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    value.totyr2122 == 0 ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 14)) : Text(value.totyr2122.toString().split(".").first, style: TextStyle(color: Colors.black, fontSize: 14))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment : CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${language.text('year')} (${getPreviousYears(-1)})", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
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
                                                  crossAxisAlignment : CrossAxisAlignment.start,
                                                  children: [
                                                    Text(language.text('aacncp'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    value.accncpvalue == 0 ? Text("0", style: TextStyle(color: Colors.blue, fontSize: 14)) : Text("${value.accncpvalue.toString().split(".").first} (Cat-10, MDP)", style: TextStyle(color: Colors.blue, fontSize: 14))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment : CrossAxisAlignment.start,
                                                  children: [
                                                    Text(language.text('stockmonth'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                    SizedBox(height: 4.0),
                                                    value.stockvalue == 0 ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 14)) : Text("${value.stockvalue.toString().split(".").first} (${value.monthvalue.toStringAsFixed(1)} months)", style: TextStyle(color: Colors.red, fontSize: 14))
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
                                                return Row(
                                                  children: [
                                                    Flexible(
                                                        flex: 7,
                                                        child: Text(language.text('viewconsumption'), textAlign: TextAlign.start, maxLines: 3, style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500))
                                                    ),
                                                    Flexible(
                                                        flex: 1,
                                                        child: InkWell(
                                                          onTap: (){
                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockConsumptionDetailScreen()));
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            width: 40,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(20),
                                                                color: value.getChangeColorValue == false ? Colors.blue.shade300 : Colors.red.shade300
                                                            ),
                                                            child: Icon(Icons.arrow_forward, color: Colors.white),
                                                          ),
                                                        ))
                                                  ],
                                                );
                                            }),

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
                                    ])
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }),

                    // 3 Total Available Detail
                    Consumer<StockHistoryViewModel>(builder: (context, value, child){
                      if(StockSelHistoryAvailableViewModelDataState.Idle == value.selAvailablehisstate){
                        return SizedBox();
                      }
                      else if(StockSelHistoryAvailableViewModelDataState.Finished == value.selAvailablehisstate){
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  //height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: Text(language.text('totalavl'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                SizedBox(height: 5.0),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Table(
                                          defaultColumnWidth: FixedColumnWidth(size.width/2.3),
                                          border: TableBorder.all(
                                              color: Colors.black,
                                              style: BorderStyle.solid,
                                              width: 1),
                                          children: [
                                            TableRow( children: [
                                              Column(children:[Text('Stock Qty', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500))]),
                                              Column(children:[Text('Stock Value', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500))]),
                                            ]),
                                            for(var item in value.availablestockData) TableRow(
                                                children: [
                                                  Text(item.totalStock.toString().trim(),textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0)),
                                                  Text(item.totalValue.toString().trim(), textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0))
                                                  // Column(
                                                  //     crossAxisAlignment: CrossAxisAlignment.center,
                                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                                  //     children:[
                                                  //       Text(item.totalStock.toString(),textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0))
                                                  //     ]),
                                                  // Column(children:[Text(item.totalValue.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0))]),
                                                ]
                                            )
                                          ],
                                        ),
                                      ),
                                    ])
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }),

                    // 4 UnCovered Due Details
                    Consumer<StockHistoryViewModel>(builder: (context, value, child){
                      if(StockSelHistoryUncoveredViewModelDataState.Idle == value.selUncoveredhisstate){
                        return SizedBox();
                      }
                      else if(StockSelHistoryUncoveredViewModelDataState.Finished == value.selUncoveredhisstate){
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: Text(language.text('uncovereddue'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                SizedBox(height: 5.0),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('depot'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[0].dp == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 16)) : Text("${value.uncoveredData[0].dp.toString()} | ${value.uncoveredData[0].dpnm.toString()}", style: TextStyle(color: Colors.red, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('demandnum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[0].dmdNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[0].dmdNo.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('regdate'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[0].demdt == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[0].demdt.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('dueqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[0].dqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[0].dqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('unit'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[0].unit == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[0].unit.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('type'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[0].dmdtype == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[0].dmdtype.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('filetendernum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[0].tenno == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[0].tenno.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('duedate'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[0].duedate == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[0].duedate.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('remarks'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[0].rem == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[0].rem.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
                                               return Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Flexible(
                                                       flex: 7,
                                                       child: Text(language.text('viewuncovered'), textAlign: TextAlign.start, maxLines: 3, style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500))
                                                   ),
                                                   Flexible(
                                                       flex: 1,
                                                       child: InkWell(
                                                         onTap: (){
                                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => UnCoveredDueDetailsScreen()));
                                                         },
                                                         child: Container(
                                                           height: 40,
                                                           width: 40,
                                                           alignment: Alignment.center,
                                                           decoration: BoxDecoration(
                                                               borderRadius: BorderRadius.circular(20),
                                                               color: value.getChangeColorValue == false ? Colors.blue.shade300 : Colors.red.shade300
                                                           ),
                                                           child: Icon(Icons.arrow_forward, color: Colors.white),
                                                         ),
                                                       ))
                                                 ],
                                               );
                                            })

                                            // Align(
                                            //   alignment: Alignment.topRight,
                                            //   child: InkWell(
                                            //     onTap: (){
                                            //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => UnCoveredDueDetailsScreen()));
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
                                    ])
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }),

                    // 5 Intent Details
                    Consumer<StockHistoryViewModel>(builder: (context, value, child){
                      if(StockSelHistoryIntentViewModelDataState.Idle == value.selIntenthisstate){
                        return SizedBox();
                      }
                      else if(StockSelHistoryIntentViewModelDataState.Finished == value.selIntenthisstate){
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: Text(language.text('intentdetail'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                SizedBox(height: 5.0),
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(language.text('intentnumpur'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[0].poNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                  child: Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("Programme Indent No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text("${value.intentData[0].poNo.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text("dt. ${value.intentData[0].podt.toString()} on ${value.intentData[0].firm.toString()} for CP-START ${value.intentData[0].cpstart.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                    ],
                                                  ),
                                                ),
                                                // Row(
                                                //   children: [
                                                //      Text("Programme Indent No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                //      Text("${value.intentData[0].poNo.toString()} ", style: TextStyle(color: Colors.blue.shade200, fontSize: 16, decoration: TextDecoration.underline)),
                                                //      Text("dt. ${value.intentData[0].podt.toString()} on ${value.intentData[0].firm.toString()} for CP-START ${value.intentData[0].cpstart.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                //   ],
                                                // )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('sr'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[0].poSr == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.intentData[0].poSr.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('depot'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[0].dp == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 16)) :
                                                Text("${ value.intentData[0].dp.toString()}", style: TextStyle(color: Colors.red, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('indqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[0].poqty  == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.intentData[0].poqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('unit'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[0].unit == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.intentData[0].unit.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('cvdqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[0].cvdqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.intentData[0].cvdqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('delydt'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[0].dd == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${ value.intentData[0].dd.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('dueqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[0].dueqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.intentData[0].dueqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
                                               return Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Flexible(
                                                       flex: 7,
                                                       child: Text(language.text('viewintent'), textAlign: TextAlign.start, maxLines: 3, style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500))
                                                   ),
                                                   Flexible(
                                                       flex: 1,
                                                       child: InkWell(
                                                         onTap: (){
                                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => IntentDetailScreen()));
                                                         },
                                                         child: Container(
                                                           height: 40,
                                                           width: 40,
                                                           alignment: Alignment.center,
                                                           decoration: BoxDecoration(
                                                               borderRadius: BorderRadius.circular(20),
                                                               color: value.changeColorValue == false ? Colors.blue.shade300 : Colors.red.shade300
                                                           ),
                                                           child: Icon(Icons.arrow_forward, color: Colors.white),
                                                         ),
                                                       ))
                                                 ],
                                               );
                                            })

                                            // Align(
                                            //   alignment: Alignment.topRight,
                                            //   child: InkWell(
                                            //     onTap: (){
                                            //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => IntentDetailScreen()));
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
                                    ])
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }),

                    // 6 Railway Board Intent Coverage details
                    Consumer<StockHistoryViewModel>(builder: (context, value, child){
                      if(StockSelHistoryRlyBoardIntentViewModelDataState.Idle == value.selRlyBoardIntenthisstate){
                        return SizedBox();
                      }
                      else if(StockSelHistoryRlyBoardIntentViewModelDataState.Finished == value.selRlyBoardIntenthisstate){
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: Text(language.text('rlyboardintent'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                SizedBox(height: 5.0),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(language.text('ponumname'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                SizedBox(height: 4.0),
                                                value.rlyintentData[0].poNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                  child: InkWell(
                                                    onTap: (){
                                                      Navigator.push(context,MaterialPageRoute(builder: (context) => PdfView(value.rlyintentData[0].pdf_link.toString())));
                                                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockPoDetailScreen(filepath: value.rlyintentData[0].pdf_link.toString())));
                                                    },
                                                    child: Wrap(
                                                      alignment: WrapAlignment.start,
                                                      children: <Widget>[
                                                        Text("P.O.No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                        Text("${value.rlyintentData[0].poNo.toString()} ", style: TextStyle(color: Colors.blue.shade200, fontSize: 16, decoration: TextDecoration.underline)),
                                                        getPoDetail(value.rlyintentData[0].podt.toString(), value.rlyintentData[0].firm.toString(), value.rlyintentData[0].pocat.toString()),
                                                        //Text("dt. ${value.rlyintentData[0].podt.toString()} on M/s. ${value.rlyintentData[0].firm.toString()}:[ Reg ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('sr'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[0].poSr == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)):
                                                Text("${value.rlyintentData[0].poSr.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('depot'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[0].dp == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 16)):
                                                Text("${value.rlyintentData[0].dp.toString()}", style: TextStyle(color: Colors.red, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('airate'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[0].aiRate == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)):
                                                Text("${value.rlyintentData[0].aiRate.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('poqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[0].poqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.rlyintentData[0].poqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('unit'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[0].unit == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.rlyintentData[0].unit.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('dueqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[0].dueqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.rlyintentData[0].dueqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('startdp'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[0].ods == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.rlyintentData[0].ods.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('delydt'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[0].dd == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.rlyintentData[0].dd.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('demnum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[0].dmdNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.rlyintentData[0].dmdNo.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
                                               return Row(
                                                 children: [
                                                   Flexible(
                                                       flex: 7,
                                                       child: Text(language.text('viewrlyboard'), textAlign: TextAlign.start, maxLines: 3, style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500))
                                                   ),
                                                   Flexible(
                                                       flex: 1,
                                                       child: InkWell(
                                                         onTap: (){
                                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => RlyBoardIndentScreen()));
                                                         },
                                                         child: Container(
                                                           height: 40,
                                                           width: 40,
                                                           alignment: Alignment.center,
                                                           decoration: BoxDecoration(
                                                               borderRadius: BorderRadius.circular(20),
                                                               color: value.changeColorValue == false ? Colors.blue.shade300 : Colors.red.shade300
                                                           ),
                                                           child: Icon(Icons.arrow_forward, color: Colors.white),
                                                         ),
                                                       ))
                                                 ],
                                               );
                                            })

                                            // Align(
                                            //   alignment: Alignment.topRight,
                                            //   child: InkWell(
                                            //     onTap: (){
                                            //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => RlyBoardIndentScreen()));
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
                                    ])
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }),

                    // 7 Covered Due details
                    Consumer<StockHistoryViewModel>(builder: (context, value, child){
                      if(StockSelHistoryCoveredDueViewModelDataState.Idle == value.selCoveredDuehisstate){
                        return SizedBox();
                      }
                      else if(StockSelHistoryCoveredDueViewModelDataState.Finished == value.selCoveredDuehisstate){
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: Text(language.text('coveredduedetail'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                SizedBox(height: 5.0),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(language.text('ponumname'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                SizedBox(height: 4.0),
                                                value.coveredDueData[0].poNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                  child: InkWell(
                                                    onTap: (){
                                                      Navigator.push(context,MaterialPageRoute(builder: (context) => PdfView(value.coveredDueData[0].pdf_link.toString())));
                                                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockPoDetailScreen(filepath: value.coveredDueData[0].pdf_link.toString())));
                                                    },
                                                    child: Wrap(
                                                      alignment: WrapAlignment.start,
                                                      children: <Widget>[
                                                        Text("P.O.No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                        Text("${value.coveredDueData[0].poNo.toString()} ", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
                                                        getPoDetail(value.coveredDueData[0].podt.toString(), value.coveredDueData[0].firm.toString(), value.coveredDueData[0].pocat.toString().trim())
                                                        //Text("dt. ${value.coveredDueData[0].podt.toString()} on M/s. ${value.coveredDueData[0].firm.toString()} PO-CAT:[ Reg ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                //Text("P.O.No. ${value.coveredDueData[0].poNo.toString()} dt. ${value.coveredDueData[0].podt.toString()} on M/s. ${value.coveredDueData[0].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('sr'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.coveredDueData[0].poSr == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.coveredDueData[0].poSr.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('depot'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.coveredDueData[0].dp == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 16)) :
                                                Text("${value.coveredDueData[0].dp.toString()}", style: TextStyle(color: Colors.red, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('airate'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.coveredDueData[0].aiRate == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.coveredDueData[0].aiRate.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('poqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.coveredDueData[0].poqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.coveredDueData[0].poqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('unit'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.coveredDueData[0].unit == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.coveredDueData[0].unit.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('dueqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.coveredDueData[0].dueqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.coveredDueData[0].dueqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('startdp'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.coveredDueData[0].ods == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.coveredDueData[0].ods.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('delydt'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.coveredDueData[0].dd == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.coveredDueData[0].dd}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('demnum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.coveredDueData[0].dmdNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.coveredDueData[0].dmdNo.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
                                                return Row(
                                                  children: [
                                                    Flexible(
                                                        flex: 7,
                                                        child: Text(language.text('viewcovereddue'), textAlign: TextAlign.start, maxLines: 3, style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500))
                                                    ),
                                                    Flexible(
                                                        flex: 1,
                                                        child: InkWell(
                                                          onTap: (){
                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoveredDueDetailScreen()));
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            width: 40,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(20),
                                                                color: value.changeColorValue == false ? Colors.blue.shade300 : Colors.red.shade300
                                                            ),
                                                            child: Icon(Icons.arrow_forward, color: Colors.white),
                                                          ),
                                                        ))
                                                  ],
                                                );
                                            })

                                            // Align(
                                            //   alignment: Alignment.topRight,
                                            //   child: InkWell(
                                            //     onTap: (){
                                            //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoveredDueDetailScreen()));
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
                                    ])
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }),

                    // 8 Material under accountal detail
                    Consumer<StockHistoryViewModel>(builder: (context, value, child){
                      if(value.selAccountalhisstate == StockSelAccountalViewModelDataState.Idle){
                        return SizedBox();
                      }
                      else if(value.selAccountalhisstate == StockSelAccountalViewModelDataState.Finished){
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: Text(language.text('matunderacc'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                SizedBox(height: 5.0),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('srnum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.underaccountalData[0].dp == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("1", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(language.text('ponumname'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                SizedBox(height: 4.0),
                                                value.underaccountalData[0].poNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                  child: Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("P.O.No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text("${value.underaccountalData[0].poNo.toString()} ", style: TextStyle(fontSize: 16, color: Colors.black)),
                                                      Text("dt. ${value.underaccountalData[0].drrdt.toString()} on M/s. ${value.underaccountalData[0].firm.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(language.text('recieptdet'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                Text("${value.underaccountalData[0].recpt.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
                                               return Row(
                                                 children: [
                                                   Flexible(
                                                       flex: 7,
                                                       child: Text(language.text('viewmaterialunderaccountal'), textAlign: TextAlign.start, maxLines: 3, style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500))
                                                   ),
                                                   Flexible(
                                                       flex: 1,
                                                       child: InkWell(
                                                         onTap: (){
                                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => MeterialUnderAccountalScreen()));
                                                         },
                                                         child: Container(
                                                           height: 40,
                                                           width: 40,
                                                           alignment: Alignment.center,
                                                           decoration: BoxDecoration(
                                                               borderRadius: BorderRadius.circular(20),
                                                               color: value.changeColorValue == false ? Colors.blue.shade300 : Colors.red.shade300
                                                           ),
                                                           child: Icon(Icons.arrow_forward, color: Colors.white),
                                                         ),
                                                       ))
                                                 ],
                                               );
                                            })

                                            // Align(
                                            //   alignment: Alignment.topRight,
                                            //   child: InkWell(
                                            //     onTap: (){
                                            //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => MeterialUnderAccountalScreen()));
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
                                    ])
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }),

                    // 9 Details of Material Rejected
                    Consumer<StockHistoryViewModel>(builder: (context, value, child){
                      if(value.selMatrejhisstate == StockSelMaterialrejViewModelDataState.Idle){
                        return SizedBox();
                      }
                      else if(value.selMatrejhisstate == StockSelMaterialrejViewModelDataState.Finished){
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: Text(language.text('materialrejected'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                SizedBox(height: 5.0),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('srnum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.underaccountalData[0].dp == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.underaccountalData[0].dp.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(language.text('ponumname'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                SizedBox(height: 4.0),
                                                value.materialRejData[0].poNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                  child: Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("P.O.No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      Text("${value.materialRejData[0].poNo.toString()} ", style: TextStyle(fontSize: 16, color: Colors.black)),
                                                      Text("dt. ${value.materialRejData[0].rejdt.toString()} on M/s. ${value.materialRejData[0].firm.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(language.text('rejectdtl'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                Text("${value.materialRejData[0].rejectionDetail.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
                                              return Row(
                                                children: [
                                                  Flexible(
                                                      flex: 7,
                                                      child: Text(language.text('viewmaterialrejected'), textAlign: TextAlign.start, maxLines: 3, style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500))
                                                  ),
                                                  Flexible(
                                                      flex: 1,
                                                      child: InkWell(
                                                        onTap: (){
                                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MaterialRejectedScreen()));
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(20),
                                                              color: value.changeColorValue == false ? Colors.blue.shade300 : Colors.red.shade300
                                                          ),
                                                          child: Icon(Icons.arrow_forward, color: Colors.white),
                                                        ),
                                                      ))
                                                ],
                                              );
                                            })
                                            // Align(
                                            //   alignment: Alignment.topRight,
                                            //   child: InkWell(
                                            //     onTap: (){
                                            //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => MaterialRejectedScreen()));
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
                                    ])
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }),

                    // 10 Order placed last 5 Years
                    Consumer<StockHistoryViewModel>(builder: (context, value, child){
                      if(StockSelHistoryOrderdPlacedViewModelDataState.Idle == value.selOrderPlacedhisstate){
                        return SizedBox();
                      }
                      else if(StockSelHistoryOrderdPlacedViewModelDataState.Finished == value.selOrderPlacedhisstate){
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: Text(language.text('orderlastfiveryears'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                SizedBox(height: 5.0),
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
                                                Text(language.text('ponumname'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                SizedBox(height: 4.0),
                                                value.orderplaceData[0].poNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                  child: InkWell(
                                                    onTap: (){
                                                      Navigator.push(context,MaterialPageRoute(builder: (context) => PdfView(value.orderplaceData[0].pdfLink.toString())));
                                                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockPoDetailScreen(filepath: value.orderplaceData[0].pdfLink.toString())));
                                                    },
                                                    child: Wrap(
                                                      alignment: WrapAlignment.start,
                                                      children: <Widget>[
                                                        Text("P.O.No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                        Text("${value.orderplaceData[0].poNo.toString()} ", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
                                                        getPoDetail(value.orderplaceData[0].podt.toString(), value.orderplaceData[0].firm.toString(), value.orderplaceData[0].pocat.toString().trim())
                                                        //Text("dt. ${value.orderplaceData[0].podt.toString()} on M/s. ${value.orderplaceData[0].firm.toString()}:[ Reg ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // Row(
                                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                                //   mainAxisAlignment: MainAxisAlignment.start,
                                                //   children: [
                                                //     Text("P.O.No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                //     Text("${value.orderplaceData[0].poNo.toString()}", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
                                                //     Flexible(child: Text(" dt. ${value.orderplaceData[0].podt.toString()} on M/s. ${value.orderplaceData[0].firm.toString()}:[ Reg ]", style: TextStyle(color: Colors.black, fontSize: 16)))
                                                //   ],
                                                // )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('sr'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].poSr == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.orderplaceData[0].poSr.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('depot'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].dp == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 16)) :
                                                Text("${value.orderplaceData[0].dp.toString()}", style: TextStyle(color: Colors.red, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('airate'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].aiRate == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.orderplaceData[0].aiRate.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('poqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].poqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.orderplaceData[0].poqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('unit'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].unit == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.orderplaceData[0].unit.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('cancqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].cancqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.orderplaceData[0].cancqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('rejqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].rejqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.orderplaceData[0].rejqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('recqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].supqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.orderplaceData[0].supqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('orgdp'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].odd == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.orderplaceData[0].odd.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('startdp'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].ods == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.orderplaceData[0].ods.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('extdp'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].edd == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.orderplaceData[0].edd.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('postatus'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.orderplaceData[0].status == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.orderplaceData[0].status.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
                                              return Row(
                                                children: [
                                                  Flexible(
                                                      flex: 7,
                                                      child: Text(language.text('vieworderplace'), textAlign: TextAlign.start, maxLines: 3, style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500))
                                                  ),
                                                  Flexible(
                                                      flex: 1,
                                                      child: InkWell(
                                                        onTap: (){
                                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderPlacedScreen()));
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(20),
                                                              color: value.changeColorValue == false ? Colors.blue.shade300 : Colors.red.shade300
                                                          ),
                                                          child: Icon(Icons.arrow_forward, color: Colors.white),
                                                        ),
                                                      ))
                                                ],
                                              );
                                            })
                                            // Align(
                                            //   alignment: Alignment.topRight,
                                            //   child: InkWell(
                                            //     onTap: (){
                                            //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderPlacedScreen()));
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
                                    ])
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }),

                    // 11 Over Stock and Inactive
                    Consumer<StockHistoryViewModel>(builder: (context, value, child){
                      if(StockSelHistoryOverStockViewModelDataState.Idle == value.selOverStockhisstate){
                        return SizedBox();
                      }
                      else if(StockSelHistoryOverStockViewModelDataState.Finished == value.selOverStockhisstate){
                        return Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  //height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: Text(language.text('overstock'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                SizedBox(height: 5.0),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('railname'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.overstockData[0].shortname == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.overstockData[0].shortname.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('depot'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.overstockData[0].dpName == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 16)) :
                                                SizedBox(
                                                    width: size.width/1.8,
                                                    child: Text("${value.overstockData[0].dpName.toString()}", textAlign: TextAlign.end, style: TextStyle(color: Colors.red, fontSize: 16)))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('ward'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.overstockData[0].wd == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.overstockData[0].wd.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('CAT', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.overstockData[0].cat == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.overstockData[0].cat.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('AAC', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.overstockData[0].aac == null ? Text("NA", style: TextStyle(color: Colors.blue, fontSize: 16)) :
                                                Text("${value.overstockData[0].aac.toString()}", style: TextStyle(color: Colors.blue, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('STOCK', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.overstockData[0].stock == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 16)) :
                                                Text("${value.overstockData[0].stock.toString()}", style: TextStyle(color: Colors.red, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('unit'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.overstockData[0].udes == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.overstockData[0].udes.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('CONS 21-22', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.overstockData[0].cyr0 == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.overstockData[0].cyr0.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('CONS 22-23', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.overstockData[0].cyr1 == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.overstockData[0].cyr1.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('LI-DATE', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.overstockData[0].lidt == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.overstockData[0].lidt.toString().split(" ").first}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('CONTACT', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.overstockData[0].phone == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.overstockData[0].phone.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
                                               return Row(
                                                 children: [
                                                   Flexible(
                                                       flex: 7,
                                                       child: Text(language.text('viewoverstock'), textAlign: TextAlign.start, maxLines: 3, style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500))
                                                   ),
                                                   Flexible(
                                                       flex: 1,
                                                       child: InkWell(
                                                           onTap: (){
                                                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => OverStockScreen()));
                                                           },
                                                           child: Container(
                                                             height: 40,
                                                             width: 40,
                                                             alignment: Alignment.center,
                                                             decoration: BoxDecoration(
                                                                 borderRadius: BorderRadius.circular(20),
                                                                 color: value.changeColorValue == false ? Colors.blue.shade300 : Colors.red.shade300
                                                             ),
                                                             child: Icon(Icons.arrow_forward, color: Colors.white),
                                                           ),
                                                       ))
                                                 ],
                                               );
                                            })

                                          ],
                                        ),
                                      ),
                                    ])
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }),

                  ],
                ),
              ),
            );
          }
          else if(StockSelHistoryViewModelDataState.NoData == value.selhisstate){
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
                )
            );
          }
          else if(StockSelHistoryViewModelDataState.ClearData == value.selhisstate){
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
                )
            );
          }
          return SizedBox();
        }),
      ),
    );
  }

  Widget getPoDetail(String podt, String firm, String pocat){
    if(pocat == "R"){
      return  Text("dt. $podt on M/s. $firm PO-CAT:[ Reg ]", style: TextStyle(color: Colors.black, fontSize: 16));
    }
    if(pocat == "RF"){
      return Text("dt. $podt on M/s. $firm PO-CAT:[ Reg-F ]", style: TextStyle(color: Colors.black, fontSize: 16));
    }
    if(pocat == "D"){
      return Text("dt. $podt on M/s. $firm PO-CAT:[ Dev ]", style: TextStyle(color: Colors.black, fontSize: 16));
    }
    if(pocat == "DO"){
      return Text("dt. $podt on M/s. $firm PO-CAT:[ Dev-O ]", style: TextStyle(color: Colors.black, fontSize: 16));
    }
    if(pocat == "DF"){
      return Text("dt. $podt on M/s. $firm PO-CAT:[ Dev-F ]", style: TextStyle(color: Colors.black, fontSize: 16));
    }
    if(pocat == "T"){
      return Text("dt. $podt on M/s. $firm PO-CAT:[ Trail ]", style: TextStyle(color: Colors.black, fontSize: 16));
    }
    else{
      return Text("dt. $podt on M/s. $firm : PO-CAT:[ $pocat ]", style: TextStyle(color: Colors.black, fontSize: 16));
    }
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
