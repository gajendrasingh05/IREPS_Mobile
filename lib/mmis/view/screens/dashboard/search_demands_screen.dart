import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/controllers/search_demand_controller.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class SearchDemandsScreen extends StatefulWidget {
  const SearchDemandsScreen({super.key});

  @override
  State<SearchDemandsScreen> createState() => _SearchDemandsScreenState();
}

class _SearchDemandsScreenState extends State<SearchDemandsScreen> {

  String selectedstatus = 'All';
  String selectedDepart = "All";
  String selectedDemand = "New Demand";
  String fromDate = 'from';
  String toDate = 'to';
  String? deptCode;
  String? statusCode;


  final departKey = GlobalKey<DropdownSearchState>();
  final demandKey = GlobalKey<DropdownSearchState>();
  final TextEditingController _demandnumController = TextEditingController();

  final List<Map<String, dynamic>> statusOptions = [];

  final List<Map<String, dynamic>> newstatusOptions = [
    {"value": "-1", "label": "All"},
    {"value": "0", "label": "Initiated (Draft)"},
    {"value": "1", "label": "Under Fund Certification"},
    {"value": "2", "label": "Fund Certification granted"},
    {"value": "3", "label": "Forwarded for PAC Approval"},
    {"value": "4", "label": "PAC Approved"},
    {"value": "9", "label": "Under Technical Vetting"},
    {"value": "10", "label": "Technical Vetting done"},
    {"value": "7", "label": "Under Finance Concurrence"},
    {"value": "8", "label": "Finance Concurrence accorded"},
    {"value": "14", "label": "Under Purchase Review"},
    {"value": "15", "label": "Purchase Review Approved"},
    {"value": "11", "label": "Under Process"},
    {"value": "5", "label": "Under Approval"},
    {"value": "6", "label": "Approved & Forwarded to Purchase"},
    {"value": "13", "label": "Returned by Purchase Unit"},
    {"value": "12", "label": "Dropped"},
  ];

  final List<Map<String, dynamic>> oldstatusOptions = [
    {"value": "-1", "label": "All"},
    {"value": "0", "label": "Draft"},
    {"value": "3", "label": "Under Tech. Vetting"},
    {"value": "I", "label": "Tech. Vetted"},
    {"value": "1", "label": "Under Concurrence"},
    {"value": "F", "label": "Concurred"},
    {"value": "A", "label": "Approved"},
    {"value": "B", "label": "Returned Back"},
  ];

