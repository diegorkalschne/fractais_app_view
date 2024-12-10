import 'package:flutter/material.dart';

class CsRadioButton<T> extends StatelessWidget {
  const CsRadioButton({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
  });

  final String label;
  final T? value;
  final T groupValue;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      borderRadius: BorderRadius.circular(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Radio<T?>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
