import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:intl/intl.dart';

import 'package:flutter_app/udm/crn_digitally_signed/view_model/CrnMyfinalisedViewModel.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/NoConnection.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:provider/provider.dart';

class CrnmyfinalisedScreen extends StatefulWidget {
  const CrnmyfinalisedScreen({Key? key}) : super(key: key);

  @override
  State<CrnmyfinalisedScreen> createState() => _CrnmyfinalisedScreenState();
}

class _CrnmyfinalisedScreenState extends State<CrnmyfinalisedScreen> {

  ScrollController _scrollController = ScrollController();

  String fromdate = "";
  String todate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setDate();
      Provider.of<CrnMyfinalisedViewModel>(context, listen: false).getCrnMyfinalisedData(fromdate, todate, context);
    });
    // Future.delayed(Duration(milliseconds: 400)).then((value){
    //   Provider.of<CrnMyfinalisedViewModel>(context, listen: false).getCrnMyfinalisedData(fromdate, todate, context);
    // });
  }

  void setDate(){
    final DateTime tilld = DateTime.now();
    final DateTime fromd = DateTime.now().subtract(const Duration(days: 182));
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    fromdate = formatter.format(fromd);
    todate = formatter.format(tilld);
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
                        child: Consumer<CrnMyfinalisedViewModel>(builder: (context, value, child){
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
                        child: Consumer<CrnMyfinalisedViewModel>(builder: (context, value, child){
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
                Consumer<CrnMyfinalisedViewModel>(builder: (context, value, child){
                  if(value.monthcountstate == CrnMyfinalisedCheckMonthState.greater){
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
                          Provider.of<CrnMyfinalisedViewModel>(context, listen: false).getCrnMyfinalisedData(fromdate, todate, context);
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
          Consumer<CrnMyfinalisedViewModel>(builder: (context, value, child) {
            if(value.state == CrnMyfinalisedViewModelState.Busy){
              return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(strokeWidth: 2.0, color: Colors.black),
                      SizedBox(height: 4),
                      Text(language.text('pw'), style: TextStyle(color: Colors.black, fontSize: 16))
                    ],
                  )
              );
            }
            else{
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                  child: ListView.builder(
                      itemCount: value.crnmyfinalisedlistdata.length,
                      controller: _scrollController,
                      itemBuilder: (context, index){
                        return Stack(
                          children: [
                            Card(
                              elevation: 8.0,
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
                                                  child: Text(value.crnmyfinalisedlistdata[index].vrnumber.toString()+" "+value.crnmyfinalisedlistdata[index].vrdate.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14))
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
                                                  child: value.crnmyfinalisedlistdata[index].ponumber == null ? Text("*********", maxLines: 3, style: TextStyle(color: Colors.grey, fontSize: 14))
                                                      : Text(value.crnmyfinalisedlistdata[index].ponumber.toString()+" "+value.crnmyfinalisedlistdata[index].podate.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14)))
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
                                        Text(language.text('finalisedbyon'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                        value.crnmyfinalisedlistdata[index].postname != null ? Text(value.crnmyfinalisedlistdata[index].approvername.toString()+"\n"+value.crnmyfinalisedlistdata[index].postname.toString()+"\n"+value.crnmyfinalisedlistdata[index].authdate.toString(), maxLines: 5, style: TextStyle(color: Colors.black, fontSize: 14))
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
                                                child: Text(value.crnmyfinalisedlistdata[index].plno.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('vendorname'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.42,
                                                child: Text(value.crnmyfinalisedlistdata[index].firmaccountname.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14)))
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
                                        Text(value.crnmyfinalisedlistdata[index].itemdesc.toString(), maxLines: 5, style: TextStyle(color: Colors.black, fontSize: 14))
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
                                                child: Text(value.crnmyfinalisedlistdata[index].qtyreceived.toString()+" "+value.crnmyfinalisedlistdata[index].pounitname.toString(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('recdvalue'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.40,
                                                child: Text(value.crnmyfinalisedlistdata[index].qtyrecvdval.toString(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
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
                                                child: value.crnmyfinalisedlistdata[index].qtyaccepted == null ? Text("NA", style: TextStyle(color: Colors.grey, fontSize: 14)) : Text(value.crnmyfinalisedlistdata[index].qtyaccepted.toString()+" "+value.crnmyfinalisedlistdata[index].pounitname.toString(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('acceptvalue'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.40,
                                                child: value.crnmyfinalisedlistdata[index].trvalue == null ? Text("NA", style: TextStyle(color: Colors.grey, fontSize: 14)) : Text(value.crnmyfinalisedlistdata[index].trvalue.toString().trim(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(language.text('dropremarks'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                        value.crnmyfinalisedlistdata[index].dropcomment == null ? Text("NA", style: TextStyle(color: Colors.red, fontSize: 14)) : Text(value.crnmyfinalisedlistdata[index].dropcomment.toString(), maxLines: 5, style: TextStyle(color: Colors.red, fontSize: 14))
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    // Align(
                                    //   alignment: Alignment.topRight,
                                    //   child: ElevatedButton(
                                    //       style: ElevatedButton.styleFrom(shape: CircleBorder()),
                                    //       onPressed: () async{
                                    //         bool check = await UdmUtilities.checkconnection();
                                    //         if(check == true) {
                                    //           var fileUrl = value.crnmyfinalisedlistdata[index].filepath.toString();
                                    //           var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                    //           UdmUtilities.ackAlert(context, fileUrl, fileName);
                                    //         } else{
                                    //           Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                    //         }
                                    //       },
                                    //       child: Icon(
                                    //           Typicons.download,
                                    //           color: Colors.white,
                                    //           size: 20)),
                                    // )
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('status'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.40,
                                                child: Text(value.crnmyfinalisedlistdata[index].crnstatus.toString(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14))
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(shape: CircleBorder(),backgroundColor: Colors.red.shade300),
                                                onPressed: () async{
                                                  bool check = await UdmUtilities.checkconnection();
                                                  if(check == true) {
                                                    var fileUrl = "https://www.ireps.gov.in/"+value.crnmyfinalisedlistdata[index].filepath.toString();
                                                    var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                                    UdmUtilities.openPdfBottomSheet(context, fileUrl, fileName, language.text('crndigisigned'));
                                                    //UdmUtilities.ackAlert(context, fileUrl, fileName);
                                                  } else{
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                                  }
                                                },
                                                //color: Theme.of(context).accentColor,
                                                child: Icon(
                                                  Typicons.download,
                                                  color: Colors.white,
                                                  size: 20,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
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
