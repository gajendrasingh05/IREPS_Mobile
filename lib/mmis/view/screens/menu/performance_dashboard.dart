import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/controllers/dashboard_controller.dart';
import 'package:flutter_app/mmis/controllers/network_controller.dart';
import 'package:flutter_app/mmis/controllers/theme_controller.dart';
import 'package:flutter_app/mmis/extention/extension_util.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/view/components/bottom_Nav/bottom_nav.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}

class ChartData2 {
  final String x;
  final double y;
  final Color color;
  ChartData2(this.x, this.y, this.color);
}

class ChartData3{
  ChartData3(this.x, this.y1, this.y2, this.y3, this.y4, this.color);
  final String x;
  final double y1;
  final double y2;
  final double y3;
  final double y4;
  final Color color;
}


class PerformanceDashBoard extends StatefulWidget {

  @override
  State<PerformanceDashBoard> createState() => _PerformanceDashBoardState();
}

class _PerformanceDashBoardState extends State<PerformanceDashBoard> {
  //final controller = Get.find<DashBoardController>();
  final controller = Get.put(DashBoardController());

  final themeController =  Get.find<ThemeController>();

  //final homeController =  Get.find<HomeController>();
  final networkController = Get.put(NetworkController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedyear = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    yearslist();
  }

  List<String> yearRanges = [];
  int _selectedIndex = 2;

  void yearslist(){
    for (int i = -2; i < 1; i++) {
      yearRanges.add(generateYearRange(i));
    }
    debugPrint("year ranges $yearRanges");
    selectedyear = yearRanges[2];
  }

