import 'package:flutter/cupertino.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/new_posearch_recipt/receipt_model.dart';
import 'package:flutter_app/udm/new_posearch_recipt/receipt_provider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';

import '../widgets/search_app_bar.dart';

class Receipt_Screen extends StatefulWidget {
  static const routeName = "/Receipt_Screen-screen";
  @override
  State<Receipt_Screen> createState() => _Receipt_ScreenState();
}

class _Receipt_ScreenState extends State<Receipt_Screen> {
  late ReceiptProvider receiptProvider;

  @override
  void initState() {
    receiptProvider = Provider.of<ReceiptProvider>(context, listen: false);
    FeatureDiscovery.hasPreviouslyCompleted(context, 'JumpButton')
        .then((value) {
      if (value == true) {
        setState(() {
          _isDiscovering = false;
        });
      }
    });
    super.initState();
  }

  bool _isScrolling = false;
  bool _showFAB = false;
  bool _isInit = true;
  bool _isDiscovering = true;
  var totalValue = 0.0;
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
        appBar: SearchAppbar(
          title: language.text('receipt'),
          labelData: 'ReciptDetailsScreen',
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Consumer<ReceiptProvider>(builder: (_, ReceiptProvider, __) {
            if(ReceiptProvider.state == ReceiptState.Busy) {return Center(child: CircularProgressIndicator());}
            else if(ReceiptProvider.state == ReceiptState.FinishedWithError) {
              Future.delayed(
                  Duration.zero, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 3),
                    content: Text(
                      ReceiptProvider.error!.description.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )));
              return Container();
            }
            else if (ReceiptProvider.state == ReceiptState.Finished) {
              Future.delayed(Duration.zero, () {
                if(_isInit) {
                  setState(() {
                    _showFAB = receiptProvider.poSearchList!.length > 20;
                    _isScrolling = false;
                  });
                }
              }).then((value) async {
                if(_isInit)
                  FeatureDiscovery.discoverFeatures(context, {'JumpButton'});
                _isInit = false;
              });
              return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotif) {
                    if (scrollNotif is ScrollStartNotification ||
                        scrollNotif is ScrollUpdateNotification) {
                      setState(() {
                        _isScrolling = true;
                      });
                    }
                    if (scrollNotif is ScrollEndNotification) {
                      setState(() {
                        _isScrolling = false;
                      });
                    }
                    return false;
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2.1,
                              child: Column(
                                children: [
                                  Text(
                                    language.text('totalCount'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.deepOrangeAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  IRUDMConstants.resultCount(
                                      receiptProvider.countData, true),
                                ],
                              ),
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height / 15,
                                child: VerticalDivider(color: Colors.grey)),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.1,
                              child: Column(
                                children: [
                                  Text(language.text('tqdisp'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 3),
                                  Text(
                                    _totalQtyDispatched(ReceiptProvider.poSearchList!).toString()+" "+ReceiptProvider.poSearchList![0].unitname.toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(height: 3, color: Colors.grey),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2.1,
                              child: Column(
                                children: [
                                  Text(language.text('tqr'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 3),
                                  Text(_totalQtyReceived(ReceiptProvider.poSearchList!).toString()+" "+ReceiptProvider.poSearchList![0].unitname.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height / 15,
                                child: VerticalDivider(color: Colors.grey)),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.1,
                              child: Column(
                                children: [
                                  Text(language.text('tqa'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    _totalQtyAccepted(ReceiptProvider.poSearchList!).toString()+" "+ReceiptProvider.poSearchList![0].unitname.toString(),
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(height: 3, color: Colors.grey),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2.1,
                              child: Column(
                                children: [
                                  Text(language.text('tqrj'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    _totalQtyRejected(ReceiptProvider.poSearchList!).toString()+" "+ReceiptProvider.poSearchList![0].unitname.toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height / 15,
                                child: VerticalDivider(color: Colors.grey)),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.1,
                              child: Column(
                                children: [
                                  Text(language.text('twr'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 3),
                                  Text(_totalWarRejected(ReceiptProvider.poSearchList!).toString()+" "+ReceiptProvider.poSearchList![0].unitname.toString(), style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(height: 12, color: Colors.grey),
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(language.text('reinspectioninit'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.deepOrangeAccent,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 3),
                                Text(_InitialRejected(ReceiptProvider.poSearchList!).toString()+" "+ReceiptProvider.poSearchList![0].unitname.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 12, color: Colors.grey),
                      Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(language.text('reinspectionwarr'),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.deepOrangeAccent,
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(height: 3),
                            Text(
                                _WarrantyRejected(ReceiptProvider.poSearchList!)
                                    .toString()+" "+ReceiptProvider.poSearchList![0].unitname.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Divider(height: 12, color: Colors.grey),
                      Expanded(child: ListView.builder(
                          controller: _scrollController,
                          itemCount: ReceiptProvider.poSearchList!.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (_, i) {
                            return ProductBox(
                              item: ReceiptProvider.poSearchList![i],
                              index: i,
                            );
                          })
                      )
                    ],
                  )
              );
            }
            else {
              return SizedBox();
            }
          }),
        )
    );
  }

  _totalQtyDispatched(List<ReceiptModel> list) {
    totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].qtydispatched != 'NA' || list[i].qtydispatched != null) {
        try {
          totalValue = totalValue + double.parse(list[i].qtydispatched!);
          assert(totalValue is double);
        } catch (e) {
          print(e);
        }
      }
    }
    return totalValue.toStringAsFixed(2);
  }

  _totalQtyReceived(List<ReceiptModel> list) {
    totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].qtyreceived != 'NA' || list[i].qtyreceived != null) {
        try {
          totalValue = totalValue + double.parse(list[i].qtyreceived!);
          assert(totalValue is double);
        } catch (e) {
          print(e);
        }
      }
    }
    return totalValue.toStringAsFixed(2);
  }

  _totalQtyAccepted(List<ReceiptModel> list) {
    totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].qtyaccepted != 'NA' || list[i].qtyaccepted != null) {
        try {
          totalValue = totalValue + double.parse(list[i].qtyaccepted!);
          assert(totalValue is double);
        } catch (e) {
          print(e);
        }
      }
    }
    return totalValue.toStringAsFixed(2);
  }

  _totalQtyRejected(List<ReceiptModel> list) {
    totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].qtyrejected != 'NA' || list[i].qtyrejected != null) {
        try {
          totalValue = totalValue + double.parse(list[i].qtyrejected!);
          assert(totalValue is double);
        } catch (e) {
          print(e);
        }
      }
    }
    return totalValue.toStringAsFixed(2);
  }

  _totalWarRejected(List<ReceiptModel> list) {
    totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if(list[i].warrepflag != 'NA' || list[i].warrepflag != null) {
        try {
          totalValue = totalValue + double.parse(list[i].warrepflag!);
          assert(totalValue is double);
        } catch (e) {
          print(e);
        }
      }
    }
    return totalValue.toStringAsFixed(2);
  }

  _InitialRejected(List<ReceiptModel> list) {
    totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].rejtranskey != 'NA' || list[i].rejtranskey != null) {
        try {
          totalValue = totalValue + double.parse(list[i].rejtranskey!);
          assert(totalValue is double);
        } catch (e) {
          print(e);
        }
      }
    }
    return totalValue.toStringAsFixed(2);
  }

  _WarrantyRejected(List<ReceiptModel> list) {
    totalValue = 0.0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].warrepflag != 'NA' || list[i].warrepflag != null) {
        try {
          totalValue = totalValue + double.parse(list[i].warrepflag!);
          assert(totalValue is double);
        } catch (e) {
          print(e);
        }
      }
    }
    return totalValue.toStringAsFixed(2);
  }
}

