import 'package:flutter/material.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({super.key});

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool isShowDetails = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
            overflow: isShowDetails
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
          ),
          maxLines: isShowDetails ? null : 5,
          "If the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle].f the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle The [overflow] property's behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option. If the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle].f the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle The [overflow] property's behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option. If the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle].f the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle The [overflow] property's behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option. If the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle].f the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle The [overflow] property's behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option. If the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle].f the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle The [overflow] property's behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option. If the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle].f the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle The [overflow] property's behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option. If the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle].f the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle The [overflow] property's behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option. If the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle].f the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle The [overflow] property's behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option. If the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle].f the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle The [overflow] property's behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option. If the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle].f the [style] argument is null, the text will use the style from the closest enclosing [DefaultTextStyle The [overflow] property's behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option.",
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  isShowDetails = !isShowDetails;
                });
              },
              child: isShowDetails ? Text("Show Less") : Text("Show More"),
            ),
          ],
        ),
      ],
    );
  }
}