  String generateYearRange(int offset) {
    // Get the current year
    int currentYear = DateTime.now().year -1;

    debugPrint("current year $currentYear");

    // Calculate the start year (current year + offset)
    int startYear = currentYear + offset;

    debugPrint("start year $startYear");

    // Calculate the next year
    int endYear = startYear + 1;

    debugPrint("endYear year $endYear");

    // Return the formatted string in the form "startYear-endYear"
    return '$startYear-${endYear.toString().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        AapoortiUtilities.alertDialog(context, "MMIS");
        //_onBackPressed();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            backgroundColor: MyColor.primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
            title: Text('appName'.tr, style : TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontStyle: FontStyle.italic,fontSize: 18.0))),

        drawer: navDrawer(context, _scaffoldKey, controller, themeController),
        bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
        body: Obx((){
          if(controller.dsbState.value == DashboardState.Busy) {
            return Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.indigo));
          }
          else if(controller.dsbState.value == DashboardState.Finished){
            return SingleChildScrollView(
              child: Column(
                children: [
                  controller.dsbData.isNotEmpty ? Container(
                      height: 300.0,
                      width: Get.width,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.indigo, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                              ),
                              alignment: Alignment.center,
                              child:  Text("Summary", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              child: Container(
                                height: 45,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: yearRanges.length,
                                    itemBuilder: (context, index){
                                      bool isSelected = _selectedIndex == index;
                                      return Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                                        child: InkWell(
                                          onTap : (){
                                            setState(() {
                                              _selectedIndex = isSelected ? 0 : index;
                                              selectedyear = yearRanges[index];
                                            });
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.blue : Colors.grey[300],
                                              borderRadius: BorderRadius.circular(5.0),
                                              border: Border.all(
                                                color: isSelected ? Colors.white : Colors.grey,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Text(
                                              yearRanges[index],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected ? Colors.white : Colors.black,
                                                //color: Colors.white ,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                height: 80,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, strokeAlign: 2.0),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Demand", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                                    SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RichText(text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(text: 'Initiated :- ', style: TextStyle(color: Colors.black)),
                                            selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[0]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)) :
                                            selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
                                            TextSpan(text: controller.dsbData[2]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)),
                                          ],
                                        )),
                                        RichText(text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(text: 'Register :- ', style: TextStyle(color: Colors.black)),
                                              selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[0]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
                                              selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
                                              TextSpan(text: controller.dsbData[2]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)),
                                            ]
                                        )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              // child: Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Container(
                              //       height: 100,
                              //       width: 150,
                              //       decoration: BoxDecoration(
                              //         border: Border.all(color: Colors.grey, strokeAlign: 2.0),
                              //         color: Colors.white,
                              //       ),
                              //       padding: EdgeInsets.all(10),
                              //       child: Column(
                              //         mainAxisAlignment: MainAxisAlignment.start,
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text("Demand Initiation", style: TextStyle(fontSize: 16.0)),
                              //           SizedBox(height: 10.0),
                              //           selectedyear == "2022-23" ?
                              //           Text(controller.dsbData[0]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
                              //           selectedyear == "2023-24" ? Text(controller.dsbData[1]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
                              //               : Text(controller.dsbData[2]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
                              //         ],
                              //       ),
                              //     ),
                              //     Container(
                              //       height: 100,
                              //       width: 150,
                              //       decoration: BoxDecoration(
                              //         border: Border.all(color: Colors.grey, strokeAlign: 2.0),
                              //         color: Colors.white,
                              //       ),
                              //       padding: EdgeInsets.all(10),
                              //       child: Column(
                              //         mainAxisAlignment: MainAxisAlignment.start,
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text("Demand Register", style: TextStyle(fontSize: 16.0)),
                              //           SizedBox(height: 10.0),
                              //           selectedyear == "2022-23" ?
                              //           Text(controller.dsbData[0]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
                              //           selectedyear == "2023-24" ? Text(controller.dsbData[1]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
                              //               : Text(controller.dsbData[2]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                height: 80,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, strokeAlign: 2.0),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RichText(text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: 'Tender Published :- ', style: TextStyle(color: Colors.black)),
                                        selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[0]['tp'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)) :
                                        selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['tp'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
                                        TextSpan(text: controller.dsbData[2]['tp'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)),
                                      ],
                                    )),
                                    RichText(text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(text: 'PO Issued :-', style: TextStyle(color: Colors.black)),
                                          selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[0]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
                                          selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
                                          TextSpan(text: controller.dsbData[2]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                                        ]
                                    )),
                                  ],
                                ),
                              ),
                              // child: Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //
                              //     Container(
                              //       height: 100,
                              //       width: 150,
                              //       decoration: BoxDecoration(
                              //         border: Border.all(color: Colors.grey, strokeAlign: 2.0),
                              //         color: Colors.white,
                              //       ),
                              //       padding: EdgeInsets.all(10),
                              //       child: Column(
                              //         mainAxisAlignment: MainAxisAlignment.start,
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text("PO Issued", style: TextStyle(fontSize: 16.0)),
                              //           SizedBox(height: 10.0),
                              //           selectedyear == "2022-23" ?
                              //           Text(controller.dsbData[0]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
                              //           selectedyear == "2023-24" ? Text(controller.dsbData[1]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
                              //               : Text(controller.dsbData[2]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ),
                          ],
                        ),
                      )
                  ) : SizedBox (child: Image.asset('assets/no_data.png')),
                  // Container(
                  //   height: 120,
                  //   width: Get.width,
                  //   padding: EdgeInsets.all(10.0),
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Expanded(child: Row(children: [
                  //             Container(height: 20, width: 20, color: Colors.red),
                  //             SizedBox(width: 10),
                  //             Text("Demand Initiated")
                  //           ])),
                  //           Expanded(child: Row(children: [
                  //             Container(height: 20, width: 20, color: Colors.black),
                  //             SizedBox(width: 10),
                  //             Text("Tender Published")
                  //           ])),
                  //         ],
                  //       ),
                  //       SizedBox(height: 20),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Expanded(child: Row(children: [
                  //             Container(height: 20, width: 20, color: Colors.indigo),
                  //             SizedBox(width: 10),
                  //             Text("Demand registered")
                  //           ])),
                  //           Expanded(child: Row(children: [
                  //             Container(height: 20, width: 20, color: Colors.blue),
                  //             SizedBox(width: 10),
                  //             Text("PO issued")
                  //           ])),
                  //         ],
                  //       ),
                  //       SizedBox(height: 20),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Expanded(child: Row(children: [
                  //             Container(height: 20, width: 20, color: Colors.green),
                  //             SizedBox(width: 10),
                  //             Text("PO GeM")
                  //           ])),
                  //           Expanded(child: Row(children: [
                  //             Container(height: 20, width: 20, color: Colors.orange),
                  //             SizedBox(width: 10),
                  //             Text("Tender discharge")
                  //           ])),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // controller.dsbData.isNotEmpty ? Container(
                  //   height: Get.height * 0.6,
                  //   width: Get.width,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(0.0),
                  //     child: buildChart(controller.dsbData),
                  //   )
                  // ) : SizedBox(child: Image.asset('assets/no_data.png')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo
                      ),
                      alignment: Alignment.center,
                      child: Text("Departments Chart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                  Container(
                    height: 120,
                    width: Get.width,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Row(children: [
                              Container(height: 20, width: 20, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Management")
                            ])),
                            Expanded(child: Row(children: [
                              Container(height: 20, width: 20, color: Colors.green),
                              SizedBox(width: 10),
                              Text("CITG")
                            ])),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Row(children: [
                              Container(height: 20, width: 20, color: Colors.blue),
                              SizedBox(width: 10),
                              Text("Technical Vetting")
                            ])),
                            Expanded(child: Row(children: [
                              Container(height: 20, width: 20, color: Colors.indigo),
                              SizedBox(width: 10),
                              Text("Purchase")
                            ])),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Row(children: [
                              Container(height: 20, width: 20, color: Colors.orange),
                              SizedBox(width: 10),
                              Text("IND")
                            ])),
                            Expanded(child: Row(children: [
                              Container(height: 20, width: 20, color: Colors.purpleAccent),
                              SizedBox(width: 10),
                              Text("Account")
                            ])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  controller.dmdsData.isNotEmpty ? Container(
                    height: Get.height * 0.5,
                    width: Get.width,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      series: <CartesianSeries>[
                        ColumnSeries<ChartData2, String>(
                          dataSource: parseServerResponse(controller.dmdsData),
                          onPointTap: (pointInteractionDetails) => debugPrint("${pointInteractionDetails.pointIndex} ${pointInteractionDetails.dataPoints} ${pointInteractionDetails.viewportPointIndex}"),
                          // dataSource: [
                          //   ChartData2('MGT', 90, Colors.red),
                          //   ChartData2('Accts', 60, Colors.green),
                          //   ChartData2('TV', 75, Colors.blue),
                          //   ChartData2('Purc', 80, Colors.indigo),
                          // ],
                          xValueMapper: (ChartData2 data, _) => data.x,
                          yValueMapper: (ChartData2 data, _) => data.y,
                          pointColorMapper: (ChartData2 data, _) => data.color,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(color: Colors.white, fontSize: 12),
                            labelAlignment: ChartDataLabelAlignment.top,
                          ),
                        ),
                      ],
                    ),
                  ) : SizedBox (child: Image.asset('assets/no_data.png')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 60,
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.indigo
                      ),
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text("Tender Published & Under Evaluation(IREPS & GeM)", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                  controller.stackchartData.isNotEmpty ? Container(
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <CartesianSeries>[
                            StackedColumnSeries<ChartData3, String>(
                                dataLabelSettings: DataLabelSettings(
                                    isVisible:true,
                                    showCumulativeValues: true
                                ),
                                dataSource: parseChartData(controller.stackchartData),
                                xValueMapper: (ChartData3 data, _) => data.x,
                                yValueMapper: (ChartData3 data, _) => data.y1,
                              pointColorMapper: (ChartData3 data, _) => Colors.pinkAccent,
                            ),
                            StackedColumnSeries<ChartData3, String>(
                                dataLabelSettings: DataLabelSettings(
                                    isVisible:true,
                                    showCumulativeValues: true
                                ),
                                dataSource: parseChartData(controller.stackchartData),
                                xValueMapper: (ChartData3 data, _) => data.x,
                                yValueMapper: (ChartData3 data, _) => data.y2,
                                pointColorMapper: (ChartData3 data, _) => Colors.yellow,
                            ),
                            StackedColumnSeries<ChartData3, String>(
                                dataLabelSettings: DataLabelSettings(
                                    isVisible:true,
                                    showCumulativeValues: true
                                ),
                                dataSource: parseChartData(controller.stackchartData),
                                xValueMapper: (ChartData3 data, _) => data.x,
                                yValueMapper: (ChartData3 data, _) => data.y3,
                                pointColorMapper: (ChartData3 data, _) => Colors.blue,
                            ),
                            StackedColumnSeries<ChartData3, String>(
                                dataLabelSettings: DataLabelSettings(
                                    isVisible:true,
                                    showCumulativeValues: true
                                ),
                                dataSource: parseChartData(controller.stackchartData),
                                xValueMapper: (ChartData3 data, _) => data.x,
                                yValueMapper: (ChartData3 data, _) => data.y4,
                                pointColorMapper: (ChartData3 data, _) => Colors.green,
                            )
                          ]
                      )
                  ) : SizedBox (child: Image.asset('assets/no_data.png')),
                ],
              ),
            );
          }
          return SizedBox();
        }),
      ),
    );
  }
}

