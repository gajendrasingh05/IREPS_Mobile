import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_app/udm/rejection_warranty/view_model/rejectionwarranty_view_model.dart';
import 'package:flutter_app/udm/rejection_warranty/view_tabs_screens/my_forwarded_data_screen.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';

class MyForwardedClaimScreen extends StatefulWidget {
  const MyForwardedClaimScreen({Key? key}) : super(key: key);

  @override
  State<MyForwardedClaimScreen> createState() => _MyForwardedClaimScreenState();
}

class _MyForwardedClaimScreenState extends State<MyForwardedClaimScreen> {

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
      Provider.of<RejectionWarrantyViewModel>(context, listen: false).setRWFCMonth(RWfcCheckMonthState.less);
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
              child: Text(language.text('wcp'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            Consumer<RejectionWarrantyViewModel>(builder: (context, value, child){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: FormBuilderDateTimePicker(
                    name: 'Warranty Claim from Period',
                    initialDate: DateTime.now().subtract(const Duration(days: 180)),
                    initialValue: DateTime.now().subtract(const Duration(days: 180)),
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    onChanged: (datevalue){
                      final DateFormat formatter = DateFormat('dd-MM-yyyy');
                      fromdate = formatter.format(datevalue!);
                      value.checkfcdateDiff(fromdate, todate, formatter, context);
                      //_checkdateDiff(formatter.format(value!), todate, formatter);
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsetsDirectional.all(10),
                        suffixIcon: Icon(Icons.calendar_month),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1))
                    ),
                  ),
                );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(language.text('pt'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            Consumer<RejectionWarrantyViewModel>(builder: (context, value, child){
               return Padding(
                 padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                 child: FormBuilderDateTimePicker(
                   name: 'Period To',
                   initialDate: DateTime.now(),
                   initialValue: DateTime.now(),
                   inputType: InputType.date,
                   format: DateFormat('dd-MM-yyyy'),
                   onChanged: (datevalue){
                     final DateFormat formatter = DateFormat('dd-MM-yyyy');
                     todate = formatter.format(datevalue!);
                     value.checkfcdateDiff(fromdate, todate, formatter, context);
                   },
                   decoration: InputDecoration(
                       contentPadding: EdgeInsetsDirectional.all(10),
                       suffixIcon: Icon(Icons.calendar_month),
                       enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1))
                   ),
                 ),
               );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(language.text('rwsearch'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey, width: 1)
                ),
                padding: EdgeInsets.only(left: 5.0),
                alignment: Alignment.center,
                child: TextField(
                  controller: _queryController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: language.text('rwsearchhint'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Consumer<RejectionWarrantyViewModel>(builder: (context, value, child){
                    return AnimatedContainer(
                      width: size.width/2.3,
                      height: 45,
                      duration: Duration(seconds: 1),
                      curve: Curves.linear,
                      child: MaterialButton(
                          child: Text(language.text('rwsearch')),
                          shape: value.fcmonthcountstate == RWfcCheckMonthState.greater ? BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.black26)) : BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.white)),
                          onPressed: () {
                            if(value.fcmonthcountstate == RWfcCheckMonthState.greater){
                              UdmUtilities.showWarningFlushBar(context, language.text('monthwarning'));
                            }
                            else{
                              if(_queryController.text.trim().length == 0){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyForwardedClaimsDataScreen(fromdate, todate, " ")));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyForwardedClaimsDataScreen(fromdate, todate, _queryController.text.trim())));
                              }
                            }
                          }, color: value.fcmonthcountstate == RWfcCheckMonthState.greater ? Colors.grey.shade300 : Colors.blue, textColor: value.fcmonthcountstate == RWfcCheckMonthState.greater ? Colors.black : Colors.white),
                    );
                  }),
                  SizedBox(
                    width: size.width/2.3,
                    height: 45,
                    child: MaterialButton(
                        child: Text(language.text('rwexit')),
                        shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.white)),
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
