import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcAwaitingViewModel.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/utils/NoConnection.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:provider/provider.dart';


class CrcAwaitingApprovalScreen extends StatefulWidget {
  const CrcAwaitingApprovalScreen({Key? key}) : super(key: key);

  @override
  State<CrcAwaitingApprovalScreen> createState() => _CrcAwaitingApprovalScreenState();
}

class _CrcAwaitingApprovalScreenState extends State<CrcAwaitingApprovalScreen> with SingleTickerProviderStateMixin{

  ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;
  bool _showFAB = false;
  bool _isInit = true;
  bool _isDiscovering = true;

  String fromdate = "";
  String todate = "";

  int _checkvalue = 0;

  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //_navigator.pushAndRemoveUntil(, (route) => ...);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDate();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<CrcAwaitingViewModel>(context, listen: false).getCrcAwaitData(fromdate, todate, context);
    });
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
      floatingActionButton: _showFAB ? IRUDMConstants().floatingAnimat(_isScrolling, _isDiscovering, this, _scrollController, context) : const SizedBox(width: 56, height: 120),
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
                        child: Consumer<CrcAwaitingViewModel>(builder: (context, value, child){
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
                        child: Consumer<CrcAwaitingViewModel>(builder: (context, value, child){
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
                Consumer<CrcAwaitingViewModel>(builder: (context, value, child){
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
                          Provider.of<CrcAwaitingViewModel>(context, listen: false).getCrcAwaitData(fromdate, todate, context);
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
          Consumer<CrcAwaitingViewModel>(builder: (context, value, child) {
            if(value.state == CrcAwaitingViewModelDataState.Busy){
              return Expanded(child: Center(child: CircularProgressIndicator()));
            }
            else{
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                  child: ListView.builder(
                      itemCount: value.crcawaitingdatalist.length,
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
                                                  child: Text(value.crcawaitingdatalist[index].vrnumber.toString()+" "+value.crcawaitingdatalist[index].vrdate.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14))
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
                                                  child: value.crcawaitingdatalist[index].ponumber == null ? Text("*********", maxLines: 3, style: TextStyle(color: Colors.grey, fontSize: 14))
                                                      : Text(value.crcawaitingdatalist[index].ponumber.toString()+" "+value.crcawaitingdatalist[index].podate.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14)))
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
                                        Text(language.text('forwardedfrom'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                        value.crcawaitingdatalist[index].sendername != null ? Text(value.crcawaitingdatalist[index].sendername.toString()+"\n"+value.crcawaitingdatalist[index].consname.toString()+"\n"+value.crcawaitingdatalist[index].authdate.toString(), maxLines: 5, style: TextStyle(color: Colors.black, fontSize: 14))
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
                                                child: Text(value.crcawaitingdatalist[index].plno.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('vendorname'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.42,
                                                child: Text(value.crcawaitingdatalist[index].firmaccountname.toString(), maxLines: 3, style: TextStyle(color: Colors.black, fontSize: 14)))
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
                                        Text(value.crcawaitingdatalist[index].itemdesc.toString(), maxLines: 5, style: TextStyle(color: Colors.black, fontSize: 14))
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
                                                child: Text(value.crcawaitingdatalist[index].qtyreceived.toString()+" "+value.crcawaitingdatalist[index].pounitname.toString(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('recdvalue'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.40,
                                                child: Text(value.crcawaitingdatalist[index].qtyrecvdval.toString(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
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
                                                child: value.crcawaitingdatalist[index].qtyaccepted == null ? Text("NA", style: TextStyle(color: Colors.grey, fontSize: 14)) : Text(value.crcawaitingdatalist[index].qtyaccepted.toString()+" "+value.crcawaitingdatalist[index].pounitname.toString(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(language.text('acceptvalue'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)),
                                            SizedBox(
                                                width: size.width * 0.40,
                                                child: value.crcawaitingdatalist[index].trvalue == null ? Text("NA", style: TextStyle(color: Colors.grey, fontSize: 14)) : Text(value.crcawaitingdatalist[index].trvalue.toString().trim(), maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 14)))
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(shape: CircleBorder()),
                                          onPressed: () async{
                                            bool check = await UdmUtilities.checkconnection();
                                            if(check == true) {
                                              var fileUrl = "https://www.ireps.gov.in/"+value.crcawaitingdatalist[index].filepath.toString();
                                              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                              UdmUtilities.ackAlert(context, fileUrl, fileName);
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