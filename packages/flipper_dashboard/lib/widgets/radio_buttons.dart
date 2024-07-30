import 'package:flutter/material.dart';

class RadioButtons extends StatefulWidget {
  final List<String> buttonLabels;
  final Function(int) onChanged;
  final int? initialSelection;
  final Color activeColor;
  final Color inactiveColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const RadioButtons({
    Key? key,
    required this.buttonLabels,
    required this.onChanged,
    this.initialSelection,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.textColor = Colors.white,
    this.fontSize = 15,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.margin = const EdgeInsets.all(4),
  }) : super(key: key);

  @override
  _RadioButtonsState createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  late int selectedButtonIndex;

  @override
  void initState() {
    super.initState();
    selectedButtonIndex = widget.initialSelection ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.buttonLabels.length,
          (index) => buildButton(index, widget.buttonLabels[index]),
        ),
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
          color: isSelected ? widget.activeColor : widget.inactiveColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: widget.activeColor.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
          ],
        ),
        padding: widget.padding,
        margin: widget.margin,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? widget.textColor : Colors.black,
            fontSize: widget.fontSize,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
