
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/provider/search.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/view/warranty_details_linkScreen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../provider/uiProvider.dart';
import '../view_model/WarrantyCompaint_ViewModel.dart';

class WarrantyDeatilsScreen extends StatefulWidget {
   String rlyCode ;
   String consigneecode ;
   String rlycode1 ;
   String consigneecode1 ;
   String complaintsourcecode ;
   String fromdate ;
   String todate ;
   WarrantyDeatilsScreen(this.rlyCode, this.consigneecode,this.rlycode1, this.consigneecode1, this.complaintsourcecode,this.fromdate,this.todate);

  @override
  State<WarrantyDeatilsScreen> createState() => _WarrantyDeatilsScreenState();
}

class _WarrantyDeatilsScreenState extends State<WarrantyDeatilsScreen> {

  ScrollController listScrollController = ScrollController();
  final _textsearchController = TextEditingController();


  onWillPop() {
    bool check = Provider.of<UiProvider>(context, listen: false).getScrollValue;
    if(check == true) {
      return true;
    } else {
      return true;
    }
  }

  @override
  void initState() {
  //  listScrollController.addListener(_onScrollEvent);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<WarrantyComplaintViewModel>(context, listen: false).getLevelCountData(widget.rlyCode, widget.consigneecode, widget.rlycode1, widget.consigneecode1,widget.complaintsourcecode, widget.fromdate,widget.todate, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _normalTextStyle = TextStyle(
      color: Colors.deepOrangeAccent,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    final updatechangeprovider = Provider.of<SearchWarrantyComplaint>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        automaticallyImplyLeading: false,
        title: Consumer<SearchWarrantyComplaint>(
            builder: (context, value, child) {
              if(value.getrwadSearchValue) {
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
                            Provider.of<WarrantyComplaintViewModel>(context, listen: false).searchingDataLevelCount(_textsearchController.text.trim(), context);
                          },
                        ),
                        hintText: language.text('search'),
                        border: InputBorder.none),
                    onChanged: (query) {
                      Provider.of<WarrantyComplaintViewModel>(context, listen: false).searchingDataLevelCount(_textsearchController.text.trim(), context);
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
                    Text(language.text('warrantycom'), maxLines: 1, style: TextStyle(color: Colors.white))
                  ],
                );
              }
            }),
        actions: [
          Consumer<SearchWarrantyComplaint>(builder: (context, value, child){
            if(value.getrwadSearchValue){
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
        child: Consumer<WarrantyComplaintViewModel>(builder: (context, value, child){
          if(LevelCountDataState.Busy == value.levelCountstate){
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
                itemCount: value.levelCountlistData.length,
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
                                                child: Text(language.text('compsource'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(alignment: Alignment.centerRight,
                                                  child: value.levelCountlistData[index].compsource == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("${value.levelCountlistData[index].compsource.toString()} ", style: _normalTextStyle),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(language.text('rlgencomplaint'), maxLines: 2, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500))),
                                              /*   Expanded(
                                                flex: 1,
                                                child: Text(language.text('rlgencomplaint'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              ),*/
                                              Expanded(
                                                flex: 1,
                                                child: Align(alignment: Alignment.centerRight,
                                                  child: value.levelCountlistData[index].rlygencomplaint == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("${value.levelCountlistData[index].rlygencomplaint.toString()} ", style: _normalTextStyle),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              //Text(language.text('rlyvendor'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              Expanded(
                                                flex: 1,
                                                child: Text(language.text('rlyvendor'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(alignment: Alignment.centerRight,
                                                  child: value.levelCountlistData[index].rlylodgecliam == null ? Text("NA", style: TextStyle(color: Colors.black, fontSize: 16)) : Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      Text("${value.levelCountlistData[index].rlylodgecliam.toString()} ", style: _normalTextStyle),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(language.text('total'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(alignment: Alignment.centerRight,
                                                  child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: ZoomTapAnimation(
                                                        onTap: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Warranty_Details_linkScreen(value.levelCountlistData[index].rlygencomplaintcode.toString(), widget.consigneecode,value.levelCountlistData[index].rlylodgeclaimcode.toString(), widget.consigneecode1,value.levelCountlistData[index].compsource.toString(),widget.fromdate, widget.todate,"")));
                                                        },
                                                        child: BlinkText(value.levelCountlistData[index].total .toString(),
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red[500],), textAlign: TextAlign.center, beginColor: Colors.red[500], endColor: Colors.blueAccent, times: 500, duration: Duration(seconds: 2)
                                                        ),
                                                      )
                                                  ),   ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(language.text('lodgevendor'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(alignment: Alignment.centerRight,
                                                  child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: ZoomTapAnimation(
                                                        onTap: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Warranty_Details_linkScreen(value.levelCountlistData[index].rlygencomplaintcode.toString(), widget.consigneecode,value.levelCountlistData[index].rlylodgeclaimcode.toString(), widget.consigneecode1,value.levelCountlistData[index].compsource.toString(),widget.fromdate, widget.todate,"CF")));
                                                        },
                                                        child: BlinkText(value.levelCountlistData[index].claimlodgedvendor .toString(),
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red[500],), textAlign: TextAlign.center, beginColor: Colors.red[500], endColor: Colors.blueAccent, times: 500, duration: Duration(seconds: 2)
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(language.text('initiatedvendor'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(alignment: Alignment.centerRight,
                                                  child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: ZoomTapAnimation(
                                                        onTap: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Warranty_Details_linkScreen(value.levelCountlistData[index].rlygencomplaintcode.toString(), widget.consigneecode,value.levelCountlistData[index].rlylodgeclaimcode.toString(), widget.consigneecode1,value.levelCountlistData[index].compsource.toString(),widget.fromdate, widget.todate,"CI")));
                                                        },
                                                        child: BlinkText(value.levelCountlistData[index].claiminitiatedvendor .toString(),
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red[500],), textAlign: TextAlign.center, beginColor: Colors.red[500], endColor: Colors.blueAccent, times: 500, duration: Duration(seconds: 2)
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(language.text('retmaintapp'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              /*  Expanded(
                                                flex: 1,
                                                child: Text(language.text('retmaintapp'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              ),*/
                                              Expanded(
                                                flex: 1,
                                                child: Align(alignment: Alignment.centerRight,
                                                  child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: ZoomTapAnimation(
                                                        onTap: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Warranty_Details_linkScreen(value.levelCountlistData[index].rlygencomplaintcode.toString(), widget.consigneecode,value.levelCountlistData[index].rlylodgeclaimcode.toString(), widget.consigneecode1,value.levelCountlistData[index].compsource.toString(),widget.fromdate, widget.todate,"RT")));
                                                        },
                                                        child: BlinkText(value.levelCountlistData[index].complaintreturned .toString(),
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red[500],), textAlign: TextAlign.center, beginColor: Colors.red[500], endColor: Colors.blueAccent, times: 500, duration: Duration(seconds: 2)
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(language.text('apvvendor'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(alignment: Alignment.centerRight,
                                                  child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: ZoomTapAnimation(
                                                        onTap: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Warranty_Details_linkScreen(value.levelCountlistData[index].rlygencomplaintcode.toString(), widget.consigneecode,value.levelCountlistData[index].rlylodgeclaimcode.toString(), widget.consigneecode1,value.levelCountlistData[index].compsource.toString(),widget.fromdate, widget.todate,"AF")));
                                                        },
                                                        child: BlinkText(value.levelCountlistData[index].advicenoteinitiated .toString(),
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red[500],), textAlign: TextAlign.center, beginColor: Colors.red[500], endColor: Colors.blueAccent, times: 500, duration: Duration(seconds: 2)
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(language.text('initiatedvendor'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(alignment: Alignment.centerRight,
                                                  child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: ZoomTapAnimation(
                                                        onTap: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Warranty_Details_linkScreen(value.levelCountlistData[index].rlygencomplaintcode.toString(), widget.consigneecode,value.levelCountlistData[index].rlylodgeclaimcode.toString(), widget.consigneecode1,value.levelCountlistData[index].compsource.toString(),widget.fromdate, widget.todate,"AI")));
                                                        },
                                                        child: BlinkText(value.levelCountlistData[index].advicenotefinalized .toString(),
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red[500],), textAlign: TextAlign.center, beginColor: Colors.red[500], endColor: Colors.blueAccent, times: 500, duration: Duration(seconds: 2)
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(language.text('returnedvendor'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(alignment: Alignment.centerRight,
                                                  child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: ZoomTapAnimation(
                                                        onTap: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Warranty_Details_linkScreen(value.levelCountlistData[index].rlygencomplaintcode.toString(), widget.consigneecode,value.levelCountlistData[index].rlylodgeclaimcode.toString(), widget.consigneecode1,value.levelCountlistData[index].compsource.toString(),widget.fromdate, widget.todate,"RD")));
                                                        },
                                                        child: BlinkText(value.levelCountlistData[index].advicenotereturned .toString(),
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red[500],), textAlign: TextAlign.center, beginColor: Colors.red[500], endColor: Colors.blueAccent, times: 500, duration: Duration(seconds: 2)
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(language.text('actioninitiated'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              /* Expanded(
                                                child: Text(language.text('actioninitiated'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                              ),*/
                                              Expanded(
                                                flex: 1,
                                                child: Align(alignment: Alignment.centerRight,
                                                  child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: ZoomTapAnimation(
                                                        onTap: (){
                                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => Warranty_Details_linkScreen("01", widget.consigneecode,widget.rlycode1, widget.consigneecode1,  widget.complaintsourcecode,widget.fromdate, widget.todate,"XX")));
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Warranty_Details_linkScreen(value.levelCountlistData[index].rlygencomplaintcode.toString(), widget.consigneecode,value.levelCountlistData[index].rlylodgeclaimcode.toString(), widget.consigneecode1,value.levelCountlistData[index].compsource.toString(),widget.fromdate, widget.todate,"XX")));
                                                        },
                                                        child: BlinkText(value.levelCountlistData[index].actionpending .toString(),
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red[500],), textAlign: TextAlign.center, beginColor: Colors.red[500], endColor: Colors.blueAccent, times: 500, duration: Duration(seconds: 2)
                                                        ),
                                                      )
                                                  ),
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
    );
  }
}
