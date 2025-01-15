import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/non_stock_demands/tabs_views/case_tracker_list_screen.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/view_model/StockHistoryViewModel.dart';
import 'package:provider/provider.dart';

class CaseTrackerScreen extends StatefulWidget {
  const CaseTrackerScreen({Key? key}) : super(key: key);

  @override
  State<CaseTrackerScreen> createState() => _CaseTrackerScreenState();
}

class _CaseTrackerScreenState extends State<CaseTrackerScreen> {

  String rlyname = "--Select Railway--";
  String rlycode = "";

  String fromdate = "";
  String todate = "";

  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      Provider.of<StockHistoryViewModel>(context, listen: false)
          .getRailwaylistData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(language.text('dmddtfrom'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                FormBuilderDateTimePicker(
                  name: 'FromDate',
                  initialDate: DateTime.now().subtract(const Duration(days: 182)),
                  initialValue: DateTime.now().subtract(const Duration(days: 182)),
                  inputType: InputType.date,
                  format: DateFormat('dd-MM-yyyy'),
                  onChanged: (datevalue){
                    final DateFormat formatter = DateFormat('dd-MM-yyyy');
                    fromdate = formatter.format(datevalue!);
                    //value.checkdateDiff(fromdate, todate, formatter, context);
                    //_checkdateDiff(formatter.format(value!), todate, formatter);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsetsDirectional.all(10),
                    border: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Text(language.text('dmddtto'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                FormBuilderDateTimePicker(
                  name: 'FromDate',
                  initialDate: DateTime.now().subtract(const Duration(days: 182)),
                  initialValue: DateTime.now().subtract(const Duration(days: 182)),
                  inputType: InputType.date,
                  format: DateFormat('dd-MM-yyyy'),
                  onChanged: (datevalue){
                    final DateFormat formatter = DateFormat('dd-MM-yyyy');
                    fromdate = formatter.format(datevalue!);
                    //value.checkdateDiff(fromdate, todate, formatter, context);
                    //_checkdateDiff(formatter.format(value!), todate, formatter);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsetsDirectional.all(10),
                    border: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Text(language.text('dfctd'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      border: Border.all(color: Colors.grey, width: 1)),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left : 5.0),
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                          hintText: language.text('dfctd')
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(language.text('prorly'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<StockHistoryViewModel>(builder: (context, value, child) {
                  if(value.state == StockHistoryViewModelDataState.Busy) {
                    return Container(
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${language.text('selectrly')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                            Container(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ))
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: DropdownSearch<String>(
                        //mode: Mode.DIALOG,
                        //showSelectedItem: true,
                        //autoFocusSearchBox: true,
                        //showSearchBox: true,
                        //hint: language.text('selectrly'),
                        //showFavoriteItems: true,
                        popupProps: PopupPropsMultiSelection.menu(
                          showSearchBox: true,
                          title: Text(language.text('selectrly')),
                          fit: FlexFit.loose,
                          showSelectedItems: true,
                          menuProps: MenuProps(
                              shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.grey), // You can customize the border color
                              )
                          ),
                        ),
                        // favoriteItems: (val) {
                        //   return [rlyname];
                        // },
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(left: 10))
                        ),
                        // dropdownSearchDecoration: InputDecoration(
                        //     enabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //         borderSide: BorderSide.none),
                        //     contentPadding: EdgeInsets.only(left: 10)),
                        // items: value.rlylistData.map((item) {
                        //   return DropdownMenuItem(
                        //       child: Text(item.value.toString()),
                        //       value: item.intcode.toString());
                        // }).toList(),
                        items: (filter, infiniteScrollProps) => value.rlylistData.map((e) {
                          return e.value.toString();
                        }).toList(),
                        // items: value.rlylistData.map((e) {
                        //   return e.value.toString();
                        // }).toList(),
                        onChanged: (changedata) {
                          rlyname = changedata.toString();
                          value.rlylistData.forEach((element) {
                            if(changedata.toString() == element.value.toString()){
                              rlycode = element.intcode.toString();
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 20),
                SizedBox(
                  width: size.width,
                  height: 45,
                  child: MaterialButton(
                      child: Text(language.text('proceed'), style: TextStyle(fontSize: 16)),
                      onPressed: (){
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const CaseTrackerDataScreen()),
                    );
                  }, color: Colors.blue, textColor: Colors.white),
                ),
                ]),
        ),
      ),
    );
  }
}
