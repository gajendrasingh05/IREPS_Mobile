import 'package:flutter/material.dart';

class ReusableInputField extends StatelessWidget {
  final String label;
  final Color? color;
  final Icon icon;
  final TextEditingController controller;
  const ReusableInputField({super.key, required this.label, required this.icon,required this.controller, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: SizedBox( height: 44,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            labelText: label,
            labelStyle: color == null ? TextStyle(color: Colors.black54) : TextStyle(color: color),
            prefixIcon: icon,
            prefixIconColor: Colors.blueAccent.shade200,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                color: Colors.grey.shade400, width: 1), borderRadius: BorderRadius.circular(4)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                color: Colors.blueAccent.shade100, width: 2), borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ),
    );
  }
}