class ProductBox extends StatelessWidget {
  final ReceiptModel? item;
  final int? index;
  const ProductBox({this.item, this.index});

  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Container(
        padding: EdgeInsets.only(left: 0, top: 9, right: 2, bottom: 9),
        child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10, left: 8),
                child: Text(
                  (index! + 1).toString() + '.',
                  softWrap: false,
                  style: TextStyle(fontSize: 14, color: Colors.indigo[800]),
                ),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 0, top: 5, right: 0, bottom: 10),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      language.text('DMTR No. & Date'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      item!.voucherno! + " " + item!.transdate!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      language.text('Challan No. & Date'),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800]
                                          //fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      item!.challanno!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      language.text('chDate'),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800]
                                          //fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      item!.challandate!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      language.text('Make / Brand'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.indigo[800],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        item!.curmakebrand ?? "NA",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ))
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('Product Sr. No.'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        item!.curproductsrno == null || item!.curproductsrno.toString() == "null"
                                            ? "NA"
                                            : item!.curproductsrno.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('Warranty upto'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: item!.expirtydate == "null" ||
                                              item!.expirtydate == null
                                          ? Text("NA")
                                          : Text(
                                              item!.expirtydate.toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('Qty. Dispatched'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                        alignment: Alignment(-3.1, 0.0),
                                        child: item!.qtydispatched == "null" ||
                                                item!.qtydispatched == null
                                            ? Text("NA")
                                            : Text(
                                                item!.qtydispatched.toString() +
                                                    " ${item!.unitname}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('QtyReceived'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                        alignment: Alignment(-3.1, 0.0),
                                        child: item!.qtyreceived == "null" ||
                                                item!.qtyreceived == null
                                            ? Text("NA")
                                            : Text(
                                                item!.qtyreceived.toString() +
                                                    " ${item!.unitname}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('Qty. Accepted'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                        alignment: Alignment(-3.1, 0.0),
                                        child: item!.qtyaccepted == "null" ||
                                                item!.qtyaccepted == null
                                            ? Text("NA")
                                            : Text(
                                                item!.qtyaccepted.toString() +
                                                    " ${item!.unitname}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('Initial Rejection'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: item!.rejtranskey == "null" ||
                                              item!.rejtranskey == null
                                          ? Text("NA")
                                          : Text(
                                              item!.rejtranskey.toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('Warranty Rejection'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                          //fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: item!.warrepflag == "null" ||
                                              item!.warrepflag == null
                                          ? Text("NA")
                                          : Text(
                                              item!.warrepflag.toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('Re-Insp. Qty'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: item!.reinspflag == "null" ||
                                              item!.reinspflag == null
                                          ? Text("NA")
                                          : Text(
                                              item!.reinspflag.toString() +
                                                  " ${item!.unitname}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('Returned Qty. to Vendor'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: item!.rejind == "null" ||
                                              item!.rejind == null
                                          ? Text("NA")
                                          : Text(
                                              item!.rejind.toString() +
                                                  " ${item!.unitname}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('Qty. taken into Ledger'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                        alignment: Alignment(-2.3, 0.0),
                                        child: item!.trqty == "null" ||
                                                item!.trqty == null
                                            ? Text("NA")
                                            : Text(
                                                item!.trqty.toString() +
                                                    " ${item!.unitname}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        language.text('Transaction Status'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.indigo[800],
                                        ),
                                      )
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: item!.transstatus == "null" ||
                                        item!.transstatus == null
                                        ? Text("NA")
                                        : Text(trnstatus(item!.transstatus.toString()),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ))))
            ])));
  }

  String trnstatus(String trn){
     if(trn == "UA"){
       return "Under Process";
     }
     else if(trn == "RN"){
       return "Accepted (Under Accountal)";
     }
     else if(trn == "RO"){
       return "Accounted For";
     }
     else if(trn == "RJ"){
       return "Full Consignment Rejected";
     }
     else if(trn == "WR"){
       return "Warranty Replacement";
     }
     else if(trn == "All"){
       return "All";
     }
     else{
       return "";
     }
  }
}
