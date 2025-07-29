import 'package:flutter/material.dart';

class ReusableDatePicker extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final DateTime? initialDate;

  const ReusableDatePicker({
    Key? key,
    this.onDateSelected,
    this.initialDate,
  }) : super(key: key);

  @override
  State<ReusableDatePicker> createState() => _ReusableDatePicker();
}

class _ReusableDatePicker extends State<ReusableDatePicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });

      // Notify parent widget about date selection
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }

  String _formattedDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: GestureDetector(
          onTap: _pickDate,
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: 'Tender Closing Date (optional)',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              prefixIcon: Icon(Icons.calendar_today, color: Colors.blue, size: 16),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
            child: Text(
              _selectedDate != null
                  ? _formattedDate(_selectedDate!)
                  : 'Tender Closing Date',
              style: TextStyle(fontSize: 16, color: Color(0xff1564C0),fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}