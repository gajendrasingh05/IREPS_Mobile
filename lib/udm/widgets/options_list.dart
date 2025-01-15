import 'package:flutter/material.dart';

class OptionsList extends StatefulWidget {
  const OptionsList({
    Key? key,
    required this.itemsList,
    required this.onChanged,
    required this.initialValue,
  }) : super(key: key);
  final List itemsList;
  final Function(String?) onChanged;
  final String initialValue;

  @override
  _OptionsListState createState() => _OptionsListState();
}

class _OptionsListState extends State<OptionsList> {
  int selectedIndex = 0;
  bool _isInit = true;
  @override
  void initState() {
    selectedIndex = widget.itemsList
        .indexWhere((element) => element['intcode'] == widget.initialValue);

    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        setState(() {});
        print('selected $selectedIndex');
        if (selectedIndex > 1)
          _controller.animateTo(
            43 * (selectedIndex - 1).toDouble(),
            duration: Duration(
                milliseconds:
                    selectedIndex * 50 > 500 ? 500 : selectedIndex * 50 + 10),
            curve: Curves.linear,
          );
      },
    );
    _isInit = false;
  }

  @override
  void didChangeDependencies() {
    selectedIndex = widget.itemsList
        .indexWhere((element) => element['intcode'] == widget.initialValue);
    super.didChangeDependencies();
  }

  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        controller: _controller,
        itemCount: widget.itemsList.length,
        itemBuilder: (ctx, index) {
          return InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 7,
              ),
              //height: 50,
              child: Row(
                children: [
                  Icon(
                    index == selectedIndex
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      widget.itemsList[index]['value'],
                      style: TextStyle(
                        fontWeight: index == selectedIndex
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onChanged(widget.itemsList[index]['intcode']);
            },
          );
        },
      ),
    );
  }
}
