import 'package:flutter/material.dart';

class ReusableWorkArea extends StatefulWidget {
  final Function(String)? onWorkAreaChanged;

  const ReusableWorkArea({Key? key, this.onWorkAreaChanged}) : super(key: key);

  @override
  State<ReusableWorkArea> createState() => _ReusableWorkAreaState();
}

class _ReusableWorkAreaState extends State<ReusableWorkArea> {
  int selectedIndex = 0; // Default to first item (Goods & Services)

  final List<String> labels = [
    'Goods & Services',
    'Earning/Leasing',
    'Works',
  ];

  // Map display labels to API codes
  final List<String> apiCodes = [
    'PT', // Goods & Services
    'LT', // Earning/Leasing
    'WT', // Works
  ];

  @override
  void initState() {
    super.initState();
    // Notify parent of initial selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onWorkAreaChanged != null) {
        widget.onWorkAreaChanged!(apiCodes[selectedIndex]);
      }
    });
  }

  void _selectWorkArea(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (widget.onWorkAreaChanged != null) {
      widget.onWorkAreaChanged!(apiCodes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(labels.length, (index) {
            bool isSelected = selectedIndex == index;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              child: SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () => _selectWorkArea(index),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      isSelected ? Colors.white : Color(0xffC3E3FF),
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    side: MaterialStateProperty.all(
                      isSelected
                          ? BorderSide(color: Color(0xff1564C0), width: 1)
                          : BorderSide.none,
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(0), // flat look
                  ),
                  child: Text(
                    labels[index],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}