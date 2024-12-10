import 'package:flutter/material.dart';

class CsSlider extends StatelessWidget {
  const CsSlider({
    required this.value,
    this.onChanged,
    this.onChangedEnd,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.label,
    super.key,
  });

  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final void Function(double)? onChanged;
  final void Function(double)? onChangedEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        sliderTheme: SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        onChangeEnd: onChangedEnd,
      ),
    );
  }
}
