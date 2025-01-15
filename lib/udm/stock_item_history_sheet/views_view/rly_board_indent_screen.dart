import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/change_visibility_provider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/view_model/StockHistoryViewModel.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views/stock_po_detail_screen.dart';
import 'package:provider/provider.dart';

class RlyBoardIndentScreen extends StatefulWidget {
  const RlyBoardIndentScreen({Key? key}) : super(key: key);

  @override
  State<RlyBoardIndentScreen> createState() => _RlyBoardIndentScreenState();
}

class _RlyBoardIndentScreenState extends State<RlyBoardIndentScreen> {

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
        title : Text(language.text('rlyboardintent'), style: TextStyle(color: Colors.white)),
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
            if(StockSelHistoryRlyBoardIntentViewModelDataState.Idle == value.selRlyBoardIntenthisstate){
              return SizedBox();
            }
            else if(StockSelHistoryRlyBoardIntentViewModelDataState.Finished == value.selRlyBoardIntenthisstate){
              return ListView.builder(
                  itemCount: value.rlyintentData.length,
                  padding: EdgeInsets.all(5),
                  controller: listScrollController,
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
                                //   child: Text(language.text('rlyboardintent'), style: TextStyle(color: Colors.white, fontSize: 16)),
                                //),
                                SizedBox(height: 8.0),
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
                                                value.rlyintentData[index].poNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: size.width * 0.9),
                                                  child: InkWell(
                                                    onTap: (){
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockPoDetailScreen(filepath: value.rlyintentData[index].pdf_link.toString())));
                                                    },
                                                    child: Wrap(
                                                      alignment: WrapAlignment.start,
                                                      children: <Widget>[
                                                        Text("P.O.No. ", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                        Text("${value.rlyintentData[index].poNo.toString()} ", style: TextStyle(color: Colors.blue.shade200, fontSize: 16, decoration: TextDecoration.underline)),
                                                        getPoDetail(value.rlyintentData[index].podt.toString(), value.rlyintentData[index].firm.toString(), value.rlyintentData[index].pocat.toString().trim())
                                                        //Text("dt. ${value.rlyintentData[index].podt.toString()} on M/s. ${value.rlyintentData[index].firm.toString()}:[ Reg ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                //Text("P.O.No. ${value.rlyintentData[index].poNo.toString()} dt. ${value.rlyintentData[index].podt.toString()} on M/s. ${value.rlyintentData[index].firm.toString()}:[ Reg ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('sr'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[index].poSr == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.rlyintentData[index].poSr.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('depot'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[index].dp == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 16)) :
                                                Text("${value.rlyintentData[index].dp.toString()}", style: TextStyle(color: Colors.red, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('airate'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[index].aiRate == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.rlyintentData[index].aiRate.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('poqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[index].poqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.rlyintentData[index].poqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('unit'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[0].unit == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.rlyintentData[0].unit.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('dueqty'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[index].dueqty == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.rlyintentData[index].dueqty.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('startdp'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[index].ods == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.rlyintentData[index].ods.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('delydt'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[index].dd == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.rlyintentData[index].dd.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.text('demnum'), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                                                value.rlyintentData[index].dmdNo == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) :
                                                Text("${value.rlyintentData[index].dmdNo.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
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
                  }
              );
            }
            return SizedBox();
          }),
        ),
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
}