Widget buildChart(List<dynamic> jsonData) {
  final List<ChartData> dichartData = jsonData.map((data) {
    return ChartData(data['fyear'], double.parse(data['di'] ?? "0"));
  }).toList();


  final List<ChartData> drchartData = jsonData.map((data) {
    return ChartData(data['fyear'], double.parse(data['dr'] ?? '0'));
  }).toList();


  final List<ChartData> poichartData = jsonData.map((data) {
    return ChartData(data['fyear'], double.parse(data['poi'] ?? '0'));
  }).toList();

  final List<ChartData> pogchartData = jsonData.map((data) {
    return ChartData(data['fyear'], double.parse(data['pog'] ?? '0'));
  }).toList();


  final List<ChartData> tpchartData = jsonData.map((data) {
    return ChartData(data['fyear'], double.parse(data['tp'] ?? '0'));
  }).toList();

  final List<ChartData> tdchartData = jsonData.map((data) {
    return ChartData(data['fyear'], double.parse(data['td'] ?? '0'));
  }).toList();

  return SfCartesianChart(
    borderColor: Colors.grey,
    borderWidth: 1.5,
    enableAxisAnimation: true,
    tooltipBehavior: TooltipBehavior(
      enable: true,
      builder: (data, point, series, pointIndex, seriesIndex) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${point.y}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    ),
    primaryXAxis: CategoryAxis(
      opposedPosition: true,
      rangePadding: ChartRangePadding.auto,
      plotOffset: 0,
      axisBorderType: AxisBorderType.rectangle,
      autoScrollingMode: AutoScrollingMode.start,
      tickPosition: TickPosition.outside,
    ),
    zoomPanBehavior: ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      zoomMode: ZoomMode.xy,
    ),
    series: <CartesianSeries>[
      _buildBarSeries(dichartData, Colors.red),
      _buildBarSeries(drchartData, Colors.indigo),
      _buildBarSeries(poichartData, Colors.blue),
      _buildBarSeries(pogchartData, Colors.green),
      _buildBarSeries(tpchartData, Colors.black),
      _buildBarSeries(tdchartData, Colors.orange),
    ],
  );
}

