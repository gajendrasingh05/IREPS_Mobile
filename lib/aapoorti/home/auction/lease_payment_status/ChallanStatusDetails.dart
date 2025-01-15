import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/aapoorti/home/auction/lease_payment_status/ChallanStatus.dart';

class ChallanStatusDetails extends StatelessWidget {
  static const routename = "/ChallanStatusDetails";

  double? width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    ChallanStatus challanStatus = ModalRoute.of(context)!.settings.arguments as ChallanStatus;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Parcel Payment Status",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    children: const [
                      SizedBox(height: 10),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage:
                            AssetImage('assets/indian_railway2.png'),
                        radius: 35,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Challan Payment Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF00008B),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
                // ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 6, top: 9, right: 6),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Card(
                            color: Colors.lightBlue[50],
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7.0,
                                  horizontal: 12,
                                ).copyWith(right: 0),
                                //==========================================
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          // SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 19,
                                                  child: Text(
                                                    "Train No.",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      // fontWeight:
                                                      //     FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  )),
                                              //SizedBox(width: 15),
                                              Text(": "),
                                              Expanded(
                                                flex: 30,
                                                child: Text(
                                                  challanStatus.trainNO,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 19,
                                                child: Text(
                                                  "Type:",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              //SizedBox(width: 15),
                                              Text(": "),
                                              Expanded(
                                                flex: 30,
                                                child: Text(
                                                  challanStatus.type,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 19,
                                                child: Text(
                                                  "Value:",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              //SizedBox(width: 15),
                                              Text(": "),
                                              Expanded(
                                                flex: 30,
                                                child: Text(
                                                  challanStatus.value,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 19,
                                                child: Text(
                                                  "Loading date:",
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              //SizedBox(width: 10),
                                              Text(": "),
                                              Expanded(
                                                flex: 30,
                                                child: Text(
                                                  challanStatus.loadingDATE,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                                //================================================
                                ),
                          ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),

                          Card(
                            // color: const Color(0xFFFDEDDE),
                            color: Colors.lightBlue[50],
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 7.0,
                                horizontal: 12,
                              ).copyWith(right: 0),
                              //==========================================
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        // SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                flex: 20,
                                                child: Text(
                                                  "Firm Name",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // fontWeight:
                                                    //     FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                )),
                                            //SizedBox(width: 15),
                                            Text(": "),
                                            Expanded(
                                              flex: 30,
                                              child: Text(
                                                "${challanStatus.firmNAME ?? "NA"}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 20,
                                              child: Text(
                                                "Contract No.",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                            // SizedBox(width: 15),
                                            Text(": "),
                                            Expanded(
                                              flex: 30,
                                              child: Text(
                                                challanStatus.contractNO ??
                                                    "NA",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                flex: 20,
                                                child: Text(
                                                  "Contract Date",
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // fontWeight:
                                                    //     FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                )),
                                            //  SizedBox(width: 15),
                                            Text(": "),
                                            Expanded(
                                              flex: 30,
                                              child: Text(
                                                challanStatus.contractDATE ??
                                                    "NA",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Payment details for loading date (${challanStatus.loadingDATE})",
                              softWrap: false,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          Card(
                            // color: const Color(0xFFFDEDDE),
                            color: Colors.lightBlue[50],
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7.0,
                                  horizontal: 12,
                                ).copyWith(right: 0),
                                //==========================================
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          //SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 20,
                                                child: Text(
                                                  "G. Payment Amt.",
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              // SizedBox(width: 15),
                                              Text(": "),
                                              Expanded(
                                                flex: 30,
                                                child: Text(
                                                  "${challanStatus.grossPAYMENTAMOUNT ?? "NA"}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 20,
                                                child: Text(
                                                  "License Fee Amt.",
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              //SizedBox(width: 15),
                                              Text(": "),
                                              Expanded(
                                                flex: 30,
                                                child: Text(
                                                  "${challanStatus.licenseFEEAMOUNT ?? "NA"}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 20,
                                                child: Text(
                                                  "Status",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              // SizedBox(width: 15),
                                              Text(": "),
                                              Expanded(
                                                flex: 30,
                                                child: Text(
                                                  challanStatus.status ?? "NA",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                                //================================================
                                ),
                          ),
                          TimeStampText(),
                        ],
                      ),
                    ),
                  ],
                ),
                //),
                // ),
                // ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeStampText extends StatefulWidget {
  @override
  State<TimeStampText> createState() => _TimeStampTextState();
}

class _TimeStampTextState extends State<TimeStampText> {
  var timestamp;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      var dt = DateTime.now();
      timestamp = "${dt.year}-" +
          dt.month.toString().padLeft(2, '0') +
          "-" +
          dt.day.toString().padLeft(2, '0') +
          " " +
          dt.hour.toString().padLeft(2, '0') +
          ":" +
          dt.minute.toString().padLeft(2, '0');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Above Information was fetched at ${timestamp}",
        softWrap: false,
        overflow: TextOverflow.visible,
        style: TextStyle(
          //fontSize: 12.0,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
