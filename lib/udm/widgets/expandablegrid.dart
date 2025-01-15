import 'package:flutter/material.dart';
import 'package:flutter_app/udm/localization/languageHelper.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/network_provider.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ExpandableGrid extends StatefulWidget {
  final String? heading;
  final List<Map<String, dynamic>>? children;
  final Function(String, int)? action;

  const ExpandableGrid({this.heading, this.children, this.action});

  @override
  _ExpandableGridState createState() => _ExpandableGridState();
}

class _ExpandableGridState extends State<ExpandableGrid> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<LanguageProvider>(context).language == Language.English;
    return LayoutBuilder(builder: (ctx, constraints) {
      int crossCount = 3;
      int num = (widget.children!.length / crossCount).ceil();
      double spacing = 0;
      var availableHeight = (constraints.maxHeight) - ((num) - 1) * spacing;
      return GridView.count(
        crossAxisCount: crossCount,
        crossAxisSpacing: 0,
        mainAxisSpacing: spacing,
        scrollDirection: Axis.vertical,
        children: [
          for(var i = 0; i < widget.children!.length; i++)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4.0,
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))
                  ),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.children![i]['icon'].toString().contains("svg") ? Expanded(child: SvgPicture.asset(
                        widget.children![i]['icon'],
                        fit: BoxFit.contain,
                        width: 80,
                      )) : Expanded(child: Image.asset(
                        widget.children![i]['icon'],
                        fit: BoxFit.contain,
                        width: 80,
                      )),
                      SizedBox(height: 10),
                      Text((widget.children![i]['label'] as String).split('\n')[isEnglish ? 1 : 0], maxLines: 3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,style: TextStyle(fontSize: 12))
                    ],
                  ),
                ),
                onTap: () {
                  // if(Provider.of<NetworkProvider>(context, listen: false).status == ConnectivityStatus.Offline) {
                  //   UdmUtilities.showWarningFlushBar(context, Provider.of<LanguageProvider>(context, listen: false).text('checkconnection'));
                  // }
                  // else{
                    widget.action!('1', i % widget.children!.length);
                  //}
                },
              ),
            ),
        ],
      );
    });
  }

  Widget showMoreButton() {
    return InkWell(
      onTap: () {
        setState(() {
          showMore = !showMore;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          showMore ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
        ],
      ),
    );
  }
}

class MyPolygon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.addPolygon([
      Offset(0, 0),
      Offset(0, size.height),
      Offset(size.width * 3 / 2, size.height),
      Offset(size.width, 0),
    ], true);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
    throw UnimplementedError();
  }
}
