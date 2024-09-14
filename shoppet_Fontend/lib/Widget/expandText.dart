import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;

  const ExpandableText({required this.text, this.trimLines = 3});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(
      text: widget.text,
      style: const TextStyle(color: Colors.black),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.trimLines,
      textDirection: TextDirection.ltr,
      ellipsis: '...',
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    final isTextOverflowing = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.all(5),
          child: Text(
            widget.text,
            maxLines: isExpanded ? null : widget.trimLines,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: "Itim", color: Color.fromRGBO(
                182, 182, 182, 1.0)),
          ),
        ),

        const Divider(
          color: Color.fromRGBO(199, 199, 199, 1.0),  // Màu của đường gạch ngang
          thickness: 1.0,      // Độ dày của đường gạch ngang
          indent: 0.0,        // Khoảng cách từ mép trái đến bắt đầu của đường gạch ngang
          endIndent: 0.0,     // Khoảng cách từ mép phải đến cuối của đường gạch ngang
        ),

        if (isTextOverflowing)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isExpanded ? "Ẩn Bớt" : "Xem Thêm",
                  style: const TextStyle(color: Color.fromRGBO(125, 125, 125, 1.0), fontFamily: "Itim"),
                ),
                isExpanded ? const Icon(Icons.keyboard_arrow_up, color: Color.fromRGBO(
                    125, 125, 125, 1.0),) : const Icon(Icons.keyboard_arrow_down, color: Color.fromRGBO(
                    125, 125, 125, 1.0),)
              ],
            )
          ),
      ],
    );
  }
}