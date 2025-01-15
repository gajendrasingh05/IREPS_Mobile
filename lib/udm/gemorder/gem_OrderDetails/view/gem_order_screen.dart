import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/gemorder/gem_OrderDetails/providers/gemscreen_update_changes.dart';
import 'package:flutter_app/udm/gemorder/gem_OrderDetails/view/gemOrderdetailsScreen.dart';
import 'package:flutter_app/udm/gemorder/gem_OrderDetails/view_model/gemViewModel1.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class GemOrderScreen extends StatefulWidget {
  static const routeName = "/Gemorder-screen";

  @override
  State<GemOrderScreen> createState() => _GemOrderScreenState();
}

class _GemOrderScreenState extends State<GemOrderScreen> {

  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();

  final _textsearchController = TextEditingController(text: 'GEMC-5116877');

  final orderID = TextEditingController(text: 'GEMC-5116877');
  String? co6number;
  String? pokey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    final updatechangeprovider = Provider.of<GemOrderupdateChangesScreenProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<GemOrderViewModel>(context, listen: false).clearOnBack(context);
        return Future<bool>.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Consumer<GemOrderupdateChangesScreenProvider>(
                builder: (context, value, child) {
                  if (value.getSearchValue) {
                    return SizedBox();
                  } else {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /*InkWell(
                          onTap: () {
                            updatechangeprovider.updateScreen(true);
                          },
                          child: Icon(Icons.search, color: Colors.white),
                        ),*/
                        PopupMenuButton<String>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'clear',
                              child: Text(language.text('clear'),
                                  style: TextStyle(color: Colors.black)),
                            ),
                            PopupMenuItem(
                              value: 'exit',
                              child: Text(language.text('exit'),
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                          color: Colors.white,
                          onSelected: (value) {
                            if(value == 'clear') {
                              Provider.of<GemOrderViewModel>(context, listen: false).clearAllData(context);
                            } else if (value == 'exit') {
                              Navigator.pop(context);
                            }
                          },
                        )
                      ],
                    );
                  }
                })
          ],
          title: Consumer<GemOrderupdateChangesScreenProvider>(
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
                              Future.delayed(const Duration(seconds: 1), () {
                                Provider.of<GemOrderViewModel>(context, listen: false).searchingData(_textsearchController.text, context);
                              });
                            },
                          ),
                          hintText: language.text('search'),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none),
                      onChanged: (query) {
                        Future.delayed(const Duration(seconds: 1), () {
                          Provider.of<GemOrderViewModel>(context, listen: false).searchingData(query, context);
                        });
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
                            Provider.of<GemOrderViewModel>(context, listen: false).clearOnBack(context).then((value) =>  Navigator.pop(context));
                          },
                          child: Icon(Icons.arrow_back, color: Colors.white)),
                      SizedBox(width: 10),
                      Container(child:
                        Text(language.text('gemorderdtl'),style: TextStyle(color: Colors.white)),
                      )
                    ],
                  );
                }
              }),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text(language.text("gemorderno"),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  SizedBox(height: 12),
                  Column(
                    children: [
                      TextField(
                        // controller: TextEditingController(text:"GEMC-511687702"),
                        controller: orderID,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Colors.black)),
                          focusedBorder:  OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Colors.black)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Colors.black)),
                          errorBorder:  OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Colors.black)),
                          disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Colors.black)),
                          //hintText: language.text('gemhint'),
                        ),
                      ),
                      SizedBox(height: 18),
                      InkWell(
                        onTap:() {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if(orderID.text == null || orderID.text.isEmpty) {
                            UdmUtilities.showWarningFlushBar(context, language.text('oredrid'));
                            return;
                          }
                          else {
                            Provider.of<GemOrderViewModel>(context, listen: false).getBuyerDetailsData(orderID.text.toString(), context);
                          }
                          if(orderID.text == null || orderID.text.isEmpty) {
                            UdmUtilities.showWarningFlushBar(context, language.text('oredrid'));
                            return;
                          }
                          else {
                            Provider.of<GemOrderViewModel>(context, listen: false).getGemOrderDetailsData(orderID.text.toString(), context);
                          }
                          if(orderID.text == null || orderID.text.isEmpty) {
                            UdmUtilities.showWarningFlushBar(context, language.text('oredrid'));
                            return;
                          }
                          else {
                            Provider.of<GemOrderViewModel>(context, listen: false).getConsigneeDetailsData(orderID.text.toString(), context);
                          }
                          if(orderID.text == null || orderID.text.isEmpty) {
                            UdmUtilities.showWarningFlushBar(context, language.text('oredrid'));
                            return;
                          }
                          else {
                            Provider.of<GemOrderViewModel>(context, listen: false).getGemAccountalDetailsData(orderID.text.toString(), context);
                          }
                          if(orderID.text == null || orderID.text.isEmpty) {
                            UdmUtilities.showWarningFlushBar(context, language.text('oredrid'));
                            return;
                          }
                          else {
                            Provider.of<GemOrderViewModel>(context, listen: false).getGemBillDetailsData(orderID.text.toString(), context);
                          }
                          if(orderID.text == null || orderID.text.isEmpty) {
                            UdmUtilities.showWarningFlushBar(context, language.text('oredrid'));
                            return;
                          }
                          else {
                            Provider.of<GemOrderViewModel>(context, listen: false).getDeductionDetailsData(Provider.of<GemOrderViewModel>(context, listen: false).co6number, context);
                          }
                          if(orderID.text == null || orderID.text.isEmpty) {
                            UdmUtilities.showWarningFlushBar(context, language.text('oredrid'));
                            return;
                          }
                          else {
                            Provider.of<GemOrderViewModel>(context, listen: false).getCoveringPODetailsData(Provider.of<GemOrderViewModel>(context, listen: false).pokey.toString(), context);
                          }
                        },
                        child: Container(
                          width: size.width * 0.30,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.red[300], borderRadius: BorderRadius.all(Radius.circular(8.0))),
                          child: Text(language.text('search1'), style: TextStyle(color: Colors.white, fontSize: 17.5)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Consumer<GemOrderViewModel>(builder: (context, value, child){
                    if(value.buyerstate == BuyerDetailsDataState.Idle){
                      return Expanded(child: Center(
                        child: Container(
                            height: 85,
                            width: 85,
                            child: Image.asset('assets/no_data.png')
                        ),
                      ));
                    }
                    else if(value.buyerstate == BuyerDetailsDataState.Busy){
                      return Expanded(child: Center(
                        child: CircularProgressIndicator(strokeWidth: 4.0),
                      ));
                    }
                    else if(value.buyerstate == BuyerDetailsDataState.FinishedWithError){
                      return Expanded(child: Center(
                        child: Column(
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
                      ));
                    }
                    else if(value.buyerstate == BuyerDetailsDataState.NoData){
                      return Expanded(child: Center(
                        child: Column(
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
                      ));
                    }
                    else{
                      return Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: value.buyerDetailsData.length,
                          // shrinkWrap: true,
                          //physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: size.height,
                              width: size.width,
                              child: Consumer<GemOrderViewModel>(builder: (context, value, child){
                                if(BuyerDetailsDataState.Idle == value.buyerstate){
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
                                if(BuyerDetailsDataState.Finished == value.buyerstate){
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          // 1 Buyer details
                                          Consumer<GemOrderViewModel>(builder: (context, value, child){
                                            if(BuyerDetailsDataState.Idle == value.buyerstate){
                                              return SizedBox();
                                            }
                                            else if(BuyerDetailsDataState.Finished == value.buyerstate){
                                              return Card(
                                                elevation: 8.0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                                child: Container(
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
                                                            color: Colors.red[300]
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Align( alignment: Alignment.center,
                                                              child: Text(language.text('buyerdetails'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17,)),
                                                            )
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
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('org'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.buyerDetailsData[index].organisation ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('buyername'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.buyerDetailsData[index].buyername ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('buyeradrs'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(child: ReadMoreText(
                                                                      value.buyerDetailsData[index].buyeraddress ?? "NA",
                                                                      style: TextStyle(
                                                                          color: Colors.grey[600],
                                                                          fontSize: 14, fontWeight: FontWeight.w500
                                                                      ),
                                                                      trimLines: 2,
                                                                      colorClickableText: Colors.red[300],
                                                                      trimMode: TrimMode.Line,
                                                                      trimCollapsedText: ' ...${language.text('more')}',
                                                                      trimExpandedText: ' ...${language.text('less')}',
                                                                      delimiter: '',
                                                                    )),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('mobno'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.buyerDetailsData[index].buyermobile ?? "NA", style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                      ),

                                                    ],
                                                  ),

                                                ),


                                              );
                                            }
                                            else if(BuyerDetailsDataState.NoData == value.buyerstate) {
                                              return SizedBox();
                                            }
                                            return SizedBox();
                                          }),

                                          SizedBox(height: 10,),

                                          // 2 gem order Detail
                                          Consumer<GemOrderViewModel>(builder: (context, value, child){
                                            if(GemOderderDeatilsDataState.Idle == value.gemOrderstate){
                                              return SizedBox();
                                            }
                                            else if(GemOderderDeatilsDataState.Finished == value.gemOrderstate){
                                              return Card(
                                                elevation: 8.0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                                child: Container(
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
                                                            color: Colors.red[300]
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Align( alignment: Alignment.center,
                                                              child: Text(language.text('gemorderdetails'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17,)),
                                                            )
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
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('ordernodate'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
// categoriesText?.elementAt(0) ?? ""
                                                                        child: Text(value.gemOrderDetailsData[0].gemorderid ??"NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),

                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(language.text('blank'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemOrderDetailsData[index].orderdate ??"NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('venname'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(child:  ReadMoreText(
                                                                      value.gemOrderDetailsData[index].vendordetails ??"NA",
                                                                      style: TextStyle(
                                                                          color: Colors.grey[600],
                                                                          fontSize: 14, fontWeight: FontWeight.w500
                                                                      ),
                                                                      trimLines: 2,
                                                                      colorClickableText: Colors.red[300],
                                                                      trimMode: TrimMode.Line,
                                                                      trimCollapsedText:
                                                                      ' ...${language.text('more')}',
                                                                      trimExpandedText:
                                                                      ' ...${language.text('less')}',
                                                                      delimiter: '',
                                                                    )),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('venpangstn'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemOrderDetailsData[index].vendorpan ??"NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(language.text('blank'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemOrderDetailsData[index].vendorgstn ??"NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('noofitem'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemOrderDetailsData[index].numberofitem ??"NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('orderamt'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemOrderDetailsData[index].orderamount ??"NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('aucode'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemOrderDetailsData[index].aucode ??"NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('accountingunit'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemOrderDetailsData[index].accountingunit ??"NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('paymentmode'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemOrderDetailsData[index].paymentmode ??"NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),

                                                      ),

                                                    ],
                                                  ),

                                                ),


                                              );
                                            }
                                            return SizedBox();
                                          }),

                                          SizedBox(height: 10,),

                                          // 3 consignee  Detail data
                                          Consumer<GemOrderViewModel>(builder: (context, value, child){
                                            if(ConsigneeDeatilsDataState.Idle == value.consigneestate){
                                              return SizedBox();
                                            }
                                            else if(ConsigneeDeatilsDataState.Finished == value.consigneestate){
                                              return Card(
                                                elevation: 8.0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                                child: Container(
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
                                                            color: Colors.red[300]
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Align( alignment: Alignment.center,
                                                              child: Text(language.text('consdetails'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17,)),
                                                            )
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
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('sno'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.consigneeDetailsData[index].prodsn ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('consname'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.consigneeDetailsData[index].consigneename ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('consadd'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(child:  ReadMoreText(
                                                                      value.consigneeDetailsData[index].consaddress ?? "NA",
                                                                      style: TextStyle(
                                                                          color: Colors.grey[600],
                                                                          fontSize: 14, fontWeight: FontWeight.w500
                                                                      ),
                                                                      trimLines: 2,
                                                                      colorClickableText: Colors.red[300],
                                                                      trimMode: TrimMode.Line,
                                                                      trimCollapsedText:
                                                                      ' ...${language.text('more')}',
                                                                      trimExpandedText:
                                                                      ' ...${language.text('less')}',
                                                                      delimiter: '',
                                                                    )),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('mobno'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.consigneeDetailsData[index].consmobile ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Align(
                                                                  alignment: Alignment.center,
                                                                  child: Text(language.text('itemdtls'),
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                        color: Colors.red[300],
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 16,
                                                                      )
                                                                  ),
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('sino'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.consigneeDetailsData[index].slno ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('des'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(child:  ReadMoreText(
                                                                      value.consigneeDetailsData[index].itemdescription ?? "NA",
                                                                      style: TextStyle(
                                                                          color: Colors.grey[600],
                                                                          fontSize: 14, fontWeight: FontWeight.w500
                                                                      ),
                                                                      trimLines: 2,
                                                                      colorClickableText: Colors.red[300],
                                                                      trimMode: TrimMode.Line,
                                                                      trimCollapsedText:
                                                                      ' ...${language.text('more')}',
                                                                      trimExpandedText:
                                                                      ' ...${language.text('less')}',
                                                                      delimiter: '',
                                                                    )),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('qty'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.consigneeDetailsData[index].qty.toString() +" "+ value.consigneeDetailsData[index].unit.toString(),
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),

                                                      ),

                                                    ],
                                                  ),

                                                ),


                                              );
                                            }
                                            return SizedBox();
                                          }),

                                          SizedBox(height: 10,),

                                          // 4 Covering PO Details
                                          Consumer<GemOrderViewModel>(builder: (context, value, child){
                                            if(CoveringPoDeatilsDataState.Idle == value.coveringstate){
                                              return SizedBox();
                                            }
                                            else if(CoveringPoDeatilsDataState.Finished == value.coveringstate){
                                              return Card(
                                                elevation: 8.0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                                child: Container(
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
                                                            color: Colors.red[300]
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Align( alignment: Alignment.center,
                                                              child: Text(language.text('covpodtls'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17,)),
                                                            )
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
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('pono'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.coveringPODetailsData[index].pono.toString(),
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('podate'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.coveringPODetailsData[index].podate.toString(),
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('venname'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.coveringPODetailsData[index].vendorname.toString(),
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('povalue'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.coveringPODetailsData[index].povalue.toString(),
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('payauth'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),

                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.coveringPODetailsData[index].payauthname.toString(),
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ]),

                                                      ),

                                                    ],
                                                  ),

                                                ),


                                              );
                                            }
                                            return SizedBox();
                                          }),

                                          SizedBox(height: 10,),

                                          // 5 Gem Accountal Details
                                          Consumer<GemOrderViewModel>(builder: (context, value, child){
                                            if(GemAccountailsDetailsDataState.Idle == value.gemAccountalstate){
                                              return SizedBox();
                                            }
                                            else if(GemAccountailsDetailsDataState.Finished == value.gemAccountalstate){
                                              return Card(
                                                elevation: 8.0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                                child: Container(
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
                                                            color: Colors.red[300]
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Align( alignment: Alignment.center,
                                                              child: Text(language.text('matrecaccdtls'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17,)),
                                                            )
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
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('cons'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].userdepotname ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('dmtrrecnodate'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].dmtrno ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('dmtrdate'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].receiptdate ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('doctype1'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].doctype ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('blank'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].rnoteno ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('blank'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].rnotedate ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('ronodate'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].rono ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('blank'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].rodate ?? "NA",
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('dispqty'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].qtydispatched ?? "NA" +" "+value.gemAccountalDetailsData[index].unitgem.toString(),
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('receqty'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].qtyreceived ?? "NA" +" "+value.gemAccountalDetailsData[index].unitgem.toString(),
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('accptqty'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].qtyaccepted ?? "NA" +" "+value.gemAccountalDetailsData[index].unitgem.toString(),
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:Text(language.text('rejecqty'),style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(value.gemAccountalDetailsData[index].qtyrejected ?? "NA" +" "+value.gemAccountalDetailsData[index].unitgem.toString(),
                                                                            style:TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),

                                                      ),

                                                    ],
                                                  ),

                                                ),


                                              );
                                            }
                                            return SizedBox();
                                          }),

                                          SizedBox(height: 10,),

                                          // 7 deduction details
                                          Consumer<GemOrderViewModel>(builder: (context, value, child){
                                            if(DeductionDetailsDataState.Idle == value.deductionstate){
                                              return SizedBox();
                                            }
                                            else if(DeductionDetailsDataState.Finished == value.deductionstate){
                                              return Card(
                                                elevation: 8.0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                                child: Container(
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
                                                            color: Colors.red[300]
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Align( alignment: Alignment.center,
                                                              child: Text(language.text('dedamtdtls'), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17,)),
                                                            )
                                                          ],
                                                        ),
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
                                                                    Column(children:[Text(language.text('dtlsded'), style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500))]),
                                                                    Column(children:[Text(language.text('amtsr'), style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500))]),
                                                                  ]),
                                                                  for(var item in value.deductionDetailsData) TableRow(
                                                                      children: [
                                                                        Text(item.recovdesc.toString().trim(),textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0)),
                                                                        Text(value.deductionDetailsData[index].recovamt.toString().trim(), textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0))
                                                                      ]
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ])
                                                      ),
                                                      SizedBox(height: 5.0),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                            return SizedBox();
                                          }),

                                          SizedBox(height: 10,),
                                          Column(
                                            children: [
                                              ZoomTapAnimation(
                                                onTap: (){
                                                  setState(() {
                                                    var gemOrderViewModel =
                                                    Provider.of<GemOrderViewModel>(context, listen: false);
                                                    Navigator.of(context)
                                                        .pushNamed(GeMBillDetailsScreen.routeName);
                                                    gemOrderViewModel.getGemBillDetailsData(
                                                        orderID.text.toString(),
                                                        context);
                                                  });
                                                },
                                                child: BlinkText(
                                                    language.text('dedhead'),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.red[500],
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    beginColor: Colors.red[500],
                                                    endColor: Colors.blueAccent,
                                                    times: 500,
                                                    duration: Duration(seconds: 2)
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 300),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox();
                              }),
                            );
                          },
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

