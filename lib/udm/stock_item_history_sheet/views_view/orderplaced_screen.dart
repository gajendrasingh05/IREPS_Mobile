import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/change_visibility_provider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/view_model/StockHistoryViewModel.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views/stock_po_detail_screen.dart';
import 'package:provider/provider.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({Key? key}) : super(key: key);

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {

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
         title : Text(language.text('orderlastfiveryears'), style: TextStyle(color: Colors.white)),
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
                     child: value.getScrollValue == false ? Icon(Icons.arrow_downward,color: Colors.white) : Icon(Icons.arrow_upward,color: Colors.white),
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
              if(value.selOrderPlacedhisstate == StockSelHistoryOrderdPlacedViewModelDataState.Idle){
                 return SizedBox();
              }
              else if(value.selOrderPlacedhisstate == StockSelHistoryOrderdPlacedViewModelDataState.Finished){
                 return ListView.builder(
                     itemCount: value.orderplaceData.length,
                     controller: listScrollController,

                     padding: EdgeInsets.all(5),
                     shrinkWrap: true,
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
                                   //   child: Text(language.text('orderlastfiveryears'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                   // ),
                                   SizedBox(height: 7.0),
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
                                                   value.orderplaceData[index].poNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   ConstrainedBox(
                                                     constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                     child: InkWell(
                                                       onTap: (){
                                                         Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockPoDetailScreen(filepath: value.orderplaceData[index].pdfLink.toString())));
                                                       },
                                                       child: Wrap(
                                                         alignment: WrapAlignment.start,
                                                         children: <Widget>[
                                                           Text("P.O.No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                           Text("${value.orderplaceData[index].poNo.toString()} ", style: TextStyle(fontSize: 16, color: Colors.blue.shade200, decoration: TextDecoration.underline)),
                                                           getOrderPlacedPoDetail(value.orderplaceData[index].podt.toString(), value.orderplaceData[index].firm.toString(), value.orderplaceData[index].pocat.toString()),
                                                           //value.orderplaceData[index].pocat.toString().trim == "R" ?
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                   //Text("P.O.No. ${value.orderplaceData[index].poNo.toString()} dt. ${value.orderplaceData[index].podt.toString()} on M/s. ${value.orderplaceData[index].firm.toString()}:[ Reg ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('sr'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].poSr == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].poSr.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('depot'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].dp == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].dp.toString()}", style: TextStyle(color: Colors.red, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('airate'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].aiRate == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].aiRate.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('poqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].poqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].poqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('unit'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].unit == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].unit.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('cancqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].cancqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].cancqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('rejqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].rejqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].rejqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('recqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].supqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].supqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('orgdp'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].odd == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].odd.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('startdp'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].ods == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].ods.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('extdp'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].edd == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].edd.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(language.text('postatus'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                   value.orderplaceData[index].status == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                   Text("${value.orderplaceData[index].status.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                 ],
                                               ),
                                               // SizedBox(height: 10),
                                               // Align(
                                               //   alignment: Alignment.topRight,
                                               //   child: InkWell(
                                               //     onTap: (){
                                               //       //Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen()));
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

  Widget getOrderPlacedPoDetail(String podt, String firm, String pocat){
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
}
