import 'package:flutter/material.dart';

class ProductDescription extends StatefulWidget {
  final String description;
  const ProductDescription({super.key, required this.description});

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool isShowDetails = false;
  bool isOverflowing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkTextOverflow();
  }

  void _checkTextOverflow() {
    final textSpan = TextSpan(
      text: widget.description,
      style: const TextStyle(fontSize: 13),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 5,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    setState(() {
      isOverflowing = textPainter.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.description,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
          maxLines: isShowDetails ? null : 5,
          overflow: isShowDetails
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
        ),

        if (isOverflowing)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isShowDetails = !isShowDetails;
                  });
                },
                child: Text(isShowDetails ? "Show Less" : "Show More"),
              ),
            ],
          ),
      ],
    );
  }
}
