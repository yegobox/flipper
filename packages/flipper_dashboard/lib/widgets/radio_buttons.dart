import 'package:flutter/material.dart';

class RadioButtons extends StatefulWidget {
  final List<String> buttonLabels;
  final Function(int) onChanged;

  RadioButtons({required this.buttonLabels, required this.onChanged});

  @override
  _RadioButtonsState createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  int selectedButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        widget.buttonLabels.length,
        (index) => buildButton(index, widget.buttonLabels[index]),
      ),
    );
  }

  Widget buildButton(int index, String text) {
    bool isSelected = selectedButtonIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedButtonIndex = index;
        });
        widget.onChanged(selectedButtonIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
        margin: EdgeInsets.all(5),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
