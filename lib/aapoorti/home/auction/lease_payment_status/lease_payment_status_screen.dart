import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiException.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/auction/lease_payment_status/ChallanStatusDetails.dart';
import 'package:flutter_app/aapoorti/home/auction/lease_payment_status/leaseApiProvider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/aapoorti/home/auction/lease_payment_status/custome_radio_button.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

import 'CustomRadioController.dart';

class LeasePaymentStatus extends StatefulWidget {
  static const routeName = "/lease-payment-status";
  @override
  State<LeasePaymentStatus> createState() => _LeasePaymentStatusState();
}

class _LeasePaymentStatusState extends State<LeasePaymentStatus> {
  var width, height, padding;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _trainController = TextEditingController();
  CustomRadioController typecustomRadioController = CustomRadioController(0);

  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  FocusNode dropDownFocusNode = FocusNode();
  List<String> subTypeItems = ["F1", "F2", "R1"];
  int dropDownValue = 0;
  List<String> types = ["SLR", "VP"];

  String? trainNo, type, subType, date;

  ChallanStatusProvider? _challanStatusProvider;
  ProgressDialog? pr;
  @override
  void initState() {
    // TODO: implement initState
    type = types[0];
    pr = ProgressDialog(context);
    _challanStatusProvider =
        Provider.of<ChallanStatusProvider>(context, listen: false);
    super.initState();
  }

  void validateAndSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String temp = DateFormat("dd/MM/yyyy").format(selectedDate);
      String input = "$trainNo~$type~$subType~$temp";

      try {
        await pr!.show();

        await _challanStatusProvider!.getStatus(input);

        await pr!.hide();
        if (ChallanStatusProvider.apiStatus == ApiStatus.finished) {
          Navigator.of(context).pushNamed(
            ChallanStatusDetails.routename,
            arguments: _challanStatusProvider!.challanStatus,
          );
        } else if (ChallanStatusProvider.apiStatus == ApiStatus.none) {
          Navigator.of(context).pushNamed("/nodata");
        }
      } on SocketException catch (_) {
        await pr!.hide();
        Future.delayed(
            Duration.zero,
                () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Internet Connectivity issue"),
                backgroundColor: Colors.red[300],
              ),
            ));
      } on TimeoutException catch (_) {
        await pr!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internet Connectivity issue"),
            backgroundColor: Colors.red[300],
          ),
        );
      } on FormatException catch (_) {
        await pr!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Errorneous response"),
            backgroundColor: Colors.red[300],
          ),
        );
      } on AapoortiException catch (_) {
        await pr!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Service Not Available!"),
            backgroundColor: Colors.red[300],
          ),
        );
      } on Exception catch (_) {
        await pr!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unexpected Error!"),
            backgroundColor: Colors.red[300],
          ),
        );
      } catch (error) {
        await pr!.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unexpected Error!"),
            backgroundColor: Colors.red[300],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.cyan[400],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Padding(padding: EdgeInsets.only(left: 10.0)),
              Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Parcel Payment(Leasing)',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
              Expanded(
                  child: SizedBox(
                    width: 2,
                  )),
              IconButton(
                alignment: Alignment.centerRight,
                icon: Icon(
                  Icons.home,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                        counterText: "",
                        icon: Icon(
                          Icons.train,
                          color: Colors.black,
                        ),
                        hintText: 'Enter Train no.',
                        filled: true,
                        labelText: 'Train No.',
                        fillColor: Colors.white,
                        hoverColor: Colors.cyan,
                        labelStyle: TextStyle(color: Colors.cyan),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.cyan, width: 1.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.red, width: 1.0),
                        ),
                      ),
                      onSaved: (value) {
                        trainNo = value!;
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Train no. is required';
                        } else if (value?.length != 5) {
                          return 'Train no. should be in 5 digit';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              CustomRadioButton(
                  customRadioController: typecustomRadioController,
                  //label: "Type",
                  values: types,
                  onSaved: (value) {},
                  onChanged: (value) {
                    setState(() {
                      dropDownValue = 0;
                      subTypeItems = value == 0
                          ? ["F1", "F2", "R1"]
                          : ["1", "2", "3", "4", "5"];
                      type = types[value];
                    });
                    typecustomRadioController.removeFocus();
                    FocusScope.of(context).requestFocus(dropDownFocusNode);
                  }),
              SizedBox(height: 15),
              DropdownButtonFormField(
                focusNode: dropDownFocusNode,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.account_tree_sharp,
                    color: Colors.black,
                  ),
                  fillColor: Colors.white,
                  hoverColor: Colors.cyan,
                  labelStyle: TextStyle(color: Colors.cyan),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.cyan, width: 1.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.red, width: 1.0),
                  ),
                  label: Text(
                    "Value",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  filled: true,
                ),
                value: dropDownValue,
                items: List.generate(
                  subTypeItems.length,
                      (index) => DropdownMenuItem<int>(
                    value: index,
                    child: Text(subTypeItems[index]),
                  ),
                ),
                onSaved: (value) {
                  subType = subTypeItems[value as int];
                },
                onChanged: (value) {
                  //setState(() {
                  dropDownValue = value as int;
                  //});
                },
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.parse("2022-01-01"),
                          lastDate: DateTime.now().add(Duration(days: 7)),
                        );
                        if (picked != null)
                          setState(() {
                            selectedDate = picked;
                            _dateController.text = DateFormat("dd/MMM/yyyy")
                                .format(selectedDate);
                          });
                      },
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                        ),
                        hintText: 'Pick a date',
                        filled: true,
                        labelText: 'Date',
                        fillColor: Colors.white,
                        hoverColor: Colors.cyan,
                        labelStyle: TextStyle(color: Colors.cyan),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.cyan, width: 1.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.red, width: 1.0),
                        ),
                      ),
                      onSaved: (value) {
                        date = _dateController.text;
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Date is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan[400],
                        ),
                        onPressed: () {
                          validateAndSave();
                          FocusScope.of(context).unfocus();
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          _formKey.currentState?.reset();
                          _dateController.clear();
                          typecustomRadioController.reset();
                          setState(() {
                            subTypeItems = ["F1", "F2", "R1"];
                          });
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
      // ),
    );
  }
}

