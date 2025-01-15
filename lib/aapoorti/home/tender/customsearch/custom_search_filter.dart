import 'package:flutter/material.dart';

import 'custom_search_view.dart';

class Custom_search_filter extends StatefulWidget {
  @override
  _CustomSearchFilterState createState() => _CustomSearchFilterState();
}

class _CustomSearchFilterState extends State<Custom_search_filter>
    implements Exception {
  _CustomSearchFilterState() {}
  int _radioValuets = 0;
  int _radioValuett = 0;
  int _radioValuebs = 0;
  static List<int> filterChosen = [0,0,0];

  int _buttonFilter = 0;
  void initState() {
    super.initState();
    _radioValuets = filterChosen[0];
    _radioValuebs = filterChosen[1];
    _radioValuett = filterChosen[2];
   if(filterChosen[0] != 0)
    _filter = 1;
    else if (filterChosen[1] != 0)
    _filter =3;
    else if (filterChosen[2] != 0)
    _filter =2;

   
  }

  String _resultts = "All";
  String _resulttt = "All";
  String _resultbs = "All";
  int _filter = 1;

  void _clearall() {
    _radioValuets = 0;
    _radioValuett = 0;
    _radioValuebs = 0;
    _buttonFilter = 0;
    _handleRadioValueChangett(0);
    _handleRadioValueChangets(0);
    _handleRadioValueChangebs(0);
  }

  void _applyFilter() {
    Navigator.of(context).pop();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Custom_search_view(
              workarea: '#',
              SearchForstring: _resultts,
              RailZoneIn: _resulttt,
              Dt1In: _resultbs,
              Dt2In: '',
              searchOption: '',
              OrgCode: '',
              ClDate: '',
              dept: '',
              unit: ''),
        ));
  }

  void _csfilter(int value) {
    setState(() {
      _buttonFilter = value;
      switch (_buttonFilter) {
        case 1:
          _filter = 1;
          break;
        case 2:
          _filter = 2;
          break;
        case 3:
          _filter = 3;
          break;
      }
      print(_filter);
    });
  }

  void _handleRadioValueChangets(int? value) {
    setState(() {
      _resulttt = "All";
      _resultbs = "All";

      _radioValuets = value!;
      filterChosen[0]=value;
      filterChosen[1]=0;
      filterChosen[2]=0;
      
      switch (_radioValuets) {
        case 1:
          _resultts = "All";
          break;
        case 2:
          _resultts = "Published";
          break;
        case 3:
          _resultts = "Tender Box Open";
          break;
        case 4:
          _resultts = "Under Evaluation";
          break;
        case 5:
          _resultts = "PO Placed";
          break;
        case 6:
          _resultts = "Cancelled";
          break;
        case 7:
          _resultts = "Dropped";
          break;
        case 8:
          _resultts = "Tender Box Opened-Tabulation Pending";
          break;
        case 9:
          _resultts = "Retendered";
          break;
        case 10:
          _resultts = "TABULATION PENDING";
          break;
      }
    });
    print(_resultts);
  }

  void _handleRadioValueChangebs(int? value) {
    setState(() {
      _resulttt = "All";
      _resultts = "All";

      _radioValuebs = value!;
      filterChosen[0]=0;
      filterChosen[1]=value;
      filterChosen[2]=0;
      switch (_radioValuebs) {
        case 1:
          _resultbs = "All";
          break;
        case 2:
          _resultbs = "Single Packet";
          break;
        case 3:
          _resultbs = "Two Packet";
          break;
      }
    });
    print(_resultbs);
  }

  void _handleRadioValueChangett(int? value) {
    setState(() {
      _resultts = "All";
      _resultbs = "All";

      _radioValuett = value!;
      filterChosen[0]=0;
      filterChosen[1]=0;
      filterChosen[2]=value;
      switch (_radioValuett) {
        case 1:
          _resulttt = "All";
          break;
        case 2:
          _resulttt = "Limited";
          break;
        case 3:
          _resulttt = "Open";
          break;
        case 4:
          _resulttt = "Special Limited";
          break;
        case 5:
          _resulttt = "Single";
          break;
      }
    });
    print(_resulttt);
    /*Navigator.push(
        context, MaterialPageRoute(builder: (context) => Custom_search_view()));*/
  }

  double _containerHeight = 35,
      _imageHeight = 20,
      _iconTop = 11,
      _iconLeft = 5,
      _marginLeft = 110,
      _top = 70;
  @override
  Widget build(BuildContext context) {
    return Scaffold(   resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: true,
      body: Material(
        type: MaterialType.transparency,
        child: new Stack(
          /*backgroundColor: Color(0x66bbbbbb),
      body: Stack(*/
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              height: _containerHeight,
              top: _top,
              // _filter == 1 ? _top : 300,
              child: Container(color: Colors.deepPurple),
            ),
            Positioned(
              left: _iconLeft,
              top: _iconTop + _top -20,
              // (_filter == 1 ? _top : 300) - 20,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                color: Colors.white,
                icon: new Icon(
                  Icons.cancel,
                ),
              ),
            ),
            Positioned(
              right: _iconLeft,
              top: _iconTop + _top -20,
              // (_filter == 1 ? _top : 300) - 20,
              child: new IconButton(
                onPressed: () {
                  _clearall();
                },
                icon: new Icon(
                  Icons.clear_all,
                ),
                color: Colors.white,
              ),
            ),
            Positioned(
              left: _marginLeft,
              top: _iconTop + _top -4,
              //  (_filter == 1 ? _top : 300) - 4,
              child: Text("Custom Search Filter",
                  style: TextStyle(
                      color: Colors.white,
                      /* fontWeight: FontWeight.w500,*/
                      fontSize: 15)),
            ),
            Positioned(
              top: _containerHeight +
                  (_imageHeight / 4) +
                  _top,
                  // (_filter == 1 ? _top : 300),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Container(
                    color: Colors.blue[50],
                    child: new Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () => _csfilter(1),
                          textColor: Colors.white,
                          color: (_filter == 1) ? Colors.cyan : Colors.grey,
                          child: Text(
                            " Tender Status ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () => _csfilter(2),
                          textColor: Colors.white,
                          color: (_filter == 2) ? Colors.cyan : Colors.grey,
                          child: Text(
                            "   Tender Type   ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () => _csfilter(3),
                          textColor: Colors.white,
                          color: (_filter == 3) ? Colors.cyan : Colors.grey,
                          child: Text(
                            "Bidding System",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                        Container(
                          height: 380,
                          //  _filter == 1 ? 380.0 : 180.0,
                        )
                      ],
                    ),
                  ),
                  _filter == 1
                      ? new Container(
                    margin: EdgeInsets.all(0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Container(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  new Radio(
                                    value: 1,
                                    groupValue: _radioValuets,
                                    onChanged: _handleRadioValueChangets,
                                  ),
                                  new Text('All                         ')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  new Radio(
                                    value: 2,
                                    groupValue: _radioValuets,
                                    onChanged: _handleRadioValueChangets,
                                  ),
                                  new Text('Published               ')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  new Radio(
                                    value: 3,
                                    groupValue: _radioValuets,
                                    onChanged: _handleRadioValueChangets,
                                  ),
                                  new Text('TenderBox Open   ')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  new Radio(
                                    value: 4,
                                    groupValue: _radioValuets,
                                    onChanged: _handleRadioValueChangets,
                                  ),
                                  new Text('Under Evaluation   ')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  new Radio(
                                    value: 5,
                                    groupValue: _radioValuets,
                                    onChanged: _handleRadioValueChangets,
                                  ),
                                  new Text('PO Placed               '),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  new Radio(
                                    value: 6,
                                    groupValue: _radioValuets,
                                    onChanged: _handleRadioValueChangets,
                                  ),
                                  new Text('Cancelled                 ')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  new Radio(
                                    value: 7,
                                    groupValue: _radioValuets,
                                    onChanged: _handleRadioValueChangets,
                                  ),
                                  new Text('Dropped                   ')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  new Radio(
                                    value: 8,
                                    groupValue: _radioValuets,
                                    onChanged: _handleRadioValueChangets,
                                  ),
                                  new Text(
                                      'Tender Box Opened-\nTabulation Pending')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  new Radio(
                                    value: 9,
                                    groupValue: _radioValuets,
                                    onChanged: _handleRadioValueChangets,

                                  ),
                                  new Text('Retendered               ')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  new Radio(
                                    value: 10,
                                    groupValue: _radioValuets,
                                    onChanged: _handleRadioValueChangets,
                                  ),
                                  new Text('Tabulation Pending   ')
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                _applyFilter();
                              },
                              textColor: Colors.white,
                              color: Colors.cyan,
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius:
                                new BorderRadius.circular(30.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                      : (_filter == 2
                      ? new Container(
                    child: new Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Radio(
                              value: 1,
                              groupValue: _radioValuett,
                              onChanged: _handleRadioValueChangett,
                            ),
                            new Text('All                        ')
                          ],
                        ),
                        Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Radio(
                              value: 2,
                              groupValue: _radioValuett,
                              onChanged: _handleRadioValueChangett,
                            ),
                            new Text('Limited                ')
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Radio(
                              value: 3,
                              groupValue: _radioValuett,
                              onChanged: _handleRadioValueChangett,
                            ),
                            new Text('Open                    ')
                          ],
                        ),
                        Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Radio(
                              value: 4,
                              groupValue: _radioValuett,
                              onChanged: _handleRadioValueChangett,
                            ),
                            new Text('Special Limited   ')
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Radio(
                              value: 5,
                              groupValue: _radioValuett,
                              onChanged: _handleRadioValueChangett,
                            ),
                            new Text('Single                    ')
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                _applyFilter();
                              },
                              textColor: Colors.white,
                              color: Colors.cyan,
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius:
                                new BorderRadius.circular(30.0),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 40.0,
                        )
                      ],
                    ),
                  )
                      : new Container(
                    child: new Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Radio(
                              value: 1,
                              groupValue: _radioValuebs,
                              onChanged: _handleRadioValueChangebs,
                            ),
                            new Text('All                        ')
                          ],
                        ),
                        Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Radio(
                              value: 2,
                              groupValue: _radioValuebs,
                              onChanged: _handleRadioValueChangebs,
                            ),
                            new Text('Single Packet      ')
                          ],
                        ),
                        Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Radio(
                              value: 3,
                              groupValue: _radioValuebs,
                              onChanged: _handleRadioValueChangebs,
                            ),
                            new Text('Two Packet         ')
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                _applyFilter();
                              },
                              textColor: Colors.white,
                              color: Colors.cyan,
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius:
                                new BorderRadius.circular(30.0),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 130.0,
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
