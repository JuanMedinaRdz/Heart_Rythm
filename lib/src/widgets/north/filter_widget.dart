import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final String title;
  final String field;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const FilterWidget({
    super.key,
    required this.title,
    required this.field,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(title),
          ...options.map((option) => Row(
            children: [
              Radio<String>(
                value: option,
                groupValue: selectedValue,
                onChanged: (value) {
                  if (value != null) {
                    onSelected(value); // Call onSelected without expecting a result
                  }
                },
              ),
              Text(option),
            ],
          )).toList(),
        ],
      ),
    );
  }
}
