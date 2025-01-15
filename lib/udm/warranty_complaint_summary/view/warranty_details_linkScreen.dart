
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/provider/search.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

import '../view_model/WarrantyCompaint_ViewModel.dart';

class Warranty_Details_linkScreen extends StatefulWidget {
  final String rlycode;
  final String consigneecode;
  final String rlycode1;
  final String consigneecode1;
  final String complaintsourcecode;
  final String fromdate;
  final String todate;
  final String query;
  Warranty_Details_linkScreen(this.rlycode, this.consigneecode,this.rlycode1, this.consigneecode1, this.complaintsourcecode,this.fromdate,this.todate,this.query);

  @override
  State<Warranty_Details_linkScreen> createState() => _Warranty_Details_linkScreenState();
}

class _Warranty_Details_linkScreenState extends State<Warranty_Details_linkScreen> {
  ScrollController listScrollController = ScrollController();
  final _textsearchController = TextEditingController();


  @override
  void initState() {
    //  listScrollController.addListener(_onScrollEvent);
    super.initState();
    print("complaint code ${widget.rlycode}");
    print("consignee code ${widget.consigneecode}");
    print("railway code ${widget.rlycode1}");
    print("consigeen1 code ${widget.consigneecode1}");
    print("consigneesource code ${widget.complaintsourcecode}");
    print("from datwe ${widget.fromdate}");
    print("to date  ${widget.todate}");
    print("Query  ${widget.query}");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<WarrantyComplaintViewModel>(context, listen: false).getPopupFuncData('Pop_up_functionality',widget.rlycode, widget.consigneecode, widget.rlycode1, widget.consigneecode1,widget.complaintsourcecode, widget.fromdate,widget.todate,widget.query, context);
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _cardTextStyle = TextStyle(
      color: Colors.indigo[900],
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          automaticallyImplyLeading: false,
          title: Consumer<SearchWarrantyComplaint>(
              builder: (context, value, child) {
                if (value.getrwadSearchValue == true) {
                  return Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextField(
                        cursorColor: Colors.red[300],
                        controller: _textsearchController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.red[300]),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear, color: Colors.red[300]),
                              onPressed: () {
                                Provider.of<SearchWarrantyComplaint>(context, listen: false).updateScreen(false);
                                _textsearchController.text = "";
                                Provider.of<WarrantyComplaintViewModel>(context, listen: false).searchingPopUpFunc(_textsearchController.text.trim(), context);
                              },
                            ),
                            hintText: language.text('search'),
                            border: InputBorder.none),
                        onChanged: (query) {
                          Provider.of<WarrantyComplaintViewModel>(context, listen: false).searchingPopUpFunc(_textsearchController.text.trim(), context);

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
                            //Navigator.popAndPushNamed(context, UserHomeScreen.routeName);
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.white)),
                      SizedBox(width: 10),
                      Container(
                        child:
                        Text(language.text('warrantycom')),
                      )
                    ],
                  );
                }
              }),
          actions: [
            Consumer<SearchWarrantyComplaint>(
                builder: (context, value, child) {
                  if (value.getrwadSearchValue == true) {
                    return SizedBox();
                  } else {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<SearchWarrantyComplaint>(context, listen: false).updateScreen(true);
                          },
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                        PopupMenuButton<String>(
                          itemBuilder: (context) => [
                            /*PopupMenuItem(
                              value: 'refresh',
                              child: Text(language.text('refresh'),
                                  style: TextStyle(color: Colors.black)),
                            ),*/
                            PopupMenuItem(
                              value: 'exit',
                              child: Text(language.text('exit'),
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                          color: Colors.white,
                          onSelected: (value) {
                            if (value == 'refresh') {

                            } else {
                              Navigator.pop(context);
                            }
                          },
                        )
                      ],
                    );
                  }
                })
          ],
        ),
        /* floatingActionButton: Consumer<ChangeNSDScrollVisibilityProvider>(
            builder: (context, value, child) {
              if (value.getRWADCUiShowScroll == true) {
                return Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21.5),
                      color: Colors.blue),
                  child: FloatingActionButton(
                      onPressed: () {
                        if (listScrollController.hasClients) {
                          if (value.getRWADCUiScrollValue == false) {
                            final position =
                                listScrollController.position.maxScrollExtent;
                            listScrollController.jumpTo(position);
                            value.setRWADCScrollValue(true);
                          } else {
                            final position =
                                listScrollController.position.minScrollExtent;
                            listScrollController.jumpTo(position);
                            value.setRWADCScrollValue(false);
                          }
                        }
                      },
                      child: value.getRWADCUiScrollValue == true
                          ? Icon(Icons.arrow_upward, color: Colors.white)
                          : Icon(Icons.arrow_downward_rounded,
                          color: Colors.white)),
                );
              } else {
                return SizedBox();
              }
            }),*/
        body: Container(
          height: size.height,
          width: size.width,
          child: Consumer<WarrantyComplaintViewModel>(builder: (context, value, child){
            if (value.levelCountstate == LevelCountDataState.Busy){
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
            else if(LevelCountDataState.Finished == value.levelCountstate){
              return ListView.builder(
                  itemCount: value.popfunclistData.length,
                  padding: EdgeInsets.all(5),
                  shrinkWrap: true,
                  controller: listScrollController,
                  itemBuilder: (context, index){
                    return Stack(
                      children: [
                        Card(
                          color: const Color(0xFFFDEDDE),
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(
                                color: Colors.red.shade300,
                                width: 1.0,
                              )
                          ),
                          child: Container(
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(language.text('source'), style: _cardTextStyle,),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(alignment: Alignment.centerLeft,
                                                      child: Text("${value.popfunclistData[index].compsource.toString()== "null" ? ("NA") : (value.popfunclistData[index].compsource.toString())}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('complaintrailway'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child:
                                                      Text(
                                                          "${value.popfunclistData[index].comprly.toString() == "null" ? ("NA") :(value.popfunclistData[index].comprly.toString())}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('complaintconsginee'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          "${value.popfunclistData[index].conscoderejdatasendor.toString()}/${value.popfunclistData[index].compconsignee.toString().trim()}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('railwaylodgeclaim'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          "${value.popfunclistData[index].claimrly.toString()== "null" ? ("NA") :(value.popfunclistData[index].claimrly.toString())}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('consgineelodgeclaim'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          "${value.popfunclistData[index].claimconscode.toString()}/${value.popfunclistData[index].claimconsignee.toString().trim()}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('rejection'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          "${value.popfunclistData[index].rejrefno.toString()}  /  ${value.popfunclistData[index].rejdate.toString().trim()}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('plno'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          "${value.popfunclistData[index].plno.toString()== "null" ? ("NA") :(value.popfunclistData[index].plno.toString())}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('item'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 5),
                                            ReadMoreText(
                                              "${value.popfunclistData[index].itemdesc.toString() == null? Text("NA") :(value.popfunclistData[index].itemdesc.toString())}",
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 16
                                              ),
                                              trimLines: 2,
                                              colorClickableText: Colors.blue[700],
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText:
                                              ' ...${language.text('more')}',
                                              trimExpandedText:
                                              ' ...${language.text('less')}',
                                              delimiter: '',
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('qty'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          "${value.popfunclistData[index].qty.toString()== "null" ? ("NA") :(value.popfunclistData[index].qty.toString())}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('vendor'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          "${value.popfunclistData[index].vendorname.toString()== "null" ? ("NA") :(value.popfunclistData[index].vendorname.toString())}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('status'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          "${value.popfunclistData[index].transstatus.toString()== "null" ? ("NA") : (value.popfunclistData[index].transstatus.toString())}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('claimno'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          "${value.popfunclistData[index].vrno.toString()== "null" ? ("NA") : (value.popfunclistData[index].vrno.toString())}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('claimdate'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          "${value.popfunclistData[index].vrdate.toString()== "null" ? ("NA") : (value.popfunclistData[index].vrdate.toString())}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
                                              ],
                                            ), SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    language.text('claimamount'),
                                                    style: _cardTextStyle,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          "${value.popfunclistData[index].claimamount.toString()== "null" ? ("NA") : (value.popfunclistData[index].claimamount.toString())}",
                                                          style: TextStyle(color: Colors.black, fontSize: 16))
                                                  ),
                                                ),
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
                              backgroundColor: Colors.red[300],
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
            else {
              return SizedBox();
            }
          }),
        ),
      ),
    );
  }
}
