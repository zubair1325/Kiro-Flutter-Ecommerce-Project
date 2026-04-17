import 'package:flutter/material.dart';

List<Color> parseColors(String colorString) {
  final colorNames = colorString
      .replaceAll(',', ' ')
      .split(' ')
      .where((e) => e.trim().isNotEmpty);

  final Map<String, Color> colorMap = {
    'red': Colors.red,
    'green': Colors.green,
    'blue': Colors.blue,
    'yellow': Colors.yellow,
    'black': Colors.black,
    'white': Colors.white,
    'grey': Colors.grey,
    'gray': Colors.grey,
    'orange': Colors.orange,
    'purple': Colors.purple,
    'pink': Colors.pink,
    'brown': Colors.brown,
    'cyan': Colors.cyan,
    'teal': Colors.teal,
    'indigo': Colors.indigo,
    'lime': Colors.lime,
    'amber': Colors.amber,
    'deeporange': Colors.deepOrange,
    'deeppurple': Colors.deepPurple,
    'lightblue': Colors.lightBlue,
    'lightgreen': Colors.lightGreen,
    'bluegrey': Colors.blueGrey,
  };

  return colorNames.map((name) {
    final key = name.toLowerCase().replaceAll(' ', '');

    if (colorMap.containsKey(key)) {
      return colorMap[key]!;
    }

    if (key.startsWith('#')) {
      return _hexToColor(key);
    } else if (key.length == 6 || key.length == 8) {
      return _hexToColor('#$key');
    }

    return Colors.grey;
  }).toList();
}

Color _hexToColor(String hex) {
  hex = hex.replaceAll('#', '');

  if (hex.length == 6) {
    hex = 'FF$hex';
  }

  return Color(int.parse(hex, radix: 16));
}

String getColorName(Color color) {
  
  const Map<String, Color> colorMap = {
    'red': Colors.red,
    'green': Colors.green,
    'blue': Colors.blue,
    'yellow': Colors.yellow,
    'black': Colors.black,
    'white': Colors.white,
    'grey': Colors.grey,
    'gray': Colors.grey,
    'orange': Colors.orange,
    'purple': Colors.purple,
    'pink': Colors.pink,
    'brown': Colors.brown,
    'cyan': Colors.cyan,
    'teal': Colors.teal,
    'indigo': Colors.indigo,
    'lime': Colors.lime,
    'amber': Colors.amber,
    'deeporange': Colors.deepOrange,
    'deeppurple': Colors.deepPurple,
    'lightblue': Colors.lightBlue,
    'lightgreen': Colors.lightGreen,
    'bluegrey': Colors.blueGrey,
  };

  for (final entry in colorMap.entries) {
    if (entry.value.value == color.value) {
      return entry.key;
    }
  }

  return "unknown";
}
