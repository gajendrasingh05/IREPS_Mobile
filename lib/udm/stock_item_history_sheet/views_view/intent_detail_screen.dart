import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/change_visibility_provider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/view_model/StockHistoryViewModel.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views/stock_po_detail_screen.dart';
import 'package:provider/provider.dart';

class IntentDetailScreen extends StatefulWidget {
  const IntentDetailScreen({Key? key}) : super(key: key);

  @override
  State<IntentDetailScreen> createState() => _IntentDetailScreenState();
}

class _IntentDetailScreenState extends State<IntentDetailScreen> {

  ScrollController listScrollController = ScrollController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    if(extentAfter > listScrollController.position.maxScrollExtent/3){
      Provider.of<ChangeVisibilityProvider>(context, listen: false).setScrollValue(true);
    }
    else{
      Provider.of<ChangeVisibilityProvider>(context, listen: false).setScrollValue(false);
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
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        iconTheme: IconThemeData(color: Colors.white),
        title : Text(language.text('intentdetail'), style: TextStyle(color: Colors.white)),
        actions: [
          Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
            return InkWell(
              onTap: (){
                if(listScrollController.hasClients){
                  if(value.getScrollValue == false){
                    final position = listScrollController.position.maxScrollExtent;
                    listScrollController.jumpTo(position);
                    value.setScrollValue(true);
                  }
                  else{
                    final position = listScrollController.position.minScrollExtent;
                    listScrollController.jumpTo(position);
                    value.setScrollValue(false);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: value.getScrollValue == false ? Icon(Icons.arrow_downward, color: Colors.white) : Icon(Icons.arrow_upward, color: Colors.white),
                ),
              ),
            );
          })
        ],
      ),
      body: WillPopScope(
        onWillPop: () async{
          bool backStatus = onWillPop();
          if(backStatus){
            Navigator.pop(context);
          }
          return false;
        },
        child: Container(
          height: size.height,
          width: size.width,
          child: Consumer<StockHistoryViewModel>(builder: (context, value, child){
            if(StockSelHistoryIntentViewModelDataState.Idle == value.selIntenthisstate){
              return SizedBox();
            }
            else if(StockSelHistoryIntentViewModelDataState.Finished == value.selIntenthisstate){
              return ListView.builder(
                  itemCount: value.intentData.length,
                  padding: EdgeInsets.all(5),
                  shrinkWrap: true,
                  controller: listScrollController,
                  itemBuilder: (BuildContext context, int index){
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
                                //   child: Text(language.text('intentdetail'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                // ),
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(language.text('intentnumpur'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[index].poNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                  child: InkWell(
                                                    onTap: (){
                                                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockPoDetailScreen(filepath: value.intentData[index].pdf_link.toString())));
                                                    },
                                                    child: Wrap(
                                                      alignment: WrapAlignment.start,
                                                      children: <Widget>[
                                                        Text("Programme Indent No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                        Text("${value.intentData[index].poNo.toString()} ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                        Text("dt. ${value.intentData[index].podt.toString()} on ${value.intentData[index].firm.toString()} for CP-START ${value.intentData[index].cpstart.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // Row(
                                                //   children: [
                                                //     Text("Programme Indent No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                //     Text("${value.intentData[index].poNo.toString()}", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
                                                //     Text(" dt. ${value.intentData[index].podt.toString()} on ${value.intentData[index].firm.toString()} for CP-START ${value.intentData[index].cpstart.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                //   ],
                                                // )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('sr'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[index].poSr == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.intentData[index].poSr.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('depot'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[index].dp == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 16)) :
                                                Text("${ value.intentData[index].dp.toString()}", style: TextStyle(color: Colors.red, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('indqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[index].poqty  == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.intentData[index].poqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('unit'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[index].unit == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.intentData[index].unit.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('cvdqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[index].cvdqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.intentData[index].cvdqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('delydt'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[index].dd == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.intentData[index].dd.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('dueqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.intentData[index].dueqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.intentData[index].dueqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            // SizedBox(height: 10),
                                            // Align(
                                            //   alignment: Alignment.topRight,
                                            //   child: Container(
                                            //     height: 40,
                                            //     width: 40,
                                            //     alignment: Alignment.center,
                                            //     decoration: BoxDecoration(
                                            //         borderRadius: BorderRadius.circular(20),
                                            //         color: Colors.blue
                                            //     ),
                                            //     child: Icon(Icons.arrow_forward, color: Colors.white),
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
                  }
              );
            }
            return SizedBox();
          }),
        ),
      ),
    );
  }
}