BarSeries<ChartData, String> _buildBarSeries(List<ChartData> data, Color color) {
  //debugPrint("Bar Data ${data.  }  ${data.value}");
  return BarSeries<ChartData, String>(
    enableTooltip: true,
    //initialIsVisible: true,
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(5.0),
      topRight: Radius.circular(5.0),
    ),
    dataSource: data,
    xValueMapper: (ChartData data, _) => data.category,
    yValueMapper: (ChartData data, _) => data.value,
    width: 0.9,
    color: color,
  );
}

Widget navDrawer(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey, DashBoardController dashBoardController, ThemeController themeController){
  return Drawer(
    child: Column(
      children: [
        Expanded(
          child: Container(
            child: ListView(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints.expand(height: 180.0),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/welcome.jpg'),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'welcome'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      SizedBox(height: 4.0),
                      Obx(() => Text(dashBoardController.username!.value.capitalizeFirstLetter(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0))),
                      SizedBox(height: 2.0),
                      Obx(() => Text(dashBoardController.email!.value, style: TextStyle(color: Colors.white, fontSize: 15.0)))
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.black,
                  height: 2.0,
                ),
                // drawerTile(Iconic.lock, 'changepin'.tr, () {
                //   //Navigator.pop(context);
                //   _scaffoldKey.currentState!.closeDrawer();
                //   Get.toNamed(Routes.changepinScreen);
                // }),
                // drawerTile(Iconic.star, 'rateus'.tr, () {
                //   //Navigator.pop(context);
                //   _scaffoldKey.currentState!.closeDrawer();
                //   AapoortiUtilities.openStore(context);
                // }),

              ],
            ),
          ),
        ),
        Column(
          children: [
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 5.0),
            //     child: Container(
            //       height: 80.0,
            //       width: 80.0,
            //       decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey), borderRadius: BorderRadius.circular(40)),
            //       child: Image.asset('assets/images/crisnew.png', fit: BoxFit.cover, width: 80, height: 80),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 2.0),
            InkWell(
              onTap: () {
                if(_scaffoldKey.currentState!.isDrawerOpen) {
                  _scaffoldKey.currentState!.closeDrawer();
                  AapoortiUtilities.alertDialog(context, "MMIS");
                  //_showConfirmationDialog(context);
                  //WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
                  //callWebServiceLogout();
                }
              },
              child: Container(
                height: 45,
                color: Colors.indigo.shade500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Logout", style: TextStyle(fontSize: 16, color: Colors.white))
                  ],
                ),
              ),
            )
          ],
        ),
        //SizedBox(height: 15),
      ],
    ),
  );
}

