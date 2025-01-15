import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcAwaitingViewModel.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcMyforwardedViewModel.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/NoConnection.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:provider/provider.dart';

class CrcmyforwardedScreen extends StatefulWidget {
  const CrcmyforwardedScreen({Key? key}) : super(key: key);

  @override
  State<CrcmyforwardedScreen> createState() => _CrcmyforwardedScreenState();
}

class _CrcmyforwardedScreenState extends State<CrcmyforwardedScreen> {

  ScrollController _scrollController = ScrollController();

  String fromdate = "";
  String todate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setDate();
    });
  }

  Future<void> setDate() async{
    final DateTime tilld = DateTime.now();
    final DateTime fromd = DateTime.now().subtract(const Duration(days: 182));
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    fromdate = formatter.format(fromd);
    todate = formatter.format(tilld);
    await Provider.of<CrcMyforwardedViewModel>(context, listen: false).getCrcMyforwardedData(fromdate, todate, context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //floatingActionButton: _showFAB ? IRUDMConstants().floatingAnimat(_isScrolling, _isDiscovering, this, _scrollController, context) : const SizedBox(width: 56, height: 120),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Consumer<CrcMyforwardedViewModel>(builder: (context, value, child){
                          return FormBuilderDateTimePicker(
                            name: 'FromDate',
                            initialDate: DateTime.now().subtract(const Duration(days: 182)),
                            initialValue: DateTime.now().subtract(const Duration(days: 182)),
                            inputType: InputType.date,
                            format: DateFormat('dd-MM-yyyy'),
                            onChanged: (datevalue){
                              final DateFormat formatter = DateFormat('dd-MM-yyyy');
                              fromdate = formatter.format(datevalue!);
                              value.checkdateDiff(fromdate, todate, formatter, context);
                              //_checkdateDiff(formatter.format(value!), todate, formatter);
                            },
                            decoration: InputDecoration(
                              labelText: language.text('datefrom'),
                              hintText: language.text('datefrom'),
                              contentPadding: EdgeInsetsDirectional.all(5),
                              suffixIcon: Icon(Icons.calendar_month),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1))
                            ),
                          );
                        }),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Consumer<CrcMyforwardedViewModel>(builder: (context, value, child){
                          return FormBuilderDateTimePicker(
                            name: 'ToDate',
                            initialDate: DateTime.now(),
                            initialValue: DateTime.now(),
                            inputType: InputType.date,
                            format: DateFormat('dd-MM-yyyy'),
                            onChanged: (datevalue){
                              final DateFormat formatter = DateFormat('dd-MM-yyyy');
                              todate = formatter.format(datevalue!);
                              value.checkdateDiff(fromdate, todate, formatter, context);
                            },
                            decoration: InputDecoration(
                              labelText: language.text('dateto'),
                              hintText: language.text('dateto'),
                              contentPadding: EdgeInsetsDirectional.all(5),
                              suffixIcon: Icon(Icons.calendar_month),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1))
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Consumer<CrcMyforwardedViewModel>(builder: (context, value, child){
                  if(value.monthcountstate == CrcAwaitCheckMonthState.greater){
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 45,
                        width: size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        alignment: Alignment.center,
                        child: Text(language.text('searchbtn'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    );
                  }
                  else{
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: (){
                          Provider.of<CrcMyforwardedViewModel>(context, listen: false).getCrcMyforwardedData(fromdate, todate, context);
                        },
                        child: Container(
                          height: 45,
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          alignment: Alignment.center,
                          child: Text(language.text('searchbtn'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
          Consumer<CrcMyforwardedViewModel>(builder: (context, value, child) {
            if(value.state == CrcMyforwardedViewModelState.Busy){
              return Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 2.0, color: Colors.black),
                  SizedBox(height: 4),
                  Text(language.text('pw'), style: TextStyle(color: Colors.black, fontSize: 16))
                ],
              ));
            }
            else{
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                  child: ListView.builder(
                      itemCount: value.crcmyforwarededlistdata.length,
                      controller: _scrollController,
                      itemBuilder: (context, index){
                        return Stack(
                          children: [
                            Card(
                              elevation: 8.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(
                                    color: Colors.red.shade300,
                                    width: 1.0,
                                  )
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    color: Colors.white
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(language.text('vouchernumdate'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                              SizedBox(
                                                  width: size.width * 0.40,
                                                  child: Text(value.crcmyforwarededlistdata[index].vrnumber.toString()+" "+value.crcmyforwarededlistdata[index].vrdate.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14))
                                              )
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(language.text('ponumdate'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                              SizedBox(
                                                  width: size.width * 0.40,
                                                  child: value.crcmyforwarededlistdata[index].ponumber == null ? Text("*********", maxLines: 3, style: TextStyle(color: Colors.grey, fontSize: 14))
                                                      : Text(value.crcmyforwarededlistdata[index].ponumber.toString()+" "+value.crcmyforwarededlistdata[index].podate.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14)))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(language.text('forwardedtoon'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                        value.crcmyforwarededlistdata[index].postname != null ? Text(value.crcmyforwarededlistdata[index].postname.toString()+"\n"+value.crcmyforwarededlistdata[index].authdate.toString(), maxLines: 5, style: TextStyle(color: Colors.black, fontSize: 14))
                                            : Text("********", maxLines: 5, style: TextStyle(color: Colors.grey, fontSize: 14))
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('plnumitemcode'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.40,
                                                child: Text(value.crcmyforwarededlistdata[index].plno.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('vendorname'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.42,
                                                child: Text(value.crcmyforwarededlistdata[index].firmaccountname.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(language.text('itemdesc'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                        Text(value.crcmyforwarededlistdata[index].itemdesc.toString(), maxLines: 5, style: TextStyle(color: Colors.black, fontSize: 14))
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('recdqty'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.40,
                                                child: Text(value.crcmyforwarededlistdata[index].qtyreceived.toString()+" "+value.crcmyforwarededlistdata[index].pounitname.toString(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('recdvalue'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.40,
                                                child: Text(value.crcmyforwarededlistdata[index].qtyrecvdval.toString(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('acceptqty'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.40,
                                                child: value.crcmyforwarededlistdata[index].qtyaccepted == null ? Text("NA", style: TextStyle(color: Colors.grey, fontSize: 14)) : Text(value.crcmyforwarededlistdata[index].qtyaccepted.toString()+" "+value.crcmyforwarededlistdata[index].pounitname.toString(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('acceptvalue'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.40,
                                                child: value.crcmyforwarededlistdata[index].trvalue == null ? Text("NA", style: TextStyle(color: Colors.grey, fontSize: 14)) : Text(value.crcmyforwarededlistdata[index].trvalue.toString().trim(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(shape: CircleBorder(), backgroundColor: Colors.red.shade300),
                                          onPressed: () async{
                                            bool check = await UdmUtilities.checkconnection();
                                            if(check == true) {
                                              var fileUrl = "https://www.ireps.gov.in/"+value.crcmyforwarededlistdata[index].filepath.toString();
                                              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                              //UdmUtilities.ackAlert(context, fileUrl, fileName);
                                              UdmUtilities.openPdfBottomSheet(context, fileUrl, fileName, language.text('crcdigisigned'));
                                            } else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                            }
                                          },
                                          child: Icon(
                                              Typicons.download,
                                              color: Colors.white,
                                              size: 20)),
                                    )
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Column(
                                    //       mainAxisAlignment: MainAxisAlignment.start,
                                    //       crossAxisAlignment: CrossAxisAlignment.start,
                                    //       children: [
                                    //         Text(language.text('status'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                    //         SizedBox(
                                    //             width: size.width * 0.40,
                                    //             child: Text(value.crcawaitingdatalist![index].status.toString(), maxLines: 1, style: TextStyle(color: Colors.grey, fontSize: 14))
                                    //         )
                                    //       ],
                                    //     ),
                                    //     Column(
                                    //       mainAxisAlignment: MainAxisAlignment.start,
                                    //       crossAxisAlignment: CrossAxisAlignment.center,
                                    //       children: [
                                    //         ElevatedButton(
                                    //             style: ElevatedButton.styleFrom(shape: CircleBorder()),
                                    //             onPressed: () {},
                                    //             //color: Theme.of(context).accentColor,
                                    //             child: Icon(
                                    //               Typicons.download,
                                    //               color: Colors.white,
                                    //               size: 20,
                                    //             )),
                                    //       ],
                                    //     )
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                top: 1,
                                left: 2,
                                child: CircleAvatar(
                                  backgroundColor: Colors.red[300],
                                  radius: 12,
                                  child: Text(
                                    '${index+1}',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ), //Text
                                )
                            )
                          ],
                        );
                      }
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
