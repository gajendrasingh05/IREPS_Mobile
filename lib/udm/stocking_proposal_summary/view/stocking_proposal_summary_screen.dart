import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/view/stocking_proposal_summary_data_screen.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/view_model/stocking_prosposal_summary_provider.dart';
import 'package:provider/provider.dart';

class StockingProposalSummaryScreen extends StatefulWidget {
  static const routeName = "/stocking-proposal-summary-screen";

  @override
  State<StockingProposalSummaryScreen> createState() => _StockingProposalSummaryScreenState();
}

class _StockingProposalSummaryScreenState extends State<StockingProposalSummaryScreen> with SingleTickerProviderStateMixin{


  String fromdate = "";
  String todate = "";

  ScrollController listScrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    Future.delayed(Duration.zero,() async{
      await getInitData();
    });
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((_) async{
    //      IRUDMConstants.showProgressIndicator(context);
    //      getInitData();
    //      //IRUDMConstants.removeProgressIndicator(context);
    // });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> getInitData() async{
    //IRUDMConstants.showProgressIndicator(context);
    DateTime frdate = DateTime.now().subtract(const Duration(days: 367));
    DateTime tdate = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    fromdate = formatter.format(frdate);
    todate = formatter.format(tdate);
    await Provider.of<StockingProposalSummaryProvider>(context, listen: false).getRailwaylistData(context);
    await Provider.of<StockingProposalSummaryProvider>(context, listen: false).getDepartment("", context);
    await Provider.of<StockingProposalSummaryProvider>(context, listen: false).getUnitInitiatingproposalData("", "", context);
    await Provider.of<StockingProposalSummaryProvider>(context, listen: false).getUnifyingrlyData(context);
    await Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStoresDepotData("", context);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: Text(language.text('stkprptitle'),style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white)
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(language.text('stkprfromdate'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                FormBuilderDateTimePicker(
                  name: 'FromDate',
                  initialDate: DateTime.now().subtract(const Duration(days: 367)),
                  initialValue: DateTime.now().subtract(const Duration(days: 367)),
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
                    suffixIcon: Icon(Icons.calendar_month),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
                    //border: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Text(language.text('stkprtodate'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                FormBuilderDateTimePicker(
                  name: 'ToDate',
                  initialDate: DateTime.now(),
                  initialValue: DateTime.now(),
                  inputType: InputType.date,
                  format: DateFormat('dd-MM-yyyy'),
                  onChanged: (datevalue){
                    final DateFormat formatter = DateFormat('dd-MM-yyyy');
                    todate = formatter.format(datevalue!);
                    //value.checkdateDiff(fromdate, todate, formatter, context);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsetsDirectional.all(10),
                    suffixIcon: Icon(Icons.calendar_month),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
                    //border: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Text(language.text('stksummaryrly'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<StockingProposalSummaryProvider>(builder: (context, value, child) {
                  if(value.rlydatastatus == StksmryrailwayDataState.Busy) {
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
                  }
                  else {
                    return Container(
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: DropdownSearch<String>(
                        //mode: Mode.DIALOG,
                        //showSearchBox: true,
                        //showSelectedItems: true,
                        selectedItem: value.railway,
                        popupProps: PopupPropsMultiSelection.menu(
                          showSearchBox: true,
                          fit: FlexFit.loose,
                          showSelectedItems: true,
                          menuProps: MenuProps(
                              shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.grey), // You can customize the border color
                              )
                          ),
                        ),
                        // popupShape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(5.0),
                        //   side: BorderSide(color: Colors.grey),
                        // ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(left: 10))
                        ),
                        items: (filter, loadProps) => value.railwaylistData.map((e) {
                          return e.value.toString().trim();
                        }).toList(),
                        onChanged: (changedata) {
                          value.railwaylistData.forEach((element) {
                            if(changedata.toString() == element.value.toString()){
                                value.railway = element.value.toString().trim();
                                value.rlyCode = element.intcode.toString();
                                Provider.of<StockingProposalSummaryProvider>(context, listen: false).getDepartment(value.rlyCode!, context);
                                Provider.of<StockingProposalSummaryProvider>(context, listen: false).getUnitInitiatingproposalData(value.rlyCode!, "-1", context);
                                Provider.of<StockingProposalSummaryProvider>(context, listen: false).getUnifyingrlyData(context);
                                Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStoresDepotData(value.rlyCode!, context);
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 10),
                Text(language.text('stksummarydept'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<StockingProposalSummaryProvider>(builder: (context, value, child) {
                  if(value.departmentdatastatus == StksmrdepartmentDataState.Busy) {
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
                            Text("${language.text('selectdept')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                        //showSearchBox: true,
                        //showSelectedItems: true,
                        selectedItem: value.department,
                        popupProps: PopupPropsMultiSelection.menu(
                          showSearchBox: true,
                          fit: FlexFit.loose,
                          showSelectedItems: true,
                          menuProps: MenuProps(
                              shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.grey), // You can customize the border color
                              )
                          ),
                        ),
                        // popupShape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(5.0),
                        //   side: BorderSide(color: Colors.grey),
                        // ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(left: 10))
                        ),
                        items: (filter, loadProps) => value.departmentlistData.map((e) {
                          return e['value'].toString().trim();
                        }).toList(),
                        onChanged: (changedata) {
                          value.departmentlistData.forEach((element) {
                            if(changedata.toString() == element['value'].toString()){
                              value.department = element['value'].toString().trim();
                              value.deptcode = element['intcode'].toString();
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).getUnitInitiatingproposalData(value.rlyCode!, value.deptcode!, context);
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).getUnifyingrlyData(context);
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStoresDepotData(value.rlyCode!, context);
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 10),
                Text(language.text('unitinitprpsl'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<StockingProposalSummaryProvider>(builder: (context, value, child) {
                  if(value.unitinitproposalState == UnitinitproposalDataState.Busy) {
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
                            Text("${language.text('selectinitprp')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                        //showSearchBox: true,
                        selectedItem: value.unitinitproposal.length > 35 ? value.unitinitproposal.substring(0, 32) : value.unitinitproposal,
                        //showSelectedItems: true,
                        popupProps: PopupPropsMultiSelection.menu(
                          showSearchBox: true,
                          fit: FlexFit.loose,
                          showSelectedItems: true,
                          menuProps: MenuProps(
                              shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.grey), // You can customize the border color
                              )
                          ),
                        ),
                        // popupShape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(5.0),
                        //   side: BorderSide(color: Colors.grey),
                        // ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(left: 10))
                        ),
                        items: (filter, loadProps) => value.unitinitproposalData.map((item) {
                          if(item.value.toString().trim() == "All"){
                            return item.value.toString().trim();
                          }
                          else{
                            return item.intCode.toString()+"-"+item.value.toString().trim();
                          }
                        }).toList(),
                        onChanged: (changedata) {
                          value.unitinitproposalData.forEach((element) {
                            if(changedata.toString() == "All"){
                              value.unitinitproposal = "All";
                              value.unitinitproposalcode = "-1";
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).getUnifyingrlyData(context);
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStoresDepotData(value.rlyCode!, context);
                            }
                            if(changedata.toString() == element.intCode.toString()+"-"+element.value.toString()){
                              value.unitinitproposal = changedata.toString();
                              value.unitinitproposalcode = element.intCode.toString();
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).getUnifyingrlyData(context);
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStoresDepotData(value.rlyCode!, context);
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 10),
                Text(language.text('unifyingrly'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<StockingProposalSummaryProvider>(builder: (context, value, child) {
                  if(value.unifyingdatastatus == UnifyingrlyDataState.Busy) {
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
                            Text("${language.text('selunifyingrly')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                            Container(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2.0))
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
                        //showSearchBox: true,
                        //showSelectedItems: true,
                        selectedItem: value.unifyingrly,
                        popupProps: PopupPropsMultiSelection.menu(
                          showSearchBox: true,
                          fit: FlexFit.loose,
                          showSelectedItems: true,
                          menuProps: MenuProps(
                              shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.grey), // You can customize the border color
                              )
                          ),
                        ),
                        // popupShape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(5.0),
                        //   side: BorderSide(color: Colors.grey),
                        // ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(left: 10))
                        ),
                        items:(filter, loadProps) => value.unifyingrlylistData.map((e) {
                          return e.value.toString().trim();
                        }).toList(),
                        onChanged: (changedata) {
                          value.unifyingrlylistData.forEach((element) {
                            if(changedata.toString() == element.value.toString().trim()){
                              value.unifyingrly = element.value.toString().trim();
                              value.unifyingrlycode = element.intCode.toString();
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStoresDepotData(value.rlyCode!, context);
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 10),
                Text(language.text('storedepot'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
                SizedBox(height: 10),
                Consumer<StockingProposalSummaryProvider>(builder: (context, value, child) {
                  if(value.storeDepotState == StoresdepotDataState.Busy) {
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
                            Text("${language.text('selstoresdepot')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: DropdownSearch<String>(
                        //mode: Mode.DIALOG,
                        //showSearchBox: true,
                        selectedItem: value.storesdepot,
                        //showSelectedItems: true,
                        popupProps: PopupPropsMultiSelection.menu(
                          showSearchBox: true,
                          fit: FlexFit.loose,
                          showSelectedItems: true,
                          menuProps: MenuProps(
                              shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.grey), // You can customize the border color
                              )
                          ),
                        ),
                        // popupShape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(5.0),
                        //   side: BorderSide(color: Colors.grey),
                        // ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(left: 10))
                        ),
                        items: (filter, loadProps) => value.storeDepotData.map((item) {
                          if(item['name'].toString().trim() == "All"){
                            return "All";
                          }
                          else{
                            return item['name'].toString().trim();
                          }
                        }).toList(),
                        onChanged: (changedata) {
                          value.storeDepotData.forEach((element) {
                            if(changedata.toString() == "All"){
                              value.storesdepot = "All";
                              value.storesdepotcode = "-1";
                            }
                            else{
                              value.storesdepot = element['name'].toString().trim();
                              value.storesdepotcode = element['name'].toString().trim().split("-")[0];
                            }
                          });
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 20),
                Consumer<StockingProposalSummaryProvider>(builder: (context, value, child){
                  return Container(
                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                              height: 45,
                              minWidth: size.width * 0.45,
                              child: Text(language.text('nsdsubmit')),
                              shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDataScreen(value.rlyCode!, value.deptcode!, value.unitinitproposalcode!, value.unifyingrlycode!, value.storesdepotcode!, fromdate, todate)));
                              }, color: Colors.blue, textColor: Colors.white),
                          MaterialButton (
                              height: 45,
                              minWidth: size.width * 0.45,
                              child: Text(language.text('reset')),
                              shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                              onPressed: () {
                                getInitData();
                              }, color: Colors.red, textColor: Colors.white),
                        ],
                      )
                  );
                }),
              ]
          ),
        ),
      ),
    );
  }

  Widget customDialog(String? title, String? message){
    return Listener(
       onPointerUp: (event){
          if(_animationController.status == AnimationStatus.completed){
            Navigator.of(context).pop();
          }
       },
       child: ScaleTransition(
        scale: _animation,
        child: AlertDialog(
          title: Text(title!),
          content: Text(message!),
          actions: [
            TextButton(
              onPressed: () {
                _animationController.reverse();
                //_animationController.reset();
                //Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }


}
