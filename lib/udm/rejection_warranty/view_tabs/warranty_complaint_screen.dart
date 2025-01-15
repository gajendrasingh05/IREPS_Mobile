import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/rejection_warranty/view_model/rejectionwarranty_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class WarrantyComplaintScreen extends StatefulWidget {
  const WarrantyComplaintScreen({Key? key}) : super(key: key);

  @override
  State<WarrantyComplaintScreen> createState() => _WarrantyComplaintScreenState();
}

class _WarrantyComplaintScreenState extends State<WarrantyComplaintScreen> {

  String status = "All";
  String statuscode = "-1";

  String fromdate = "";
  String todate = "";

  final _queryController = TextEditingController();

  ScrollController listScrollController = ScrollController();



  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DateTime frdate = DateTime.now().subtract(const Duration(days: 180));
      DateTime tdate = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      fromdate = formatter.format(frdate);
      todate = formatter.format(tdate);
      Provider.of<RejectionWarrantyViewModel>(context, listen: false).getStatusData(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(language.text('fromdate'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: FormBuilderDateTimePicker(
                name: 'Date From',
                initialDate: DateTime.now().subtract(const Duration(days: 180)),
                initialValue: DateTime.now().subtract(const Duration(days: 180)),
                inputType: InputType.date,
                format: DateFormat('dd-MM-yyyy'),
                onChanged: (datevalue){
                  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                  fromdate = formatter.format(datevalue!);
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsetsDirectional.all(10),
                    suffixIcon: Icon(Icons.calendar_month),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1))
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(language.text('todate'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: FormBuilderDateTimePicker(
                name: 'Date To',
                initialDate: DateTime.now(),
                initialValue: DateTime.now(),
                inputType: InputType.date,
                format: DateFormat('dd-MM-yyyy'),
                onChanged: (datevalue){
                  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                  todate = formatter.format(datevalue!);
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsetsDirectional.all(10),
                    suffixIcon: Icon(Icons.calendar_month),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1))
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(language.text('status'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Consumer<RejectionWarrantyViewModel>(builder: (context, value, child) {
                if(value.statusstate == RwStatusDataState.Busy) {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${language.text('selectsts')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownSearch<String>(
                      //mode: Mode.DIALOG,
                      //showSearchBox: true,
                      //showFavoriteItems: true,
                      //hint: status,
                      // favoriteItems: (val) {
                      //   return [status];
                      // },
                      popupProps: PopupPropsMultiSelection.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        title: Text(status),
                        showSelectedItems: true,
                        menuProps: MenuProps(
                            shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.grey), // You can customize the border color
                            )
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(left: 10))
                      ),
                      items: (filter, loadProps) => value.statusitems.map((e) {
                        return e.statusname.toString().trim();
                      }).toList(),
                      onChanged: (changedata) {
                        value.statusitems.forEach((element) {
                          if(changedata.toString() == element.statusname.toString()){
                            status = element.statusname.toString().trim();
                            statuscode = element.statusvalue.toString();
                          }
                        });
                      },
                    ),
                  );
                }
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: size.width/2.3,
                    height: 45,
                    child: MaterialButton(
                        child: Text(language.text('rwsearch')),
                        shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.black12)),
                        onPressed: () {
                          // if(_queryController.text.trim().length == 0){
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => MyForwardedClaimsDataScreen(fromdate, todate, " ")));
                          // }
                          // else{
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => MyForwardedClaimsDataScreen(fromdate, todate, _queryController.text.trim())));
                          // }
                        }, color: Colors.blue, textColor: Colors.white),
                  ),
                  SizedBox(
                    width: size.width/2.3,
                    height: 45,
                    child: MaterialButton(
                        child: Text(language.text('rwexit')),
                        shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.black12)),
                        onPressed: () {
                          Navigator.pop(context);
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => NonStockDemandsScreen()));
                        }, color: Colors.red, textColor: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