  //final searchdmdController = Get.find<SearchDemandController>();
  final searchdmdController = Get.put(SearchDemandController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("search dmd screen initState called");
    searchdmdController.fetchDepartment(context);
    statusOptions.addAll(newstatusOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Demands',style: TextStyle(color: Colors.white)),backgroundColor: MyColor.primaryColor,
        iconTheme: IconThemeData(color: Colors.white)),
        body: Container(
         height: Get.height,
         width: Get.width,
         child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Text("Please select demand type:", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                 SizedBox(height: 10.0),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Old Demand Container
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDemand = "Old Demand";
                          statusOptions.clear();
                          statusOptions.addAll(oldstatusOptions);
                          selectedstatus = "All";
                        });
                        ToastMessage.showSnackBar("Message", "Comming Soon!!", Colors.teal);
                      },
                      child: CustomSelectionContainer(
                        title: "Old Demand",
                        isSelected: selectedDemand == "Old Demand",
                      ),
                    ),
                    // New Demand Container
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDemand = "New Demand";
                          statusOptions.clear();
                          statusOptions.addAll(newstatusOptions);
                          selectedstatus = "All";
                        });
                      },
                      child: CustomSelectionContainer(
                        title: "New Demand",
                        isSelected: selectedDemand == "New Demand",
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 10.0),
                 Text("Demand Date:", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                 SizedBox(height: 10.0),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: FormBuilderDateTimePicker(
                        name: 'From',
                        //initialDate: 'dd-mm-yyyy',
                        //initialValue: DateTime.now().subtract(const Duration(days: 182)),
                        inputType: InputType.date,
                        format: DateFormat('dd-MM-yyyy'),
                        onChanged: (datevalue){
                          final DateFormat formatter = DateFormat('dd-MM-yyyy');
                          fromDate = formatter.format(datevalue!);
                        },
                        decoration: InputDecoration(
                            labelText: 'dd-mm-yyyy',
                            hintText: 'From Date',
                            contentPadding: EdgeInsetsDirectional.all(5),
                            suffixIcon: Icon(Icons.calendar_month),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1))
                        ),
                      )
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: FormBuilderDateTimePicker(
                        name: 'ToDate',
                        //initialDate: DateTime.now(),
                        //initialValue: DateTime.now(),
                        inputType: InputType.date,
                        format: DateFormat('dd-MM-yyyy'),
                        onChanged: (datevalue){
                          final DateFormat formatter = DateFormat('dd-MM-yyyy');
                          toDate = formatter.format(datevalue!);
                          //value.checkdateDiff(fromdate, todate, formatter, context);
                        },
                        decoration: InputDecoration(
                            labelText: 'dd-MM-yyyy',
                            hintText: 'To Date',
                            contentPadding: EdgeInsetsDirectional.all(5),
                            suffixIcon: Icon(Icons.calendar_month),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1))
                        ),
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 10.0),
                 Text("Department", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                 SizedBox(height: 10.0),
                 Obx((){
                   if(searchdmdController.departState == DepartmentState.Busy) {
                     return Container(
                       height: 45,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(4.0)),
                           border: Border.all(color: Colors.grey, width: 1)),
                       alignment: Alignment.center,
                       child: Padding(
                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text("Select Department", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                   else if(searchdmdController.departState == DepartmentState.Finished){
                     return DropdownSearch<String>(
                       key: departKey,
                       selectedItem: selectedDepart,
                       items: (filter, loadProps) => searchdmdController.departOptions.map((e){
                         return e.key2.toString().trim();
                       }).toList(),
                       decoratorProps: DropDownDecoratorProps(
                         decoration: InputDecoration(
                           labelText: 'Select Department',
                           hintText: '----Select----',
                           contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                           border: OutlineInputBorder(),
                         ),
                       ),
                       onChanged: (String? value) {
                        final selectedOption = searchdmdController.departOptions.firstWhere((element) => element.key2 == value);
                        selectedDepart = value!;
                        deptCode = selectedOption.key1;
                        //debugPrint("Selected Value: ${selectedOption.key1}");
                       },
                       popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: Get.height * 0.45)),
                     );
                   }
                   else if(searchdmdController.departState == DepartmentState.Error){
                     return Container(
                       height: 45,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(4.0)),
                           border: Border.all(color: Colors.grey, width: 1)),
                       alignment: Alignment.center,
                       child: Padding(
                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text("Select Department", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                             Container(
                                 height: 24,
                                 width: 24,
                                 alignment: Alignment.centerRight,
                                 child: InkWell(onTap: (){searchdmdController.fetchDepartment(context);}, child: Icon(Icons.refresh, color: Colors.grey)))
                           ],
                         ),
                       ),
                     );
                   }
                   else if(searchdmdController.departState == DepartmentState.FinishedwithError){
                     return Container(
                       height: 45,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(4.0)),
                           border: Border.all(color: Colors.grey, width: 1)),
                       alignment: Alignment.center,
                       child: Padding(
                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text("Select Department", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                             Container(
                                 height: 24,
                                 width: 24,
                                 alignment: Alignment.centerRight,
                                 child: InkWell(onTap: (){searchdmdController.fetchDepartment(context);}, child: Icon(Icons.refresh, color: Colors.grey)))
                           ],
                         ),
                       ),
                     );
                   }
                   else if(searchdmdController.departState == DepartmentState.Idle){
                     return Container(
                       height: 45,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(4.0)),
                           border: Border.all(color: Colors.grey, width: 1)),
                       alignment: Alignment.center,
                       child: Padding(
                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text("Select Department", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                             Container(
                                 height: 24,
                                 width: 24,
                                 alignment: Alignment.centerRight,
                                 child: InkWell(onTap: (){searchdmdController.fetchDepartment(context);}, child: Icon(Icons.refresh, color: Colors.grey)))
                           ],
                         ),
                       ),
                     );
                   }
                   return SizedBox();
                 }),
                 SizedBox(height: 10.0),
                 Text("Demand Status", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                 SizedBox(height: 10.0),
                 DropdownSearch<String>(
                   key: demandKey,
                   selectedItem: selectedstatus,
                   items: (filter, infiniteScrollProps) => statusOptions.map((e) => e['label'] as String).toList(),
                   decoratorProps: DropDownDecoratorProps(
                     decoration: InputDecoration(
                       labelText: "Select Status",
                       contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                       hintText: "Choose an option",
                       border: OutlineInputBorder(),
                     )
                   ),
                   onChanged: (String? value) {
                     final selectedOption = statusOptions.firstWhere((element) => element['label'] == value);
                     selectedstatus = value!;
                     statusCode = selectedOption['value'];
                     debugPrint("Selected Value: ${selectedOption['value']}");
                   },
                   popupProps: PopupProps.menu(showSearchBox: true, fit: FlexFit.loose, constraints: BoxConstraints(maxHeight: Get.height * 0.45)),
                 ),
                 SizedBox(height: 15.0),
                 Padding(padding: EdgeInsets.symmetric(horizontal: Get.width * 0.40), child: Text("OR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                 SizedBox(height: 10.0),
                 Text("Demand No.", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                 SizedBox(height: 10.0),
                 TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _demandnumController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    labelText: "Enter Demand No.",
                    labelStyle: TextStyle(fontSize: 15),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF00008B), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusColor: Colors.red.shade800,
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (pin) {
                    return null;
                  },
                ),
                 SizedBox(height: 20.0),
                 ElevatedButton(
                  onPressed: () {
                     if(selectedDemand == "New Demand" && _demandnumController.text.length == 0){
                       if(fromDate != 'from' && toDate != 'to' && selectedstatus != "All" && selectedDepart != "All"){
                         Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['N', fromDate, toDate, deptCode, statusCode, "-1", '98', '05']);
                       }
                       else if(fromDate != 'from' && toDate != 'to' && selectedstatus == "All" && selectedDepart == "All"){
                         Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['N', fromDate, toDate, "-99", "-99", "-1", '98', '05']);
                       }
                       else {
                         AapoortiUtilities.showInSnackBar(
                             context, "Please select required fields");
                       }
                     }
                     else if(selectedDemand == "Old Demand" && _demandnumController.text.length == 0){
                       // if(fromDate != 'from' && toDate != 'to' && selectedstatus != "All" && selectedDepart != "All"){
                       //   Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['O', fromDate, toDate, deptCode, statusCode, "-1", '98', '05']);
                       // }
                       // else if(fromDate != 'from' && toDate != 'to' && selectedstatus == "All" && selectedDepart == "All"){
                       //   Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['N', fromDate, toDate, "-99", "-99", "-1", '98', '05']);
                       // }
                       // else{
                       //   AapoortiUtilities.showInSnackBar(context, "Please select required fields");
                       // }
                       ToastMessage.showSnackBar("Message", "Comming Soon!!", Colors.teal);
                     }
                     else if(selectedDemand == "New Demand" && _demandnumController.text.length != 0){
                       Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['N', "-1", "-1", "-1", "-1", _demandnumController.text.trim(), '98', '05']);
                     }
                     else if(selectedDemand == "Old Demand" && _demandnumController.text.length != 0 && fromDate != '' && toDate != ''){
                       //Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['O', "-1", "-1", "-1", "-1", _demandnumController.text.trim(), '98', '05']);
                       ToastMessage.showSnackBar("Message", "Comming Soon!!", Colors.teal);
                     }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.indigo.shade400,
                    fixedSize: Size(Get.width, 55),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    side: const BorderSide(color: Colors.black, width: 1), // Border
                    elevation: 10, // Elevation for shadow effect
                  ),
                  child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CustomSelectionContainer extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CustomSelectionContainer({
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blueAccent : Colors.grey,
          width: 2,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
