import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Dashboard extends StatefulWidget {
  final Widget? child;
  Dashboard({Key? key, this.child}) : super(key: key);
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  late int rowCount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.cyan[400],
          //backgroundColor: Color(0xff308e1c),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Container(
              color: Colors.cyan[400],
              child: TabBar(
                indicatorColor: Colors.blue.shade900,
                tabs: [
                  Tab(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        //border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    height: 45.0,
                    width: 250.0,
                    // color: Colors.grey[300],
                    child: Text(
                      '\nSupply',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  )),
                  Tab(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.cyan[700],
                        //border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    height: 45.0,
                    width: 250.0,
                    child: new Text(
                      '\nWorks',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  )),
                  Tab(
                      child: // new Padding(padding: new EdgeInsets.only(top: 5)),
                          Container(
                    decoration: new BoxDecoration(
                        color: Colors.blue,
                        //border: Border.all(color: Colors.white),
                        borderRadius: new BorderRadius.all(Radius.circular(6))),
                    height: 45.0,
                    width: 250.0,
                    // color: Colors.grey[300],
                    child: Text(
                      '\nEarning/Leasing',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  )

//
                      ),
                  Tab(
                      child: Container(
                    decoration: new BoxDecoration(
                        color: Colors.deepPurple,
                        //border: Border.all(color: Colors.white),
                        borderRadius: new BorderRadius.all(Radius.circular(6))),
                    height: 45.0,
                    width: 250.0,

                    //color: Colors.grey[300],
                    child: new Text(
                      '\nSales',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  )

                      //icon: Icon(FontAwesomeIcons.solidChartBar),
                      ),
                ],
              ),
            ),
          ),
        ),
        body: Center(
            child: AapoortiConstants.jsonResult1 == null
                ?
                //_myListView(context)
            SpinKitFadingCircle(
                    color: Colors.cyan,
                    size: 130.0,
                  )
                : _myListView(context)),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    print(AapoortiConstants.jsonResult1);
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return Container();
//     return TabBarView(
//       children: [
//         ListView.separated(
//             itemCount: 3,
//             itemBuilder: (context, index) {
//               for (int z = 0; z < 3; z++) {
//                 print("first");
//                 String xString = AapoortiConstants.jsonResult1[index]['XAXIS'];
//                 xString.trim();
//                 var xArray = xString.split("#");
//                 print(xArray.length);
//                 String yString = AapoortiConstants.jsonResult1[index]['YAXIS'];
//                 var nyString = yString.replaceAll("f", "");
//                 var yArray = nyString.split("#");
//                 if (yArray[yArray.length - 1] == null) {
//                   yArray.removeAt(yArray.length - 1);
//                 }
//                 var bargraph,
//                     pointedhgraph,
//                     linegraph,
//                     data1,
//                     data,
//                     chartwidget;
//                 data = [
//                   for (int i = 1; i < xArray.length; i++)
//                     Pollution(xArray[i], double.tryParse(yArray[yArray.length - i])!.round())
//                 ];
//                 data1 = [
//                   for (int i = 1; i < xArray.length; i++)
//                     Pollution(xArray[i], double.tryParse(yArray[i - 1])!.round())
//                 ];
//                 var vx = xArray[xArray.length - 1];
//                 var vy1 = yArray[0];
//                 var vy2 = yArray[yArray.length - 1];
//
//                 List<charts.Series<Pollution, String>> series = [
//                   charts.Series(
//                     id: "Pollution",
//                     data: data,
//                     domainFn: (Pollution pollution, _) => pollution.year,
//                     measureFn: (Pollution pollution, _) => pollution.quantity,
//                     labelAccessorFn: (Pollution pollution1, _) =>
//                         '${pollution1.quantity.toString()}',
//                     colorFn: (_, __) =>
//                         charts.MaterialPalette.green.shadeDefault,
//                   )
//                 ];
//                 bargraph = charts.BarChart(
//                   series,
//                   animate: true,
//                   barRendererDecorator: charts.BarLabelDecorator<String>(),
//                   behaviors: [
//                     charts.SlidingViewport(),
//                     charts.PanAndZoomBehavior(),
//                   ],
//                   domainAxis: charts.OrdinalAxisSpec(),
//                   primaryMeasureAxis: charts.NumericAxisSpec(
//                       renderSpec: charts.GridlineRendererSpec(
//                     labelAnchor: charts.TickLabelAnchor.before,
//                     labelJustification: charts.TickLabelJustification.inside,
//                   )),
//                 );
//                 chartwidget = Container(
//                     height: 260,
//                     width: MediaQuery.of(context).size.width,
//                     child: bargraph);
//
//                 List<charts.Series<Pollution, String>> series1 = [
//                   charts.Series(
//                     id: "Pollution",
//                     data: data1,
//                     domainFn: (Pollution pollution1, _) => pollution1.year,
//                     measureFn: (Pollution pollution1, _) => pollution1.quantity,
//                     labelAccessorFn: (Pollution pollution1, _) =>
//                         '${pollution1.quantity.toString()}',
//                     colorFn: (_, __) =>
//                         charts.MaterialPalette.cyan.shadeDefault,
//                   )
//                 ];
//
//                 pointedhgraph = charts.BarChart(
//                   series1,
//                   animate: true,
//                   barRendererDecorator: charts.BarLabelDecorator<String>(),
//                   domainAxis: charts.OrdinalAxisSpec(),
//                   primaryMeasureAxis: charts.NumericAxisSpec(
//                       renderSpec: charts.GridlineRendererSpec(
//                     labelAnchor: charts.TickLabelAnchor.before,
//                     labelJustification: charts.TickLabelJustification.inside,
//                   )),
//                 );
//                 var chartwidget1 = Container(
//                     height: 260,
//                     width: MediaQuery.of(context).size.width,
//                     child: pointedhgraph);
//
//                 List<charts.Series<Pollution, String>> series2 = [
//                   charts.Series(
//                     id: "Pollution",
//                     data: data1,
//                     domainFn: (Pollution pollution1, _) => pollution1.year,
//                     measureFn: (Pollution pollution1, _) => pollution1.quantity,
//                     labelAccessorFn: (Pollution pollution1, _) =>
//                         '${pollution1.quantity.toString()}',
//                     colorFn: (_, __) =>
//                         charts.MaterialPalette.blue.shadeDefault,
//                   )
//                 ];
//
//                 linegraph = charts.BarChart(
//                   series2,
//                   animate: true,
//                   barRendererDecorator: charts.BarLabelDecorator<String>(),
//                   domainAxis: charts.OrdinalAxisSpec(),
//                   primaryMeasureAxis: charts.NumericAxisSpec(
//                       renderSpec: charts.GridlineRendererSpec(
//                     labelAnchor: charts.TickLabelAnchor.before,
//                     labelJustification: charts.TickLabelJustification.inside,
//                   )),
//                 );
//                 var chartwidget2 = Container(
//                     height: 260,
//                     width: MediaQuery.of(context).size.width,
//                     child: linegraph);
//
//                 return Column(
//                   children: <Widget>[
//                     Padding(padding: EdgeInsets.all(20)),
//                     if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                         "No. of Tenders Issued")
//                       Container(
//                           height: MediaQuery.of(context).size.height * 0.44,
//                           child: Column(
//                             children: <Widget>[
//                               Text(
//                                 'No. of Tenders Issued' +
//                                     " ( FY " +
//                                     vx +
//                                     " - " +
//                                     vy1 +
//                                     ")",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                     fontSize: 15),
//                               ),
//                               chartwidget,
//                             ],
//                           )),
//                     if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                         "Value of Tenders Issued")
//                       Container(
//                           height: MediaQuery.of(context).size.height * 0.44,
//                           child: Column(
//                             children: <Widget>[
//                               Text(
//                                 'Value of Tenders Issued' +
//                                     " ( FY " +
//                                     vx +
//                                     " - " +
//                                     vy2 +
//                                     ")",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                     fontSize: 15),
//                               ),
//                               chartwidget1,
//                             ],
//                           )),
//                     if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                         "Vendor count (Cumulative)")
//                       Container(
//                           height: MediaQuery.of(context).size.height * 0.44,
//                           child: Column(
//                             children: <Widget>[
//                               Text(
//                                 'Vendor Count ' + " (Cumulative- " + vy2 + ")",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                     fontSize: 15),
//                               ),
//                               chartwidget2,
//                             ],
//                           )),
//                     Padding(padding: EdgeInsets.all(5)),
//                     Text(
//                       AapoortiConstants.jsonResult1[index]['LEGEND'],
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                     ),
//                     Padding(padding: EdgeInsets.all(5)),
//                     if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                         "Vendor count (Cumulative)")
//                       Text(
//                         '                         Last Updated :' +
//                             AapoortiConstants.jsonResult1[index]
//                                 ['LASTUPDATEDON'],
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 15,
//                         ),
//                         textAlign: TextAlign.right,
//                       ),
//                     Padding(padding: EdgeInsets.all(5)),
//                   ],
//                 );
//               }
//             },
//             separatorBuilder: (context, index) {
//               return Divider(
//                 color: Colors.white,
//                 height: 10,
//               );
//             }),
//         ListView.separated(
//             itemCount: 3,
//             itemBuilder: (context, index) {
//               for (int z = 3; z < AapoortiConstants.jsonResult1.length - 6; z++) {
//                 String xString = AapoortiConstants.jsonResult1[index + 3]['XAXIS'];
//                 xString.trim();
//                 var xArray = xString.split("#");
//                 String yString =
//                     AapoortiConstants.jsonResult1[index + 3]['YAXIS'];
//                 var nyString = yString.replaceAll("f", "");
//                 var yArray = nyString.split("#");
//                 var bargraph,
//                     pointedhgraph,
//                     linegraph,
//                     data1,
//                     data,
//                     chartwidget;
//                 data = [
//                   for (int i = 1; i < xArray.length; i++)
//                     if (yArray != null)
//                       Pollution(xArray[i],
//                           double.tryParse(yArray[yArray.length - i])!.round())
//                 ];
//                 data1 = [
//                   for (int i = 1; i < xArray.length; i++)
//                     if (yArray != null)
//                       Pollution(
//                           xArray[i], double.tryParse(yArray[i - 1])!.round())
//                 ];
//                 var vx = xArray[xArray.length - 1];
//                 var vy1 = yArray[0];
//                 var vy2 = yArray[yArray.length - 1];
//
//                 List<charts.Series<Pollution, String>> series = [
//                   charts.Series(
//                     id: "Pollution",
//                     colorFn: (_, __) =>
//                         charts.MaterialPalette.cyan.shadeDefault,
//                     domainFn: (Pollution series, _) => series.year,
//                     measureFn: (Pollution series, _) => series.quantity,
//                     labelAccessorFn: (Pollution pollution1, _) =>
//                         '${pollution1.quantity.toString()}',
//                     data: data,
//                   )
//                 ];
//                 bargraph = charts.BarChart(
//                   series,
//                   animate: true,
//                   barRendererDecorator: charts.BarLabelDecorator<String>(),
//                   domainAxis: charts.OrdinalAxisSpec(),
//                   primaryMeasureAxis: charts.NumericAxisSpec(
//                       renderSpec: charts.GridlineRendererSpec(
//                     labelAnchor: charts.TickLabelAnchor.before,
//                     labelJustification: charts.TickLabelJustification.inside,
//                   )),
//                 );
//                 chartwidget = Container(
//                     height: 260,
//                     width: MediaQuery.of(context).size.width,
//                     child: bargraph);
//                 List<charts.Series<Pollution, String>> series1 = [
//                   charts.Series(
//                     id: "Pollution",
//                     data: data1,
//                     domainFn: (Pollution pollution1, _) => pollution1.year,
//                     measureFn: (Pollution pollution1, _) => pollution1.quantity,
//                     labelAccessorFn: (Pollution pollution1, _) =>
//                         '${pollution1.quantity.toString()}',
//                     colorFn: (_, __) =>
//                         charts.MaterialPalette.green.shadeDefault,
//                   )
//                 ];
//
//                 pointedhgraph = charts.BarChart(
//                   series1,
//                   animate: true,
//                   barRendererDecorator: charts.BarLabelDecorator<String>(),
//                   domainAxis: charts.OrdinalAxisSpec(),
//                   primaryMeasureAxis: charts.NumericAxisSpec(
//                       renderSpec: charts.GridlineRendererSpec(
//                     labelAnchor: charts.TickLabelAnchor.before,
//                     labelJustification: charts.TickLabelJustification.inside,
//                   )),
//                 );
//                 var chartwidget1 = Container(
//                     height: 260,
//                     width: MediaQuery.of(context).size.width,
//                     child: pointedhgraph);
//                 List<charts.Series<Pollution, String>> series2 = [
//                   charts.Series(
//                     id: "Pollution",
//                     data: data1,
//                     domainFn: (Pollution pollution1, _) => pollution1.year,
//                     measureFn: (Pollution pollution1, _) => pollution1.quantity,
//                     labelAccessorFn: (Pollution pollution1, _) =>
//                         '${pollution1.quantity.toString()}',
//                     colorFn: (_, __) =>
//                         charts.MaterialPalette.blue.shadeDefault,
//                   )
//                 ];
//
//                 linegraph = charts.BarChart(
//                   series2,
//                   animate: true,
//                   barRendererDecorator: charts.BarLabelDecorator<String>(),
//                   domainAxis: charts.OrdinalAxisSpec(),
//                   primaryMeasureAxis: charts.NumericAxisSpec(
//                       renderSpec: charts.GridlineRendererSpec(
//                     labelAnchor: charts.TickLabelAnchor.before,
//                     labelJustification: charts.TickLabelJustification.inside,
//                   )),
//                 );
//                 var chartwidget2 = Container(
//                     height: 260,
//                     width: MediaQuery.of(context).size.width,
//                     child: linegraph);
//                 return Column(
//                   children: <Widget>[
//                     Padding(padding: EdgeInsets.all(20)),
//                     if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                         "No. of Tenders Issued")
//                       Container(
//                           height: MediaQuery.of(context).size.height * 0.44,
//                           child: Column(
//                             children: <Widget>[
//                               Text(
//                                 'No. of Tenders Issued' +
//                                     " ( FY " +
//                                     vx +
//                                     " - " +
//                                     vy1 +
//                                     ")",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                     fontSize: 15),
//                               ),
//                               chartwidget,
//                             ],
//                           )),
//                     if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                         "Value of Tenders Issued")
//                       Container(
//                           height: MediaQuery.of(context).size.height * 0.44,
//                           child: Column(
//                             children: <Widget>[
//                               Text(
//                                 'Value of Tenders Issued' +
//                                     " ( FY " +
//                                     vx +
//                                     " - " +
//                                     vy2 +
//                                     ")",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                     fontSize: 15),
//                               ),
//                               chartwidget1,
//                             ],
//                           )
// //bargraph,
//                           ),
//                     if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                         "Vendor count (Cumulative)")
//                       Container(
//                           height: MediaQuery.of(context).size.height * 0.44,
//                           child: Column(
//                             children: <Widget>[
//                               Text(
//                                 'Contractors Registered' +
//                                     " (Cumulative- " +
//                                     vy2 +
//                                     ")",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                     fontSize: 15),
//                               ),
//                               chartwidget2,
//                             ],
//                           )
// //bargraph,
//                           ),
//                     Padding(padding: EdgeInsets.all(5)),
//                     Text(
//                       AapoortiConstants.jsonResult1[index]['LEGEND'],
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                     ),
//                     Padding(padding: EdgeInsets.all(5)),
//                     if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                         "Vendor count (Cumulative)")
//                       Text(
//                         '                         Last Updated : ' +
//                             AapoortiConstants.jsonResult1[index]
//                                 ['LASTUPDATEDON'],
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 15,
//                         ),
//                         textAlign: TextAlign.right,
//                       ),
//                     Padding(padding: EdgeInsets.all(5)),
//                   ],
//                 );
//               }
//             },
//             separatorBuilder: (context, index) {
//               return Divider(
//                 color: Colors.white,
//                 height: 10,
//               );
//             }),
//         ListView.separated(
//           itemCount: 3,
//           itemBuilder: (context, index) {
//             for (int z = 9; z < AapoortiConstants.jsonResult1.length; z++) {
//               String xString = AapoortiConstants.jsonResult1[z]['XAXIS'];
//               xString.trim();
//               var nxString = xString.replaceAll("-", "");
//               var nxArray = nxString.split("#");
//               var xArray = xString.split("#");
//               String yString =
//                   AapoortiConstants.jsonResult1[index + 9]['YAXIS'];
//               var nyString = yString.replaceAll("f", "");
//               var yArray = nyString.split("#");
//               print(yArray);
//               if (yArray[yArray.length - 1] == null) {
//                 yArray.removeAt(yArray.length - 1);
//               }
//               var bargraph, pointedhgraph, linegraph, chartwidget;
//               var data = [
//                 for (int i = 1; i < xArray.length; i++)
//                   if (yArray != null)
//                     Pollution(xArray[i],
//                         double.tryParse(yArray[yArray.length - i])!.round())
//               ];
//               var data1 = [
//                 for (int i = 1; i < nxArray.length; i++)
//                   if (yArray != null)
//                     Pollution(
//                         xArray[i], double.tryParse(yArray[i - 1])!.round())
//               ];
//               var vx = xArray[xArray.length - 1];
//               var vy1 = yArray[0];
//               var vy2 = yArray[yArray.length - 1];
//
//               List<charts.Series<Pollution, String>> series = [
//                 charts.Series(
//                   id: "Pollution",
//                   data: data,
//                   domainFn: (Pollution series, _) => series.year,
//                   measureFn: (Pollution series, _) => series.quantity,
//                   labelAccessorFn: (Pollution pollution1, _) =>
//                       '${pollution1.quantity.toString()}',
//                   colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//                 )
//               ];
//               bargraph = charts.BarChart(
//                 series,
//                 animate: true,
//                 barRendererDecorator: charts.BarLabelDecorator<String>(),
//                 domainAxis: charts.OrdinalAxisSpec(),
//                 primaryMeasureAxis: charts.NumericAxisSpec(
//                     renderSpec: charts.GridlineRendererSpec(
//                   labelAnchor: charts.TickLabelAnchor.before,
//                   labelJustification: charts.TickLabelJustification.inside,
//                 )),
//               );
//               chartwidget = Container(
//                   height: 260,
//                   width: MediaQuery.of(context).size.width,
//                   child: bargraph);
//               List<charts.Series<Pollution, String>> series1 = [
//                 charts.Series(
//                   id: "Pollution",
//                   data: data1,
//                   domainFn: (Pollution pollution1, _) => pollution1.year,
//                   measureFn: (Pollution pollution1, _) => pollution1.quantity,
//                   labelAccessorFn: (Pollution pollution1, _) =>
//                       '${pollution1.quantity.toString()}',
//                   colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
//                 )
//               ];
//
//               pointedhgraph = charts.BarChart(
//                 series1,
//                 animate: true,
//                 barRendererDecorator: charts.BarLabelDecorator<String>(),
//                 domainAxis: charts.OrdinalAxisSpec(),
//                 primaryMeasureAxis: charts.NumericAxisSpec(
//                     renderSpec: charts.GridlineRendererSpec(
//                   labelAnchor: charts.TickLabelAnchor.before,
//                   labelJustification: charts.TickLabelJustification.inside,
//                 )),
//               );
//               var chartwidget1 = Container(
//                   height: 260,
//                   width: MediaQuery.of(context).size.width,
//                   child: pointedhgraph);
//               List<charts.Series<Pollution, String>> series2 = [
//                 charts.Series(
//                   id: "Pollution",
//                   data: data1,
//                   domainFn: (Pollution pollution1, _) => pollution1.year,
//                   measureFn: (Pollution pollution1, _) => pollution1.quantity,
//                   labelAccessorFn: (Pollution pollution1, _) =>
//                       '${pollution1.quantity.toString()}',
//                   colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
//                 )
//               ];
//
//               linegraph = charts.BarChart(
//                 series2,
//                 animate: true,
//                 barRendererDecorator: charts.BarLabelDecorator<String>(),
//                 domainAxis: charts.OrdinalAxisSpec(),
//                 primaryMeasureAxis: charts.NumericAxisSpec(
//                     renderSpec: charts.GridlineRendererSpec(
//                   labelAnchor: charts.TickLabelAnchor.before,
//                   labelJustification: charts.TickLabelJustification.inside,
//                 )),
//               );
//               var chartwidget2 = Container(
//                   height: 260,
//                   width: MediaQuery.of(context).size.width,
//                   child: linegraph);
//               return Column(
//                 children: <Widget>[
//                   Padding(padding: EdgeInsets.all(20)),
//                   if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                       "No. of Tenders Issued")
//                     Container(
//                         height: MediaQuery.of(context).size.height * 0.44,
//                         child: Column(
//                           children: <Widget>[
//                             Text(
//                               'No. of Tenders Issued' +
//                                   " ( FY " +
//                                   vx +
//                                   " - " +
//                                   vy1 +
//                                   ")",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontSize: 15),
//                             ),
//                             chartwidget,
//                           ],
//                         )),
//                   if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                       "Value of Tenders Issued")
//                     Container(
//                         height: MediaQuery.of(context).size.height * 0.44,
//                         child: Column(
//                           children: <Widget>[
//                             Text(
//                               'Value of Tenders Issued' +
//                                   " ( FY " +
//                                   vx +
//                                   " - " +
//                                   vy2 +
//                                   ")",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontSize: 15),
//                             ),
//                             chartwidget1,
//                           ],
//                         )),
//                   if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                       "Vendor count (Cumulative)")
//                     Container(
//                         height: MediaQuery.of(context).size.height * 0.44,
//                         child: Column(
//                           children: <Widget>[
//                             Text(
//                               'Vendor Count' + " (Cumulative- " + vy2 + ")",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontSize: 15),
//                             ),
//                             chartwidget2,
//                           ],
//                         )
// //bargraph,
//                         ),
//                   Padding(padding: EdgeInsets.all(5)),
//                   Text(
//                     AapoortiConstants.jsonResult1[index]['LEGEND'],
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 12,
//                     ),
//                   ),
//                   Padding(padding: EdgeInsets.all(5)),
//                   if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                       "Vendor count (Cumulative)")
//                     Text(
//                       '                         Last Updated :' +
//                           AapoortiConstants.jsonResult1[index]['LASTUPDATEDON'],
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 15,
//                       ),
//                       textAlign: TextAlign.right,
//                     ),
//                   Padding(padding: EdgeInsets.all(5)),
//                 ],
//               );
//             }
//           },
//           separatorBuilder: (context, index) {
//             return Divider(
//               color: Colors.white,
//               height: 20,
//             );
//           },
//         ),
//         ListView.separated(
//             itemCount: 3,
//             itemBuilder: (context, index) {
//               for (int z = 6;
//                   z < AapoortiConstants.jsonResult1.length - 3;
//                   z++) {
//                 print(AapoortiConstants.jsonResult1[8]);
//                 print("4th");
//                 String xString = AapoortiConstants.jsonResult1[z]['XAXIS'];
//                 xString.trim();
//                 var nxString = xString.replaceAll("-", "");
//                 var nxArray = nxString.split("#");
//                 var xArray = xString.split("#");
//                 print(xArray);
//                 String yString =
//                     AapoortiConstants.jsonResult1[index + 6]['YAXIS'];
//                 var nyString = yString.replaceAll("f", "");
//                 var yArray = nyString.split("#");
//                 if (yArray[yArray.length - 1] == null) {
//                   yArray.removeAt(yArray.length - 1);
//                 }
//                 var bargraph, pointedhgraph, linegraph, chartwidget;
//                 var data = [
//                   for (int i = 1; i < xArray.length; i++)
//                     if (yArray != null)
//                       Pollution(xArray[i],
//                           double.tryParse(yArray[yArray.length - i])!.round())
//                 ];
//                 var data1 = [
//                   for (int i = 1; i < nxArray.length; i++)
//                     if (yArray != null)
//                       Pollution(
//                           xArray[i], double.tryParse(yArray[i - 1])!.round())
//                 ];
//                 var vx = xArray[xArray.length - 1];
//                 var vy1 = yArray[0];
//                 var vy2 = yArray[yArray.length - 1];
//
//                 List<charts.Series<Pollution, String>> series = [
//                   charts.Series(
//                     id: "Pollution",
//                     data: data,
//                     domainFn: (Pollution series, _) => series.year,
//                     measureFn: (Pollution series, _) => series.quantity,
//                     labelAccessorFn: (Pollution pollution1, _) =>
//                         '${pollution1.quantity.toString()}',
//                     colorFn: (_, __) =>
//                         charts.MaterialPalette.purple.shadeDefault,
//                   )
//                 ];
//                 bargraph = charts.BarChart(
//                   series,
//                   animate: true,
//                   barRendererDecorator: charts.BarLabelDecorator<String>(),
//                   domainAxis: charts.OrdinalAxisSpec(),
//                   primaryMeasureAxis: charts.NumericAxisSpec(
//                       renderSpec: charts.GridlineRendererSpec(
//                     labelAnchor: charts.TickLabelAnchor.before,
//                     labelJustification: charts.TickLabelJustification.inside,
//                   )),
//                 );
//                 chartwidget = Container(
//                     height: 260,
//                     width: MediaQuery.of(context).size.width,
//                     child: bargraph);
//                 List<charts.Series<Pollution, String>> series1 = [
//                   charts.Series(
//                     id: "Pollution",
//                     data: data1,
//                     domainFn: (Pollution pollution1, _) => pollution1.year,
//                     measureFn: (Pollution pollution1, _) => pollution1.quantity,
//                     labelAccessorFn: (Pollution pollution1, _) =>
//                         '${pollution1.quantity.toString()}',
//                     colorFn: (_, __) =>
//                         charts.MaterialPalette.cyan.shadeDefault,
//                   )
//                 ];
//
//                 pointedhgraph = charts.BarChart(
//                   series1,
//                   animate: true,
//                   barRendererDecorator: charts.BarLabelDecorator<String>(),
//                   domainAxis: charts.OrdinalAxisSpec(),
//                   primaryMeasureAxis: charts.NumericAxisSpec(
//                       renderSpec: charts.GridlineRendererSpec(
//                     labelAnchor: charts.TickLabelAnchor.before,
//                     labelJustification: charts.TickLabelJustification.inside,
//                   )),
//                 );
//                 var chartwidget1 = Container(
//                   height: 260,
//                   width: MediaQuery.of(context).size.width,
//                   child: pointedhgraph,
//                 );
//                 List<charts.Series<Pollution, String>> series2 = [
//                   charts.Series(
//                     id: "Pollution",
//                     data: data1,
//                     domainFn: (Pollution pollution1, _) => pollution1.year,
//                     measureFn: (Pollution pollution1, _) => pollution1.quantity,
//                     labelAccessorFn: (Pollution pollution1, _) =>
//                         '${pollution1.quantity.toString()}',
//                     colorFn: (_, __) =>
//                         charts.MaterialPalette.blue.shadeDefault,
//                   )
//                 ];
//                 linegraph = charts.BarChart(
//                   series2,
//                   animate: true,
//                   barRendererDecorator: new charts.BarLabelDecorator<String>(),
//                   domainAxis: new charts.OrdinalAxisSpec(),
//                   primaryMeasureAxis: new charts.NumericAxisSpec(
//                       renderSpec: new charts.GridlineRendererSpec(
//                     labelAnchor: charts.TickLabelAnchor.before,
//                     labelJustification: charts.TickLabelJustification.inside,
//                   )),
//                 );
//                 var chartwidget2 = new Container(
//                     height: 260,
//                     width: MediaQuery.of(context).size.width,
//                     child: linegraph);
//                 return Column(
//                   children: <Widget>[
//                     Column(
//                       children: <Widget>[
//                         Padding(padding: EdgeInsets.all(10)),
// /*Text(  //to show graph headings/////
// jsonResult[index]['HEADING'],
// style: TextStyle(
// color: Colors.black,
// fontSize: 16
// ),
// ),*/
//                         if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                             "No. of Tenders Issued")
//                           Container(
//                               height: MediaQuery.of(context).size.height * 0.44,
//                               child: Column(
//                                 children: <Widget>[
//                                   Text(
//                                     'Lots Sold' +
//                                         " ( FY " +
//                                         vx +
//                                         " - " +
//                                         vy1 +
//                                         ")",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                         fontSize: 15),
//                                   ),
//                                   chartwidget,
//                                 ],
//                               )
// //bargraph,
//                               ),
//                         if (AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                             "Value of Tenders Issued")
//                           Container(
//                               height: MediaQuery.of(context).size.height * 0.44,
//                               child: Column(
//                                 children: <Widget>[
//                                   Text(
//                                     'Sale Value' +
//                                         " ( FY " +
//                                         vx +
//                                         " - " +
//                                         vy2 +
//                                         ")",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                         fontSize: 15),
//                                   ),
//                                   chartwidget1,
//                                 ],
//                               )
// //bargraph,
//                               ),
//                         if (AapoortiConstants.jsonResult1[index]['HEADING']
//                                     .toString()
//                                     .trim() ==
//                                 "Buyers Registered (Cumulative)".trim() ||
//                             AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                                 AapoortiConstants.jsonResult1[11]['HEADING'])
//                           Container(
//                             height: MediaQuery.of(context).size.height * 0.44,
//                             child: Column(
//                               children: <Widget>[
//                                 Text(
//                                   'Buyer Registered' +
//                                       " (Cumulative- " +
//                                       vy2 +
//                                       ")",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                       fontSize: 15),
//                                 ),
//                                 chartwidget2,
//                               ],
//                             ),
//                           ),
//                         Padding(padding: EdgeInsets.all(5)),
//                         Text(
//                           AapoortiConstants.jsonResult1[index]['LEGEND'],
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(padding: EdgeInsets.all(5)),
//                     if (AapoortiConstants.jsonResult1[index]['HEADING']
//                                 .toString()
//                                 .trim() ==
//                             "Buyers Registered (Cumulative)".trim() ||
//                         AapoortiConstants.jsonResult1[index]['HEADING'] ==
//                             AapoortiConstants.jsonResult1[11]['HEADING'])
//                       Text(
//                         '                         Last Updated :' +
//                             AapoortiConstants.jsonResult1[index]
//                                 ['LASTUPDATEDON'],
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 15,
//                         ),
//                         textAlign: TextAlign.right,
//                       ),
//                     Padding(padding: EdgeInsets.all(5)),
//                   ],
//                 );
//               }
//             },
//             separatorBuilder: (context, index) {
//               return Divider(
//                 color: Colors.white,
//                 height: 10,
//               );
//             }),
//       ],
//     );
  }
}

class Pollution {
  var year;
  int quantity;

  Pollution(this.year, this.quantity);
}
