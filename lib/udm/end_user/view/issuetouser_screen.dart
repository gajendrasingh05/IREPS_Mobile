import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/end_user/view_models/to_end_user_view_model.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/network_provider.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:flutter_app/udm/widgets/animated_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class IssueToEndUserScreen extends StatefulWidget {

  final String? ledgerName;
  final String? folioName;
  final String? itemCode;
  final String? itemDesc;
  final String? stkQty;
  final String? unit;
  final String? rate;
  final String? value;
  IssueToEndUserScreen(this.ledgerName, this.folioName, this.itemCode, this.itemDesc, this.stkQty, this.unit, this.rate, this.value);

  @override
  State<IssueToEndUserScreen> createState() => _IssueToEndUserScreenState();
}

class _IssueToEndUserScreenState extends State<IssueToEndUserScreen> {
  DateTime selectedDate = DateTime.now();

  final qtybeingissuedController = TextEditingController();
  final purposeusageController = TextEditingController();
  final receiverDetailsController = TextEditingController();
  final irpsmidController = TextEditingController();
  final irpsmdetailController = TextEditingController();
  final allocationController = TextEditingController();
  final ordernumController = TextEditingController();
  final demandnumController = TextEditingController();

  //List<TextEditingController> _controllers = new List();
  List<TextEditingController> _controllers = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controllers.forEach((controller) {
    //     controller.text = "0";
    // });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<ToEndUSerViewModel>(context, listen: false).getenduservoucherlistData(context);
    });
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: Text(language.text('endusertitle'),
              style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white)),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(10.0),
        child: Consumer<ToEndUSerViewModel>(builder: (context, provider, child){
           if(provider.getVoucherDataState == VoucherDataState.Finished){
             return SingleChildScrollView(
               child: Form(
                 key: _formKey,
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Text(language.text('ledgername'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     TextFormField(
                       readOnly: true, // Set to true to make it read-only
                       decoration: InputDecoration(
                         filled: true,
                         fillColor: Colors.grey[200], // Light grey background color
                         hintText: widget.ledgerName!,
                         enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                         border: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                       ),
                     ),
                     SizedBox(height: 10),
                     Text(language.text('ledgerfolioname'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     TextFormField(
                       readOnly: true, // Set to true to make it read-only
                       decoration: InputDecoration(
                         filled: true,
                         fillColor: Colors.grey[200], // Light grey background color
                         hintText: widget.folioName!,
                         enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                         border: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                       ),
                     ),
                     SizedBox(height: 10),
                     Text(language.text('itemcodeplno'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     TextFormField(
                       readOnly: true, // Set to true to make it read-only
                       decoration: InputDecoration(
                         filled: true,
                         fillColor: Colors.grey[200], // Light grey background color
                         hintText: widget.itemCode!,
                         enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                         border: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                       ),
                     ),
                     SizedBox(height: 10),
                     Text(language.text('itemDesc'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     TextFormField(
                       readOnly: true,
                       maxLines: 4,
                       decoration: InputDecoration(
                         filled: true,
                         fillColor: Colors.grey[200], // Light grey background color
                         hintText: widget.itemDesc,
                         enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                         border: OutlineInputBorder(
                           borderSide: BorderSide.none, // Remove border
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                       ),
                     ),
                     SizedBox(height: 10),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                           Text(language.text('stkqty'),
                               style: TextStyle(
                                   color: Colors.red,
                                   fontSize: 17,
                                   fontWeight: FontWeight.w600)),
                           SizedBox(height: 5.0),
                           TextFormField(
                             readOnly: true,
                             decoration: InputDecoration(
                               filled: true,
                               fillColor: Colors.grey[200], // Light grey background color
                               hintText: widget.stkQty,
                               hintStyle: TextStyle(color: Colors.red),
                               enabledBorder: OutlineInputBorder(
                                 borderSide: BorderSide.none, // Remove border
                                 borderRadius: BorderRadius.circular(8.0),
                               ),
                               focusedBorder: OutlineInputBorder(
                                 borderSide: BorderSide.none, // Remove border
                                 borderRadius: BorderRadius.circular(8.0),
                               ),
                               border: OutlineInputBorder(
                                 borderSide: BorderSide.none, // Remove border
                                 borderRadius: BorderRadius.circular(8.0),
                               ),
                             ),
                           ),
                         ])),
                         SizedBox(width: 10),
                         Expanded(
                           child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,children: [
                             Text(language.text('enduserunit'),
                                 style: TextStyle(
                                     color: Colors.red,
                                     fontSize: 17,
                                     fontWeight: FontWeight.w600)),
                             SizedBox(height: 5.0),
                             TextFormField(
                               readOnly: true,
                               decoration: InputDecoration(
                                 filled: true,
                                 fillColor: Colors.grey[200], // Light grey background color
                                 hintText: widget.unit!,
                                 hintStyle: TextStyle(color: Colors.red),
                                 enabledBorder: OutlineInputBorder(
                                   borderSide: BorderSide.none, // Remove border
                                   borderRadius: BorderRadius.circular(8.0),
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderSide: BorderSide.none, // Remove border
                                   borderRadius: BorderRadius.circular(8.0),
                                 ),
                                 border: OutlineInputBorder(
                                   borderSide: BorderSide.none, // Remove border
                                   borderRadius: BorderRadius.circular(8.0),
                                 ),
                               ),
                             ),
                           ]),
                         )
                       ],
                     ),
                     SizedBox(height: 10),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(language.text('rate'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 5.0),
                              TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200], // Light grey background color
                                  hintText: widget.rate!,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none, // Remove border
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none, // Remove border
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none, // Remove border
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                         )),
                         SizedBox(width: 10),
                         Expanded(child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Text(language.text('euvalue'),
                                 style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 17,
                                     fontWeight: FontWeight.w400)),
                             SizedBox(height: 5.0),
                             TextFormField(
                               readOnly: true,
                               decoration: InputDecoration(
                                 filled: true,
                                 fillColor: Colors.grey[200], // Light grey background color
                                 hintText: widget.value!,
                                 enabledBorder: OutlineInputBorder(
                                   borderSide: BorderSide.none, // Remove border
                                   borderRadius: BorderRadius.circular(8.0),
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderSide: BorderSide.none, // Remove border
                                   borderRadius: BorderRadius.circular(8.0),
                                 ),
                                 border: OutlineInputBorder(
                                   borderSide: BorderSide.none, // Remove border
                                   borderRadius: BorderRadius.circular(8.0),
                                 ),
                               ),
                             ),
                           ],
                         )),
                       ],
                     ),
                     SizedBox(height: 10),
                     Text(language.text('demandNo'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     TextFormField(
                       controller: demandnumController,
                       decoration: InputDecoration(
                         hintText: "${language.text('demandNo')}",
                         contentPadding:
                         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                         focusedBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                               color: Color(0xFF00008B), width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         border: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         disabledBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         errorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         focusColor: Colors.red[300],
                         focusedErrorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.red, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                       ),
                       validator: (pin) {
                         String text = language.text('pedmnum');
                         if (pin == null || pin.isEmpty) {
                           return text;
                         }
                         return null;
                       },
                       onChanged: (value) {},
                     ),
                     SizedBox(height: 10),
                     Text(language.text('demandDate'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     FormBuilderDateTimePicker(
                       name: 'ToDate',
                       initialDate: DateTime.now(),
                       initialValue: DateTime.now(),
                       inputType: InputType.date,
                       format: DateFormat('dd-MM-yyyy'),
                       onChanged: (datevalue) {
                         final DateFormat formatter = DateFormat('dd-MM-yyyy');
                         //todate = formatter.format(datevalue!);
                         //value.checkdateDiff(fromdate, todate, formatter, context);
                       },
                       decoration: InputDecoration(
                         contentPadding: EdgeInsetsDirectional.all(10),
                         suffixIcon: Icon(Icons.calendar_month),
                         enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10.0),
                             borderSide: BorderSide(color: Colors.grey, width: 1)),
                         //border: const OutlineInputBorder(),
                       ),
                     ),
                     SizedBox(height: 10),
                     Text(language.text('allocation'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     TextFormField(
                       controller: allocationController,
                       decoration: InputDecoration(
                         hintText: "${language.text('allocation')}.",
                         contentPadding:
                         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                         focusedBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                               color: Color(0xFF00008B), width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         border: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         disabledBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         errorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         focusColor: Colors.red[300],
                         focusedErrorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.red, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                       ),
                       validator: (pin) {
                         String text = language.text('peallocation');
                         if (pin == null || pin.isEmpty) {
                           return text;
                         }
                         return null;
                       },
                       onChanged: (value) {},
                     ),
                     SizedBox(height: 10),
                     Text(language.text('weorkorderno'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     TextFormField(
                       controller: ordernumController,
                       decoration: InputDecoration(
                         hintText: "${language.text('weorkorderno')}",
                         contentPadding:
                         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                         focusedBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                               color: Color(0xFF00008B), width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         border: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         disabledBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         errorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         focusColor: Colors.red[300],
                         focusedErrorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.red, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                       ),
                       validator: (pin) {
                         String text = language.text('peworkordernum');
                         if (pin == null || pin.isEmpty) {
                           return text;
                         }
                         return null;
                       },
                       onChanged: (value) {},
                     ),
                     SizedBox(height: 10),
                     Text(language.text('qbi'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     Consumer<ToEndUSerViewModel>(builder: (context, enduserviewmodel, child){
                       return TextFormField(
                         controller: qtybeingissuedController,
                         //initialValue: enduserviewmodel.getIssueQty.toString().trim(),
                         keyboardType: TextInputType.number,
                         decoration: InputDecoration(
                           hintText: enduserviewmodel.getIssueQty == 0 ? language.text('qbi') : enduserviewmodel.getIssueQty.toString(),
                           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                           focusedBorder: OutlineInputBorder(
                             borderSide: const BorderSide(
                                 color: Color(0xFF00008B), width: 1.0),
                             borderRadius: BorderRadius.circular(10.0),
                           ),
                           border: OutlineInputBorder(
                             borderSide: const BorderSide(
                               color: Colors.grey,
                             ),
                             borderRadius: BorderRadius.circular(10),
                           ),
                           disabledBorder: OutlineInputBorder(
                             borderSide: const BorderSide(
                               color: Colors.grey,
                             ),
                             borderRadius: BorderRadius.circular(10),
                           ),
                           errorBorder: OutlineInputBorder(
                             borderSide:
                             const BorderSide(color: Colors.grey, width: 1.0),
                             borderRadius: BorderRadius.circular(10.0),
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderSide:
                             const BorderSide(color: Colors.grey, width: 1.0),
                             borderRadius: BorderRadius.circular(10.0),
                           ),
                           focusColor: Colors.red[300],
                           focusedErrorBorder: OutlineInputBorder(
                             borderSide:
                             const BorderSide(color: Colors.red, width: 1.0),
                             borderRadius: BorderRadius.circular(10.0),
                           ),
                         ),
                         validator: (pin) {
                           String text = language.text('peq');
                           if (pin == null || pin.isEmpty) {
                             return text;
                           }
                           return null;
                         },
                         onChanged: (value) {},
                       );
                     }),
                     SizedBox(height: 10),
                     Text(language.text('iwi'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     TextFormField(
                       controller: irpsmidController,
                       decoration: InputDecoration(
                         hintText: language.text('iwi'),
                         contentPadding:
                         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                         focusedBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                               color: Color(0xFF00008B), width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         border: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         disabledBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         errorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         focusColor: Colors.red[300],
                         focusedErrorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.red, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                       ),
                       validator: (pin) {
                         String text = language.text('pewid');
                         if (pin == null || pin.isEmpty) {
                           return text;
                         }
                         return null;
                       },
                       onChanged: (value) {},
                     ),
                     SizedBox(height: 10),
                     Text(language.text('iwd'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     TextFormField(
                       controller: irpsmdetailController,
                       maxLines: 3,
                       decoration: InputDecoration(
                         hintText: language.text('iwd'),
                         contentPadding:
                         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                         focusedBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                               color: Color(0xFF00008B), width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         border: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         disabledBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         errorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         focusColor: Colors.red[300],
                         focusedErrorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.red, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                       ),
                       validator: (pin) {
                         String text = language.text('pewd');
                         if (pin == null || pin.isEmpty) {
                           return text;
                         }
                         return null;
                       },
                       onChanged: (value) {},
                     ),
                     SizedBox(height: 10),
                     Text(language.text('recd'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     TextFormField(
                       controller: receiverDetailsController,
                       maxLines: 3,
                       decoration: InputDecoration(
                         hintText: language.text('recd'),
                         contentPadding:
                         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                         focusedBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                               color: Color(0xFF00008B), width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         border: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         disabledBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         errorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         focusColor: Colors.red[300],
                         focusedErrorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.red, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                       ),
                       validator: (pin) {
                         String text = language.text('perd');
                         if(pin == null || pin.isEmpty) {
                           return text;
                         }
                         return null;
                       },
                       onChanged: (value) {},
                     ),
                     SizedBox(height: 10),
                     Text(language.text('issuetype'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     Consumer<ToEndUSerViewModel>(
                         builder: (context, issuetypevalue, child) {
                           return Row(
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   Radio<String>(
                                     value: 'Returnable',
                                     groupValue: issuetypevalue.getissuetype,
                                     onChanged: (value) {
                                       issuetypevalue.updateIssueType(value!);
                                     },
                                   ),
                                   Text("Returnable",
                                       style:
                                       TextStyle(color: Colors.black, fontSize: 16))
                                 ],
                               ),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   Radio<String>(
                                     value: 'Normal',
                                     groupValue: issuetypevalue.getissuetype,
                                     onChanged: (value) {
                                       setState(() {
                                         issuetypevalue.updateIssueType(value!);
                                       });
                                     },
                                   ),
                                   Text("Normal",
                                       style:
                                       TextStyle(color: Colors.black, fontSize: 16))
                                 ],
                               ),
                             ],
                           );
                         }),
                     SizedBox(height: 10),
                     Text(language.text('adi'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     FormBuilderDateTimePicker(
                       name: 'ToDate',
                       initialDate: DateTime.now(),
                       initialValue: DateTime.now(),
                       inputType: InputType.date,
                       format: DateFormat('dd-MM-yyyy'),
                       onChanged: (datevalue) {
                         final DateFormat formatter = DateFormat('dd-MM-yyyy');
                         //todate = formatter.format(datevalue!);
                         //value.checkdateDiff(fromdate, todate, formatter, context);
                       },
                       decoration: InputDecoration(
                         contentPadding: EdgeInsetsDirectional.all(10),
                         suffixIcon: Icon(Icons.calendar_month),
                         enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10.0),
                             borderSide: BorderSide(color: Colors.grey, width: 1)),
                         //border: const OutlineInputBorder(),
                       ),
                     ),
                     SizedBox(height: 10),
                     Text(language.text('at'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     Consumer<ToEndUSerViewModel>(
                         builder: (context, assettype, child) {
                           return DropdownButtonFormField<String>(
                               value: assettype.getassettype,
                               borderRadius: BorderRadius.all(Radius.circular(16.0)),
                               isExpanded: false,
                               onChanged: (String? value) {
                                 assettype.updateAssetType(value!);
                               },
                               decoration: InputDecoration(
                                 hintText: "Asset type",
                                 contentPadding:
                                 EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                 focusedBorder: OutlineInputBorder(
                                   borderSide: const BorderSide(
                                       color: Color(0xFF00008B), width: 1.0),
                                   borderRadius: BorderRadius.circular(10.0),
                                 ),
                                 border: OutlineInputBorder(
                                   borderSide: const BorderSide(
                                     color: Colors.grey,
                                   ),
                                   borderRadius: BorderRadius.circular(10),
                                 ),
                                 disabledBorder: OutlineInputBorder(
                                   borderSide: const BorderSide(
                                     color: Colors.grey,
                                   ),
                                   borderRadius: BorderRadius.circular(10),
                                 ),
                                 errorBorder: OutlineInputBorder(
                                   borderSide:
                                   const BorderSide(color: Colors.grey, width: 1.0),
                                   borderRadius: BorderRadius.circular(10.0),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderSide:
                                   const BorderSide(color: Colors.grey, width: 1.0),
                                   borderRadius: BorderRadius.circular(10.0),
                                 ),
                                 focusColor: Colors.red[300],
                                 focusedErrorBorder: OutlineInputBorder(
                                   borderSide:
                                   const BorderSide(color: Colors.red, width: 1.0),
                                   borderRadius: BorderRadius.circular(10.0),
                                 ),
                               ),
                               items: [
                                 DropdownMenuItem(
                                   value: 'Others',
                                   child: Text('Others', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                 ),
                                 DropdownMenuItem(
                                   value: 'Coach',
                                   child: Text('Coach',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                 ),
                                 DropdownMenuItem(
                                   value: 'Locomotive',
                                   child: Text('Locomotive',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                 ),
                               ]);
                         }),
                     SizedBox(height: 10),
                     Text(language.text('purpu'),
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 17,
                             fontWeight: FontWeight.w400)),
                     SizedBox(height: 5.0),
                     TextFormField(
                       controller: purposeusageController,
                       maxLines: 3,
                       decoration: InputDecoration(
                         hintText: language.text('puru'),
                         contentPadding:
                         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                         focusedBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                               color: Color(0xFF00008B), width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         border: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         disabledBorder: OutlineInputBorder(
                           borderSide: const BorderSide(
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         errorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.grey, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         focusColor: Colors.red[300],
                         focusedErrorBorder: OutlineInputBorder(
                           borderSide:
                           const BorderSide(color: Colors.red, width: 1.0),
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                       ),
                       validator: (pin) {
                         String text = language.text('pepu');
                         if (pin == null || pin.isEmpty) {
                           return text;
                         }
                         return null;
                       },
                       onChanged: (value) {},
                     ),
                     SizedBox(height: 10),
                     Container(
                         width: size.width,
                         padding: EdgeInsets.symmetric(horizontal: 5.0),
                         height: 45,
                         alignment: Alignment.centerLeft,
                         decoration: BoxDecoration(color: Colors.blue),
                         child: Text(language.text('asd'),
                             style: TextStyle(color: Colors.white))),
                     SizedBox(height: 10),
                     Consumer<ToEndUSerViewModel>(builder: (context, provider, child){
                       return SizedBox(
                           height: size.height * 0.28,
                           width: double.infinity,
                           child: ListView.builder(
                               itemCount: provider.getVoucherData.length,
                               shrinkWrap: true,
                               scrollDirection: Axis.horizontal,
                               padding: EdgeInsets.zero,
                               itemBuilder: (context, index) {
                                 _controllers.add(TextEditingController());
                                 return Card(
                                   elevation: 8.0,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(4.0),
                                   ),
                                   child: Container(
                                       decoration: BoxDecoration(
                                           color: Colors.white,
                                           borderRadius:
                                           BorderRadius.all(Radius.circular(8.0))),
                                       padding: EdgeInsets.all(8.0),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Text(language.text('dmtrD'), style: TextStyle(fontWeight: FontWeight.w600)),
                                                   Text("${provider.getVoucherData[index].voucherNo.toString().trim()}\ndt-${provider.getVoucherData[index].voucherDate.toString().trim()}"),
                                                 ],
                                               ),
                                               SizedBox(width: 10),
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Text(language.text('rf'), style: TextStyle(fontWeight: FontWeight.w600)),
                                                   SizedBox(width: 120, child: Text("${provider.getVoucherData[index].vendName.toString().trim()}", maxLines: 3, style: TextStyle(color: Colors.black)))
                                                 ],
                                               ),
                                               SizedBox(width: 10),
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Text(language.text('loc'), style: TextStyle(fontWeight: FontWeight.w600)),
                                                   SizedBox(width: 120, child: Text("${provider.getVoucherData[index].loc.toString().trim()}")),
                                                 ],
                                               ),
                                             ],
                                           ),
                                           SizedBox(height: 10),
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 children: [
                                                   SizedBox(width: 120, child: Text(language.text('dbq'), style: TextStyle(fontWeight: FontWeight.w600))),
                                                   Text("${provider.getVoucherData[index].balQty.toString().trim()}"),
                                                 ],
                                               ),
                                               SizedBox(width: 10),
                                               SizedBox(
                                                 width: 200,
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   mainAxisAlignment: MainAxisAlignment.start,
                                                   children: [
                                                     Text(language.text('qdbi'), maxLines: 3, style: TextStyle(fontWeight: FontWeight.w600)),
                                                     SizedBox(height: 4.0),
                                                     Row(
                                                       children: [
                                                         Expanded(flex : 2,child: TextFormField(
                                                           maxLines: 1,
                                                           keyboardType: TextInputType.number,
                                                           controller: _controllers[index],
                                                           decoration: InputDecoration(
                                                             hintText: "Qty",
                                                             contentPadding:
                                                             EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                             focusedBorder: OutlineInputBorder(
                                                               borderSide: const BorderSide(
                                                                   color: Color(0xFF00008B), width: 1.0),
                                                               borderRadius: BorderRadius.circular(10.0),
                                                             ),
                                                             border: OutlineInputBorder(
                                                               borderSide: const BorderSide(
                                                                 color: Colors.grey,
                                                               ),
                                                               borderRadius: BorderRadius.circular(10),
                                                             ),
                                                             disabledBorder: OutlineInputBorder(
                                                               borderSide: const BorderSide(
                                                                 color: Colors.grey,
                                                               ),
                                                               borderRadius: BorderRadius.circular(10),
                                                             ),
                                                             errorBorder: OutlineInputBorder(
                                                               borderSide:
                                                               const BorderSide(color: Colors.grey, width: 1.0),
                                                               borderRadius: BorderRadius.circular(10.0),
                                                             ),
                                                             enabledBorder: OutlineInputBorder(
                                                               borderSide:
                                                               const BorderSide(color: Colors.grey, width: 1.0),
                                                               borderRadius: BorderRadius.circular(10.0),
                                                             ),
                                                             focusColor: Colors.red[300],
                                                             focusedErrorBorder: OutlineInputBorder(
                                                               borderSide:
                                                               const BorderSide(color: Colors.red, width: 1.0),
                                                               borderRadius: BorderRadius.circular(10.0),
                                                             ),
                                                           ),
                                                           onChanged: (qty) {
                                                             //int newQuantity = int.tryParse(qty) ?? 0;
                                                             //Provider.of<ToEndUSerViewModel>(context, listen: false).calculateIssueQty(newQuantity.toString());
                                                             setState(() {});
                                                           },
                                                         )),
                                                         SizedBox(width: 10),
                                                         _getWidgetFromValue("${provider.getVoucherData[index].balQty.toString().trim()}", _controllers[index].text.trim())
                                                       ],
                                                     )

                                                   ],
                                                 ),
                                               ),
                                               // SizedBox(width: 10),
                                               // Align(
                                               //   alignment: Alignment.bottomRight,
                                               //   child: _getWidgetFromValue("${provider.getVoucherData[index].balQty.toString().trim()}", _controllers[index].text.trim()),
                                               // )
                                               // Column(
                                               //   mainAxisAlignment: MainAxisAlignment.start,
                                               //   crossAxisAlignment: CrossAxisAlignment.start,
                                               //   children: [
                                               //     //Text(language.text('wred'), style: TextStyle(fontWeight: FontWeight.w600)),
                                               //     //SizedBox(width: 120, child: Text(provider.getVoucherData[index].manuFacturingDate ?? "NA")),
                                               //     SizedBox(height: 45),
                                               //     _getWidgetFromValue("${provider.getVoucherData[index].balQty.toString().trim()}", _controllers[index].text.trim())
                                               //   ],
                                               // )

                                             ],
                                           ),
                                           // SizedBox(height: 10),
                                           // Row(
                                           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           //   crossAxisAlignment: CrossAxisAlignment.start,
                                           //   children: [
                                           //     Column(
                                           //       crossAxisAlignment: CrossAxisAlignment.start,
                                           //       children: [
                                           //         Text("Available Make/Brand", style: TextStyle(fontWeight: FontWeight.w600)),
                                           //         Text("3213"),
                                           //       ],
                                           //     ),
                                           //     SizedBox(width: 10),
                                           //     Column(
                                           //       crossAxisAlignment: CrossAxisAlignment.start,
                                           //       children: [
                                           //         Text("Received From", style: TextStyle(fontWeight: FontWeight.w600)),
                                           //         SizedBox(width: 120, child: Text("Old Existing Stock in Books")),
                                           //       ],
                                           //     ),
                                           //   ],
                                           // ),
                                         ],
                                       )),
                                 );
                               }));
                     }),
                     SizedBox(height: 20),
                     Container(
                         width: size.width,
                         padding: EdgeInsets.symmetric(horizontal: 5.0),
                         height: 45,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             MaterialButton(
                                 height: 45,
                                 minWidth: size.width * 0.45,
                                 child: Text(language.text('issuebtn')),
                                 shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                                 onPressed: () {
                                   if(_formKey.currentState!.validate()) {
                                     if(Provider.of<NetworkProvider>(context, listen: false).status == ConnectivityStatus.Offline){
                                       UdmUtilities.showWarningFlushBar(context, Provider.of<LanguageProvider>(context, listen: false).text('checkconnection'));
                                     }
                                     else{
                                       AwesomeDialog(
                                         context: context,
                                         animType: AnimType.bottomSlide,
                                         headerAnimationLoop: false,
                                         dialogType: DialogType.success,
                                         //showCloseIcon: true,
                                         title: 'Success',
                                         desc: 'Successfully submitted your issue.',
                                         btnOkOnPress: () {
                                           debugPrint('OnClcik');
                                         },
                                         btnOkIcon: Icons.check_circle,
                                         onDismissCallback: (type) {
                                           debugPrint('Dialog Dissmiss from callback $type');
                                         },
                                       ).show();
                                     }
                                   }
                                 },
                                 color: Colors.blue,
                                 textColor: Colors.white),
                             MaterialButton(
                                 height: 45,
                                 minWidth: size.width * 0.45,
                                 child: Text(language.text('exit')),
                                 shape: BeveledRectangleBorder(side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
                                 onPressed: () {
                                   Navigator.pop(context);
                                   //getInitData();
                                   //Navigator.push(context, MaterialPageRoute(builder: (context) => NSDemandDataSummaryScreen(fromdate, todate, rlycode, unittypecode, unitnamecode, departmentcode, consigneecode, indentorcode)));
                                 },
                                 color: Colors.red,
                                 textColor: Colors.white),
                           ],
                         ))
                   ],
                 ),
               ),
             );
           }
           else if(provider.getVoucherDataState == VoucherDataState.Busy){
             return Center(child: CircularProgressIndicator());
           }
           return SizedBox();
        }),
      ),
    );
  }

  Widget _getWidgetFromValue(String blcQty, String inputQty) {
    if(inputQty.isEmpty) {
      return SizedBox();
    }
    final number = int.tryParse(inputQty);
    return number != null && number > int.parse(blcQty) ? Container(height: 40, width: 40, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)), child: Icon(Icons.clear, color: Colors.white)) : Container(height: 40, width: 40, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),child: Icon(Icons.check, color: Colors.white));
  }



}
