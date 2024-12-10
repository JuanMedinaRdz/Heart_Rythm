import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/core/constants/app_color.dart';

class SelectionButtonGroup extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const SelectionButtonGroup({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options
            .map(
              (option) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedValue == option
                        ? AppColors.primaryEnd
                        : Colors.transparent,
                    side: const BorderSide(color: AppColors.primaryStart),
                  ),
                  onPressed: () => onSelected(option),
                  child: Text(option),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}