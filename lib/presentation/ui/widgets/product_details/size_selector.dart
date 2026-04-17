import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';

class SizeSelector extends StatefulWidget {
  final List<String>? allSize;
  final Function(String) onChange;
  const SizeSelector({
    super.key,
    required this.allSize,
    required this.onChange,
  });

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  String? _selectedSize;
  @override
  void initState() {
    super.initState();
    _selectedSize = widget.allSize != null && widget.allSize!.isNotEmpty
        ? widget.allSize!.first
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widget.allSize!
          .map(
            (size) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  _selectedSize = size;
                  widget.onChange(size);
                  setState(() {});
                },
                child: CircleAvatar(
                  backgroundColor: _selectedSize == size
                      ? AppColors.primaryColor
                      : null,
                  foregroundColor: _selectedSize == size ? Colors.white : null,
                  radius: 18,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FittedBox(
                      child: Text(
                        size,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