// class LeasePaymentStatus extends StatefulWidget {
//   static const routeName = "/lease-payment-status";
//   @override
//   State<LeasePaymentStatus> createState() => _LeasePaymentStatusState();
// }
//
// class _LeasePaymentStatusState extends State<LeasePaymentStatus> {
//   var width, height, padding;
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController _singletrainController = TextEditingController();
//   TextEditingController _firsttrainController = TextEditingController();
//   TextEditingController _secondtrainController = TextEditingController();
//   CustomRadioController typecustomRadioController = CustomRadioController(0);
//
//   TextEditingController _dateController = TextEditingController();
//   DateTime selectedDate = DateTime.now();
//   FocusNode dropDownFocusNode = FocusNode();
//   List<String> subTypeItems = ["F1", "F2", "R1"];
//   int dropDownValue = 0;
//   List<String> types = ["SLR", "VP"];
//
//   String trainNo, type, subType, date;
//
//   ChallanStatusProvider _challanStatusProvider;
//   ProgressDialog pr;
//
//   @override
//   void initState() {
//     type = types[0];
//     pr = ProgressDialog(context);
//     _challanStatusProvider = Provider.of<ChallanStatusProvider>(context, listen: false);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _singletrainController.dispose();
//     _firsttrainController.dispose();
//     _secondtrainController.dispose();
//     //typecustomRadioController.dispose();
//     super.dispose();
//   }
//
//   void validateAndSave(String trainno) async {
//     if(_formKey.currentState.validate()) {
//       _formKey.currentState.save();
//       String selectDate = DateFormat("dd/MM/yyyy").format(selectedDate);
//       String input = _challanStatusProvider.getrdtraintype == "Multi" && _challanStatusProvider.gettraintype == "SLR" ? "$trainno~MSLR~$subType~$selectDate" : "$trainno~$type~$subType~$selectDate";
//
//       print("input $input");
//
//       try {
//         await pr.show();
//         await _challanStatusProvider.getStatus(input);
//         await pr.hide();
//         if(ChallanStatusProvider.apiStatus == ApiStatus.finished) {
//           Navigator.of(context).pushNamed(ChallanStatusDetails.routename, arguments: _challanStatusProvider.challanStatus);
//         }
//         else if (ChallanStatusProvider.apiStatus == ApiStatus.none) {
//           Navigator.of(context).pushNamed("/nodata");
//         }
//       } on SocketException catch (_) {
//         await pr.hide();
//         Future.delayed(Duration.zero, () => AapoortiUtilities.showInSnackBar(context, "Internet Connectivity issue!!"));
//       } on TimeoutException catch (_) {
//         await pr.hide();
//         AapoortiUtilities.showInSnackBar(context, "Internet Connectivity issue!!");
//       } on FormatException catch (_) {
//         await pr.hide();
//         AapoortiUtilities.showInSnackBar(context, "Something went wrong!!");
//       } on AapoortiException catch (_) {
//         await pr.hide();
//         AapoortiUtilities.showInSnackBar(context, "Service Not Available!!");
//       } on Exception catch (_) {
//         await pr.hide();
//         AapoortiUtilities.showInSnackBar(context, "Unexpected Error!!");
//       } catch (error) {
//         await pr.hide();
//         AapoortiUtilities.showInSnackBar(context, "Unexpected Error!!");
//       }
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     _challanStatusProvider.updateTrain("Single");
//     _challanStatusProvider.updatetraintype("SLR");
//     Navigator.of(context).pop(true);
//     return Future<bool>.value(true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     width = MediaQuery.of(context).size.width;
//     height = MediaQuery.of(context).size.height;
//     padding = MediaQuery.of(context).padding;
//     return WillPopScope(
//         child: Scaffold(
//           appBar: AppBar(
//               iconTheme: IconThemeData(color: Colors.white),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(padding: EdgeInsets.only(left: 15.0)),
//                   Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Parcel Payment Details',
//                         style: TextStyle(color: Colors.white),
//                       )),
//                   // new Padding(padding: new EdgeInsets.only(right: 15.0)),
//                   Expanded(
//                       child: SizedBox(
//                     width: 2,
//                   )),
//                   IconButton(
//                     alignment: Alignment.centerRight,
//                     icon: Icon(
//                       Icons.home,
//                     ),
//                     onPressed: () {
//                       Navigator.of(context, rootNavigator: true).pop();
//                     },
//                   ),
//                 ],
//               )),
//           body: Container(
//             height: height,
//             width: width,
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Consumer<ChallanStatusProvider>(
//                         builder: (context, provider, child) {
//                           if(provider.getrdtraintype == "Single" && provider.gettraintype == "VP") {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Train",
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16)),
//                                 SizedBox(height: 5.0),
//                                 TextFormField(
//                                   controller: _singletrainController,
//                                   keyboardType: TextInputType.number,
//                                   maxLength: 5,
//                                   decoration: InputDecoration(
//                                     hintText: "Enter train no.",
//                                     counterText: "",
//                                     //suffixIcon: _singletrainController.text.length == 5 ? Container(height: 32, width: 32, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.green), child: Icon(Icons.check)) : SizedBox(child: Text("1"),),
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 5),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.cyan, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     disabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     focusColor: Colors.red[300],
//                                     focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.red, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                   ),
//                                   onSaved: (value) {
//                                     trainNo = value;
//                                   },
//                                   validator: (value) {
//                                     if(value.isEmpty ?? false) {
//                                       return 'Train no. is required';
//                                     } else if(value.length != 5) {
//                                       return 'Train no. should be in 5 digit';
//                                     }
//                                     return null;
//                                   },
//                                   onChanged: (value) {},
//                                 )
//                               ],
//                             );
//                           }
//                           else if (provider.getrdtraintype == "Single" && provider.gettraintype == "SLR") {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Train",
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16)),
//                                 SizedBox(height: 5.0),
//                                 TextFormField(
//                                   controller: _singletrainController,
//                                   keyboardType: TextInputType.number,
//                                   maxLength: 5,
//                                   decoration: InputDecoration(
//                                     hintText: "Enter train no.",
//                                     counterText: "",
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 5),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.cyan, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     disabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     focusColor: Colors.red[300],
//                                     focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.red, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                   ),
//                                   onSaved: (value) {
//                                     trainNo = value;
//                                   },
//                                   validator: (value) {
//                                     if (value.isEmpty ?? false) {
//                                       return 'Train no. is required';
//                                     } else if (value.length != 5) {
//                                       return 'Train no. should be in 5 digit';
//                                     }
//                                     return null;
//                                   },
//                                   onChanged: (value) {},
//                                 )
//                               ],
//                             );
//                           }
//                           else if (provider.getrdtraintype == "Multi" && provider.gettraintype == "VP") {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Train",
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16)),
//                                 SizedBox(height: 5.0),
//                                 TextFormField(
//                                   controller: _singletrainController,
//                                   keyboardType: TextInputType.number,
//                                   maxLength: 5,
//                                   decoration: InputDecoration(
//                                     hintText: "Enter train no.",
//                                     counterText: "",
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 5),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.cyan, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     disabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     focusColor: Colors.red[300],
//                                     focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.red, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                   ),
//                                   onSaved: (value) {
//                                     trainNo = value;
//                                   },
//                                   validator: (value) {
//                                     if (value.isEmpty ?? false) {
//                                       return 'Train no. is required';
//                                     } else if (value.length != 5) {
//                                       return 'Train no. should be in 5 digit';
//                                     }
//                                     return null;
//                                   },
//                                   onChanged: (value) {},
//                                 )
//                               ],
//                             );
//                           }
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: [
//                                    Text("Train 1",
//                                        style: TextStyle(
//                                            color: Colors.black,
//                                            fontWeight: FontWeight.bold,
//                                            fontSize: 16)),
//                                    SizedBox(height: 5.0),
//                                    TextFormField(
//                                      controller: _firsttrainController,
//                                      keyboardType: TextInputType.number,
//                                      maxLength: 5,
//                                      decoration: InputDecoration(
//                                        hintText: "Enter first train no.",
//                                        counterText: "",
//                                        contentPadding: EdgeInsets.symmetric(
//                                            horizontal: 10, vertical: 5),
//                                        focusedBorder: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                              color: Colors.cyan, width: 1.0),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        border: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                            color: Colors.grey,
//                                          ),
//                                          borderRadius: BorderRadius.circular(10),
//                                        ),
//                                        disabledBorder: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                            color: Colors.grey,
//                                          ),
//                                          borderRadius: BorderRadius.circular(10),
//                                        ),
//                                        errorBorder: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                              color: Colors.grey, width: 1.0),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        enabledBorder: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                              color: Colors.grey, width: 1.0),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        focusColor: Colors.red[300],
//                                        focusedErrorBorder: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                              color: Colors.red, width: 1.0),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                      ),
//                                      validator: (value) {
//                                        if (value.isEmpty ?? false) {
//                                          return 'Train no. is required';
//                                        } else if (value.length != 5) {
//                                          return 'Train no. should be in 5 digit';
//                                        }
//                                        return null;
//                                      },
//                                      onChanged: (value) {},
//                                    ),
//                                  ],
//                               )),
//                               SizedBox(width: 10),
//                               Expanded(child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Train 2",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16)),
//                                   SizedBox(height: 5.0),
//                                   TextFormField(
//                                     controller: _secondtrainController,
//                                     keyboardType: TextInputType.number,
//                                     maxLength: 5,
//                                     decoration: InputDecoration(
//                                       hintText: "Enter second train no.",
//                                       counterText: "",
//                                       contentPadding: EdgeInsets.symmetric(
//                                           horizontal: 10, vertical: 5),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.cyan, width: 1.0),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                       border: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       disabledBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       errorBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.grey, width: 1.0),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.grey, width: 1.0),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                       focusColor: Colors.red[300],
//                                       focusedErrorBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.red, width: 1.0),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value.isEmpty ?? false) {
//                                         return 'Train no. is required';
//                                       } else if (value.length != 5) {
//                                         return 'Train no. should be in 5 digit';
//                                       }
//                                       return null;
//                                     },
//                                     onChanged: (value) {},
//                                   ),
//                                 ],
//                               ))
//                             ],
//                           );
//                         }),
//                     SizedBox(height: 20),
//                     CustomRadioButton(
//                         customRadioController: typecustomRadioController,
//                         values: _challanStatusProvider.types,
//                         onSaved: (value) {},
//                         onChanged: (value) {
//                           _challanStatusProvider.updatetraintype(value == 0 ? "SLR" : "VP");
//                           setState(() {
//                             dropDownValue = 0;
//                             subTypeItems = value == 0
//                                 ? ["F1", "F2", "R1"]
//                                 : ["1", "2", "3", "4", "5"];
//                             type = types[value];
//                           });
//                           typecustomRadioController.removeFocus();
//                           FocusScope.of(context).requestFocus(dropDownFocusNode);
//                         }),
//                     SizedBox(height: 20),
//                     Consumer<ChallanStatusProvider>(
//                         builder: (context, trainnum, child) {
//                           if (trainnum.gettraintype != "SLR") {
//                             return SizedBox();
//                           }
//                           return Row(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Radio<String>(
//                                     value: 'Single',
//                                     groupValue: trainnum.getrdtraintype,
//                                     onChanged: (value) {
//                                       trainnum.updateTrain(value);
//                                     },
//                                   ),
//                                   Text("Single Train",
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 16))
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Radio<String>(
//                                     value: 'Multi',
//                                     groupValue: trainnum.getrdtraintype,
//                                     onChanged: (value) {
//                                       trainnum.updateTrain(value);
//                                     },
//                                   ),
//                                   Text("Multi Train",
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 16))
//                                 ],
//                               ),
//                             ],
//                           );
//                         }),
//                     SizedBox(height: 10),
//                     DropdownButtonFormField(
//                       focusNode: dropDownFocusNode,
//                       decoration: InputDecoration(
//                         label: Text(
//                           "Value",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         filled: true,
//                         contentPadding:
//                         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                               color: Colors.cyan, width: 1.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                             color: Colors.grey,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         disabledBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                             color: Colors.grey,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                               color: Colors.grey, width: 1.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                               color: Colors.grey, width: 1.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         focusColor: Colors.red[300],
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderSide:
//                           const BorderSide(color: Colors.red, width: 1.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       // decoration: InputDecoration(
//                       //
//                       //   // icon: Icon(
//                       //   //   Icons.account_tree_sharp,
//                       //   //   color: Colors.black,
//                       //   // ),
//                       //   label: Text(
//                       //     "Value",
//                       //     style: TextStyle(
//                       //       fontSize: 16,
//                       //       fontWeight: FontWeight.w400,
//                       //     ),
//                       //   ),
//                       //   filled: true,
//                       // ),
//                       value: dropDownValue,
//                       items: List.generate(
//                         subTypeItems.length,
//                             (index) => DropdownMenuItem<int>(
//                           value: index,
//                           child: Text(subTypeItems[index]),
//                         ),
//                       ),
//                       onSaved: (value) {
//                         subType = subTypeItems[value];
//                       },
//                       onChanged: (value) {
//                         dropDownValue = value;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             controller: _dateController,
//                             readOnly: true,
//                             onTap: () async {
//                               DateTime picked = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime.parse("2022-01-01"),
//                                 lastDate:
//                                 DateTime.now().add(Duration(days: 7)),
//                               );
//                               if (picked != null)
//                                 setState(() {
//                                   selectedDate = picked;
//                                   _dateController.text =
//                                       DateFormat("dd/MMM/yyyy")
//                                           .format(selectedDate);
//                                 });
//                             },
//                             decoration: InputDecoration(
//                               suffixIcon: Icon(
//                                 Icons.calendar_month,
//                                 color: Colors.black,
//                               ),
//                               hintText: 'Pick a date',
//                               filled: true,
//                               labelText: 'Date',
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.cyan, width: 1.0),
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                   color: Colors.grey,
//                                 ),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               disabledBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                   color: Colors.grey,
//                                 ),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.grey, width: 1.0),
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.grey, width: 1.0),
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               focusColor: Colors.red[300],
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.red, width: 1.0),
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                             ),
//                             onSaved: (value) {
//                               date = _dateController.text;
//                             },
//                             validator: (value) {
//                               if (value.isEmpty ?? false) {
//                                 return 'Date is required';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 25),
//                     Consumer<ChallanStatusProvider>(
//                         builder: (context, value, child) {
//                           return Container(
//                               width: width,
//                               padding: EdgeInsets.symmetric(horizontal: 5.0),
//                               height: 45,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   MaterialButton(
//                                       height: 45,
//                                       minWidth: width * 0.40,
//                                       child: Text(
//                                         "Submit",
//                                         style: TextStyle(
//                                             fontSize: 16, color: Colors.white),
//                                       ),
//                                       shape: BeveledRectangleBorder(
//                                           side: BorderSide(
//                                               width: 1.0,
//                                               color: Colors.grey.shade300)),
//                                       onPressed: () {
//                                         if (_challanStatusProvider
//                                             .getrdtraintype ==
//                                             "Single") {
//                                           validateAndSave(
//                                               _singletrainController.text.trim());
//                                         } else {
//                                           validateAndSave(
//                                               "${_firsttrainController.text.trim()}#${_secondtrainController.text.trim()}");
//                                         }
//                                         FocusScope.of(context).unfocus();
//                                       },
//                                       color: Colors.cyan,
//                                       textColor: Colors.white),
//                                   MaterialButton(
//                                       height: 45,
//                                       minWidth: width * 0.40,
//                                       child: Text(
//                                         "Reset",
//                                         style: TextStyle(
//                                             fontSize: 16, color: Colors.white),
//                                       ),
//                                       shape: BeveledRectangleBorder(
//                                           side: BorderSide(
//                                               width: 1.0,
//                                               color: Colors.grey.shade300)),
//                                       onPressed: () {
//                                         _formKey.currentState.reset();
//                                         _dateController.clear();
//                                         typecustomRadioController.reset();
//                                         _challanStatusProvider.updateTrain("Single");
//                                         _challanStatusProvider.updatetraintype("SLR");
//                                         setState(() {
//                                           subTypeItems = ["F1", "F2", "R1"];
//                                         });
//                                       },
//                                       color: Colors.red,
//                                       textColor: Colors.white),
//                                 ],
//                               ));
//                         }),
//                     // Row(
//                     //   children: [
//                     //     Expanded(
//                     //       child: ElevatedButton(
//                     //         onPressed: () {
//                     //           validateAndSave();
//                     //           FocusScope.of(context).unfocus();
//                     //         },
//                     //         child: Text(
//                     //           "Submit",
//                     //           style: TextStyle(fontSize: 16,  color: Colors.white),
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     // SizedBox(height: 10),
//                     // Row(
//                     //   children: [
//                     //     Expanded(
//                     //       child: ElevatedButton(
//                     //         onPressed: () {
//                     //           _formKey.currentState.reset();
//                     //           _dateController.clear();
//                     //           typecustomRadioController.reset();
//                     //           setState(() {
//                     //             subTypeItems = ["F1", "F2", "R1"];
//                     //           });
//                     //         },
//                     //         child: Text(
//                     //           "Reset",
//                     //           style: TextStyle(fontSize: 16, color: Colors.white),
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // ),
//         ),
//         onWillPop: _onWillPop);
//   }
//
//
// }
