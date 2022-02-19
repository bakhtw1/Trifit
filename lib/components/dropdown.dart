import 'package:flutter/material.dart';

class DropdownMenu extends StatefulWidget {
  // pass a callback to your widget to be able to get the selected value from a parent
  final Function(String) onValueSelected;
  final List<String> dropdownOptions;
  final String placeholderText;
  bool isDefaultValueFirstItem;
  DropdownMenu({required this.onValueSelected, required this.dropdownOptions, required this.placeholderText, this.isDefaultValueFirstItem = false});

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var option in widget.dropdownOptions) {
      menuItems.add(DropdownMenuItem(child: Text(option), value: option));
    }
    if (widget.isDefaultValueFirstItem) {
      _value = widget.dropdownOptions[0];
      widget.isDefaultValueFirstItem = false;
    }
    return DropdownButton<String>(
        items: menuItems,
        onChanged: (String? value) {
          setState(() {
            _value = value;
            widget.onValueSelected(value!); // call the function passing the value
          });
        },
        hint: Text(widget.placeholderText),
        value: _value,
    );
  }
}