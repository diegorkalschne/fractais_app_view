import 'package:flutter/material.dart';

class CsLabelWidget extends StatelessWidget {
  const CsLabelWidget({
    required this.label,
    required this.child,
    this.fontSize = 16,
    this.actions = const [],
    super.key,
  });

  final String? label;
  final double fontSize;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (label != null) ...[
              Expanded(
                child: Text(
                  label!,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: fontSize,
                  ),
                ),
              ),
            ],
            ...actions,
          ],
        ),
        Flexible(child: child),
      ],
    );
  }
}
