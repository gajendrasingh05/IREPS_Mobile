import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/search_rwfcscreen_provider.dart';
import 'package:provider/provider.dart';

class WarrantyComplaintDataScreen extends StatefulWidget {
  const WarrantyComplaintDataScreen({Key? key}) : super(key: key);

  @override
  State<WarrantyComplaintDataScreen> createState() => _WarrantyComplaintDataScreenState();
}

class _WarrantyComplaintDataScreenState extends State<WarrantyComplaintDataScreen> {

  ScrollController listScrollController = ScrollController();

  final _textsearchController = TextEditingController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    if(extentAfter == listScrollController.position.maxScrollExtent){
      //Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(false);
    }
    else if(extentAfter > listScrollController.position.maxScrollExtent/3){
      //Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(true);
      //Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCScrollValue(true);
    }
    else if(extentAfter > listScrollController.position.maxScrollExtent/5){
     // Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(true);
      //Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCScrollValue(false);
    }
    else{
     // Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(true);
      //Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCScrollValue(false);
    }
  }

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      //Provider.of<RejectionWarrantyViewModel>(context, listen: false).getRWFClaimsData(widget.fromdate, widget.todate, widget.query, context);
    });
  }

  @override
  void dispose() {
    listScrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          automaticallyImplyLeading: false,
          title: Consumer<SearchRWFCScreenProvider>(
              builder: (context, value, child) {
                if(value.getSearchValue == true){
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
                              //Provider.of<SearchRWFCScreenProvider>(context, listen: false).updateScreen(false);
                              _textsearchController.text = "";
                              Future.delayed(const Duration(milliseconds: 400), () {
                                //Provider.of<RejectionWarrantyViewModel>(context, listen: false).searchingRWFCData(_textsearchController.text.toString().trim(), context);
                              });
                            },
                          ),
                          hintText: language.text('search'),
                          border: InputBorder.none),
                      onChanged: (query) {
                        //Provider.of<RejectionWarrantyViewModel>(context, listen: false).searchingRWFCData(_textsearchController.text.toString().trim(), context);
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
                            //Navigator.popAndPushNamed(context, UserHomeScreen.routeName);
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.white)),
                      SizedBox(width: 10),
                      Text(language.text('fwctitle'), maxLines: 1, style: TextStyle(color: Colors.white))
                    ],
                  );
                }
              }),
          actions: [
            // Consumer<SearchRWFCScreenProvider>(builder: (context, value, child){
            //   if(value.getSearchValue == true){
            //     return SizedBox();
            //   }
            //   else {
            //     return Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         InkWell(
            //           onTap: () {
            //             Provider.of<SearchRWFCScreenProvider>(context, listen: false).updateScreen(true);
            //           },
            //           child: Icon(Icons.search, color: Colors.white),
            //         ),
            //         PopupMenuButton<String>(
            //           itemBuilder: (context) => [
            //             PopupMenuItem(
            //               value: 'refresh',
            //               child: Text(language.text('refresh'),
            //                   style: TextStyle(color: Colors.black)),
            //             ),
            //             PopupMenuItem(
            //               value: 'exit',
            //               child: Text(language.text('exit'),
            //                   style: TextStyle(color: Colors.black)),
            //             ),
            //           ],
            //           color: Colors.white,
            //           onSelected: (value) {
            //             if(value == 'refresh') {
            //               //Provider.of<RejectionWarrantyViewModel>(context, listen: false).getRWFClaimsData(widget.fromdate, widget.todate, widget.query, context);
            //             }
            //             else{
            //               Navigator.pop(context);
            //             }
            //           },
            //         )
            //       ],
            //     );
            //   }
            // })
          ],
        ),
      ),
    );
  }
}