ListTile drawerTile(IconData icon, String title, VoidCallback ontap) {
  return ListTile(
    onTap: ontap,
    contentPadding: EdgeInsets.symmetric(horizontal: 10),
    horizontalTitleGap: 10,
    leading: Icon(
      icon,
      color: Colors.black,
    ),
    title: Text(
      title,
      style: const TextStyle(color: Colors.black),
    ),
  );
}

List<ChartData2> parseServerResponse(List<dynamic> response) {
  List<ChartData2> chartDataList = [];

  for(var item in response) {
    String department = item['cur_dept'];
    //int count = int.parse(item['cnt']) == 0 ? 5 : 10;
    int count = int.parse(item['cnt'] ?? "0");
    Color color = department == 'MGMT' ? Colors.red : department == 'CITG' ? Colors.green : department == 'TV' ? Colors.blue : department == 'PURC' ? Colors.indigo : department == 'IND' ? Colors.orange : Colors.purpleAccent;

    // Create ChartData2 object and add to the list
    ChartData2 chartData = ChartData2(department, count.toDouble(), color);
    chartDataList.add(chartData);
  }

  return chartDataList;
}

List<ChartData3> parseChartData(List<dynamic> apiResponse) {
  return apiResponse.map((data) {
    // Map API data to the ChartData3 model
    Color color = _getColorForGroup(data['group_name']);

    return ChartData3(
      data['group_name'],
      double.parse(data['published_ireps'] ?? "0"),
      double.parse(data['published_gem'] ?? "0"),
      double.parse(data['under_evaluation_ireps'] ?? "0"),
      double.parse(data['under_evaluation_gem'] ?? "0"),
      color,
    );
  }).toList();
}

Color _getColorForGroup(String groupName) {
  switch (groupName) {
    case 'ADMN':
      return Colors.red;
    case 'CEP':
      return Colors.yellow;
    case 'CMM':
      return Colors.green;
    case 'CMS':
      return Colors.blue;
    case 'CN':
      return Colors.orange;
    case 'CP&WA':
      return Colors.pink;
    case 'CTCH':
      return Colors.pink;
    case 'EA':
      return Colors.pink;
    default:
      return Colors.grey;
  }
}


