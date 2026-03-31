import 'package:flutter/material.dart';

class ColorSelector extends StatefulWidget {
  final List<Color>? allColors;
  final Function(Color) onChange;
  const ColorSelector({super.key,required this.allColors, required this.onChange});

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.allColors!.first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widget.allColors!
          .map(
            (c) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  _selectedColor = c;
                  widget.onChange(c);
                  setState(() {});
                },
                child: CircleAvatar(
                  backgroundColor: c,
                  radius: 16,
                  child: _selectedColor == c
                      ? Icon(Icons.done, color: Colors.white)
                      : null,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
