import 'package:flutter/material.dart';

class DropdownMenu extends StatefulWidget {
  // pass a callback to your widget to be able to get the selected value from a parent
  final Function(String) onValueSelected;

  DropdownMenu({required this.onValueSelected});

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        items: const [
          DropdownMenuItem<String>(
            child: Text('Snack'),
            value: 'Snack',
          ),
          DropdownMenuItem<String>(
            child: Text('Breakfast'),
            value: 'Breakfast',
          ),
          DropdownMenuItem<String>(
            child: Text('Lunch'),
            value: 'Lunch',
          ),
          DropdownMenuItem<String>(
            child: Text('Dinner'),
            value: 'Dinner',
          ),
        ],
        onChanged: (String? value) {
          setState(() {
            _value = value;
            widget.onValueSelected(value!); // call the function passing the value
          });
        },
        hint: Text('Meal Type'),
        value: _value,
    );
  }
}