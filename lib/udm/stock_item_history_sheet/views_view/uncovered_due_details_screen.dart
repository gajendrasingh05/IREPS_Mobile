import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/change_visibility_provider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/view_model/StockHistoryViewModel.dart';
import 'package:provider/provider.dart';

class UnCoveredDueDetailsScreen extends StatefulWidget {
  const UnCoveredDueDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UnCoveredDueDetailsScreen> createState() => _UnCoveredDueDetailsScreenState();
}

class _UnCoveredDueDetailsScreenState extends State<UnCoveredDueDetailsScreen> {

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
        title : Text(language.text('uncovereddue'), style: TextStyle(color: Colors.white)),
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
                  child: value.getScrollValue == false ? Icon(Icons.arrow_downward, color: Colors.white) : Icon(Icons.arrow_upward,color: Colors.white),
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
            if(StockSelHistoryUncoveredViewModelDataState.Idle == value.selUncoveredhisstate){
              return SizedBox();
            }
            else if(StockSelHistoryUncoveredViewModelDataState.Finished == value.selUncoveredhisstate){
              return ListView.builder(
                  itemCount: value.uncoveredData.length,
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
                                //   child: Text(language.text('uncovereddue'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                // ),
                                SizedBox(height: 8.0),
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
                                                value.uncoveredData[index].dp == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 16)) :
                                                Text("${value.uncoveredData[index].dp.toString()} | ${value.uncoveredData[index].dpnm.toString()}", style: TextStyle(color: Colors.red, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('demandnum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[index].dmdNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[index].dmdNo.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('regdate'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[index].demdt == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[index].demdt.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('dueqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[index].dqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[index].dqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('unit'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[index].unit == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[index].unit.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('type'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[index].dmdtype == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[index].dmdtype.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('filetendernum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[index].tenno == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[index].tenno.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('duedate'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[index].duedate == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[index].duedate.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('remarks'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.uncoveredData[index].rem == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("${value.uncoveredData[index].rem.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
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
