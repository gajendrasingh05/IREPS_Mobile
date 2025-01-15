import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/change_rwscroll_visibility_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/view_model/rejectionwarranty_view_model.dart';
import 'package:flutter_app/udm/rejection_warranty/view_tabs_screens/my_approved_dropped_claims_data_screen.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:shimmer/shimmer.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';

class MyApprovedDroppedClaimScreen extends StatefulWidget {
  const MyApprovedDroppedClaimScreen({Key? key}) : super(key: key);

  @override
  State<MyApprovedDroppedClaimScreen> createState() =>
      _MyApprovedDroppedClaimScreenState();
}

class _MyApprovedDroppedClaimScreenState
    extends State<MyApprovedDroppedClaimScreen> {
  String fromdate = "";
  String todate = "";

  final _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DateTime frdate = DateTime.now().subtract(const Duration(days: 180));
      DateTime tdate = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      fromdate = formatter.format(frdate);
      todate = formatter.format(tdate);
      Provider.of<RejectionWarrantyViewModel>(context, listen: false).setRWADCMonth(RWadcCheckMonthState.less);
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
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(language.text('wcp'),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ),
            Consumer<RejectionWarrantyViewModel>(
                builder: (context, value, child) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: FormBuilderDateTimePicker(
                  name: 'Warranty Claim from Period',
                  initialDate:
                      DateTime.now().subtract(const Duration(days: 180)),
                  initialValue:
                      DateTime.now().subtract(const Duration(days: 180)),
                  inputType: InputType.date,
                  format: DateFormat('dd-MM-yyyy'),
                  onChanged: (datevalue) {
                    final DateFormat formatter = DateFormat('dd-MM-yyyy');
                    fromdate = formatter.format(datevalue!);
                    value.checkadcdateDiff(
                        fromdate, todate, formatter, context);
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsetsDirectional.all(10),
                      suffixIcon: Icon(Icons.calendar_month),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1))),
                ),
              );
            }),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(language.text('pt'),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ),
            Consumer<RejectionWarrantyViewModel>(
                builder: (context, value, child) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: FormBuilderDateTimePicker(
                  name: 'Period To',
                  initialDate: DateTime.now(),
                  initialValue: DateTime.now(),
                  inputType: InputType.date,
                  format: DateFormat('dd-MM-yyyy'),
                  onChanged: (datevalue) {
                    final DateFormat formatter = DateFormat('dd-MM-yyyy');
                    todate = formatter.format(datevalue!);
                    value.checkadcdateDiff(
                        fromdate, todate, formatter, context);
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsetsDirectional.all(10),
                      suffixIcon: Icon(Icons.calendar_month),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1))),
                ),
              );
            }),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(language.text('rwsearch'),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey, width: 1)),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
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
                          shape: value.adcmonthcountstate == RWadcCheckMonthState.greater ? BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.black26)) : BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.white)),
                          onPressed: () {
                            if(value.adcmonthcountstate == RWadcCheckMonthState.greater){
                              UdmUtilities.showWarningFlushBar(context, language.text('monthwarning'));
                            }
                            else{
                              if (_queryController.text.trim().length == 0) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyApprovedDroppedClaimsDataScreen(fromdate, todate, " ")));
                              }
                              else {Navigator.push(context, MaterialPageRoute(builder: (context) => MyApprovedDroppedClaimsDataScreen(fromdate, todate, _queryController.text)));}
                            }
                          }, color: value.adcmonthcountstate == RWadcCheckMonthState.greater ? Colors.grey.shade300 : Colors.blue, textColor: value.adcmonthcountstate == RWadcCheckMonthState.greater ? Colors.black : Colors.white),
                    );
                  }),
                  SizedBox(
                    width: size.width / 2.3,
                    height: 45,
                    child: MaterialButton(
                        child: Text(language.text('rwexit')),
                        shape: BeveledRectangleBorder(
                            side:
                                BorderSide(width: 1.0, color: Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.red,
                        textColor: Colors.white),
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
