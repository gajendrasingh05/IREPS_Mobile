import 'package:flutter/material.dart';


class CustomSearchBar extends StatefulWidget implements PreferredSizeWidget{
  final VoidCallback? onCancelSearch;
final Function(String)? onSearchQueryChanged;

  const CustomSearchBar({ this.onCancelSearch, this.onSearchQueryChanged}) ;

  @override
    Size get preferredSize => Size.fromHeight(56.0);

@override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  String searchQuery = '';
  TextEditingController _searchFieldController = TextEditingController();
  FocusNode? gfgFocusNode;
  clearSearchQuery() {
  // clear the input field
  _searchFieldController.clear();
  // notify DefaultAppBar by calling onSearchQueryChanged with ''
  widget.onSearchQueryChanged!('');
}

@override
  void initState() {
     super.initState();
     gfgFocusNode = FocusNode();
     setState(() {
       gfgFocusNode!.requestFocus();
     });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top:true,
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
               /* IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: widget.onCancelSearch,
                ),*/
                Expanded(
                  child: TextField(
                    controller: _searchFieldController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    focusNode: gfgFocusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: InkWell(
                        child: Icon(Icons.close, color: Colors.white),
                        onTap:(){
                          clearSearchQuery();
                          widget.onCancelSearch!();
                        },
                      ),
                    ),
                    onChanged: widget.onSearchQueryChanged
                  ),
                ),
          ],
            
        ),
          ],
      ),
      )
      
    );
  }
  @override
  void dispose() {
    super.dispose();
    gfgFocusNode!.dispose();
  }
}