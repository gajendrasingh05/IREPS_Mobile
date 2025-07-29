import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ReusableDropDownSearch<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? value;
  final Icon icon;
  final bool enabled;
  final void Function(T?) onChanged;
  final String snackbartext;

  // final String Function(T) itemToString;

  const ReusableDropDownSearch({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    // required this.itemToString,
    required this.icon,
    this.enabled = true,
    required this.snackbartext
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!enabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(snackbartext,textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white)),
              backgroundColor: Colors.redAccent[100],duration: Duration(milliseconds: 600 ),),
          );
        }
      },

      child: AbsorbPointer(
        absorbing: !enabled,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SizedBox(height: 44,
            child: FormField<T>(
              // validator: (val) => val != null ? null : ('Please select a ${label.toLowerCase()}'),
              builder: (FormFieldState<T> state) => DropdownSearch<T>(
                enabled: enabled,
                items: (filter, infiniteScrollProps) => items,
                selectedItem: value,
                onChanged: (val) {
                  state.didChange(val); // important for validation
                  onChanged(val);
                },

                // itemAsString: itemToString,
                decoratorProps: DropDownDecoratorProps(
                  baseStyle: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    prefixIcon: icon,
                    prefixIconColor: Colors.blueAccent.shade200,
                    labelText: label,
                    labelStyle: enabled != true ? TextStyle(color: Colors.grey.shade600, fontSize: 16) : TextStyle(color: Colors.black, fontSize: 16),
                    hintStyle: TextStyle(fontSize: 16),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: Colors.grey.shade400, width: 1),
                      borderRadius: BorderRadius.circular(4),),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: Colors.blueAccent.shade100, width: 2),
                      borderRadius: BorderRadius.circular(4),),
                  ),
                ),
                popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        hintText: 'Search...',
                      ),
                    ),
                    menuProps: MenuProps(
                      backgroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  emptyBuilder: (context, searchEntry) {
                    return const Center(child: Column(
                      children: [
                        Text('No data available'),
                      ],
                    ));
                  },
                    containerBuilder: (BuildContext context, Widget popupWidget) {
                      return Container(
                        constraints: BoxConstraints(
                          maxHeight: items.length < 3 ? (88 + items.length*44) : 288 ,
                        ),
                        child: popupWidget,
                      );
                    },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
