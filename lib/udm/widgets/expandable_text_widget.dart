
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String? text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      Container(
          child: Text(
              widget.text!,style: TextStyle(color: Colors.deepOrangeAccent),
            maxLines: widget.isExpanded ? widget.text!.length: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,

          )),
      Row(
        children: [
        Expanded(child: Container()),
        GestureDetector(
              child:
              widget.isExpanded ?
              Text(''):
              Text('More',style:TextStyle(color: Colors.blue)),
              onTap: () {
                setState(() {
                  widget.isExpanded = !widget.isExpanded;
                  print('expanded');
                });
              }
        )

      ],
      ),
     
    ]);
  }
}


