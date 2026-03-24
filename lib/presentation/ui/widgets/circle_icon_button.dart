import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.iconData,
    required this.onTap,
  });
  final IconData iconData;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(iconData, color: Colors.grey),
      ),
    );
  }
}
