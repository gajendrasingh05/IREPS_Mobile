import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DateRangePicker extends StatefulWidget {
  final Function(DateTime start, DateTime end)? onDateRangeChanged;
  final ValueChanged<String>? onDateTypeChanged;

  const DateRangePicker({
    Key? key,
    this.onDateRangeChanged,
    this.onDateTypeChanged,
  }) : super(key: key);

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late DateTime fromDate;
  late DateTime toDate;
  String selectedDateType = "0"; // 0 for closing, 1 for uploading

  @override
  void initState() {
    super.initState();
    fromDate = DateTime.now();
    toDate = DateTime.now().add(Duration(days: 1));

    // Notify parent of initial values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateRangeChanged?.call(fromDate, toDate);
      widget.onDateTypeChanged?.call(selectedDateType);
    });
  }

  void _updateDateRange() {
    widget.onDateRangeChanged?.call(fromDate, toDate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Type Selection
          // Row(
          //   children: [
          //     Expanded(
          //       child: RadioListTile<String>(
          //         title: Text('Closing Date', style: TextStyle(fontSize: 14)),
          //         value: "0",
          //         groupValue: selectedDateType,
          //         onChanged: (value) {
          //           setState(() {
          //             selectedDateType = value!;
          //           });
          //           widget.onDateTypeChanged?.call(value!);
          //         },
          //         dense: true,
          //         contentPadding: EdgeInsets.zero,
          //       ),
          //     ),
          //     Expanded(
          //       child: RadioListTile<String>(
          //         title: Text('Uploading Date', style: TextStyle(fontSize: 14)),
          //         value: "1",
          //         groupValue: selectedDateType,
          //         onChanged: (value) {
          //           setState(() {
          //             selectedDateType = value!;
          //           });
          //           widget.onDateTypeChanged?.call(value!);
          //         },
          //         dense: true,
          //         contentPadding: EdgeInsets.zero,
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 16),

          // Date Range Selection
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: fromDate,
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2050),
                        builder: (context, child) => Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(),
                              dialogBackgroundColor: Colors.white,
                            ),
                            child: child!
                        )
                    );
                    if (picked != null && picked != fromDate) {
                      setState(() => fromDate = picked);
                      _updateDateRange();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'From',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${fromDate.day.toString().padLeft(2, '0')}/${fromDate.month.toString().padLeft(2, '0')}/${fromDate.year}',
                          style: TextStyle(
                            color: Color(0xff1564C0),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.calendar_today,
                          color: Color(0xFF2196F3),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: toDate,
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2050),
                        builder: (context, child) => Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(),
                              dialogBackgroundColor: Colors.white,
                            ),
                            child: child!
                        )
                    );
                    if (picked != null && picked != toDate) {
                      setState(() => toDate = picked);
                      _updateDateRange();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'To',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${toDate.day.toString().padLeft(2, '0')}/${toDate.month.toString().padLeft(2, '0')}/${toDate.year}',
                          style: TextStyle(
                            color: Color(0xff1564C0),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.calendar_today,
                          color: Color(0xFF2196F3),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// class DateRangePicker extends StatefulWidget {
//   final ValueChanged<DateTime>? onFromDateChanged;
//   final ValueChanged<DateTime>? onToDateChanged;
//
//   const DateRangePicker({
//     Key? key,
//     this.onFromDateChanged,
//     this.onToDateChanged,
//   }) : super(key: key);
//
//   @override
//   _DateRangePickerState createState() => _DateRangePickerState();
// }
//
// class _DateRangePickerState extends State<DateRangePicker> {
//   late DateTime fromDate;
//   late DateTime toDate;
//
//   @override
//   void initState() {
//     super.initState();
//     fromDate = DateTime(2025, 6, 24);
//     toDate = DateTime(2025, 7, 24);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () async {
//                     final DateTime? picked = await showDatePicker(
//                         context: context,
//                         initialDate: fromDate,
//                         firstDate: DateTime(1970),
//                         lastDate: DateTime(2050),
//                         builder: (context, child) => Theme(data: ThemeData.light().copyWith(
//                           colorScheme: ColorScheme.light(),
//                           dialogBackgroundColor: Colors.white,
//                         ), child: child!)
//                     );
//                     if (picked != null && picked != fromDate) {
//                       setState(() => fromDate = picked);
//                     }
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4),
//                       border: Border.all(color: Colors.grey.shade400),
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           'From',
//                           style: TextStyle(
//                             color: Colors.grey.shade700,
//                             fontSize: 10,
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           '${fromDate.day.toString().padLeft(2, '0')}/${fromDate.month.toString().padLeft(2, '0')}/${fromDate.year}',
//                           style: TextStyle(
//                             color: Color(0xFF0046F6),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Spacer(),
//                         Icon(
//                           Icons.calendar_today,
//                           color: Color(0xFF2196F3),
//                           size: 16,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 24),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () async {
//                     final DateTime? picked = await showDatePicker(
//                         context: context,
//                         initialDate: toDate,
//                         firstDate: DateTime(1970),
//                         lastDate: DateTime(2050),
//                         builder: (context, child) => Theme(data: ThemeData.light().copyWith(
//                           colorScheme: ColorScheme.light(),
//                           dialogBackgroundColor: Colors.white,
//                         ), child: child!)
//                     );
//                     if (picked != null && picked != toDate) {
//                       setState(() => toDate = picked);
//                     }
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4),
//                       border: Border.all(color: Colors.grey.shade400),
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           'To',
//                           style: TextStyle(
//                             color: Colors.grey.shade700,
//                             fontSize: 10,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           '${toDate.day.toString().padLeft(2, '0')}/${toDate.month.toString().padLeft(2, '0')}/${toDate.year}',
//                           style: TextStyle(
//                             color: Color(0xFF0046F6),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Spacer(),
//                         Icon(
//                           Icons.calendar_today,
//                           color: Color(0xFF2196F3),
//                           size: 16,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }