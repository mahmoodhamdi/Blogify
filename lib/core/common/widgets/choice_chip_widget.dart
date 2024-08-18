import 'package:blogify/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class ChoiceChipWidget extends StatefulWidget {
  const ChoiceChipWidget({super.key});

  @override
  _ChoiceChipWidgetState createState() => _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<ChoiceChipWidget> {
  final Set<int> _selectedIndices = {};
  final List<String> _options = [
    'Nature',
    'Tech',
    'Traditions',
    'Philosophy',
    'Art',
    'Leadership',
    'Food'
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 15.0,
      children: List<Widget>.generate(
        _options.length,
        (int index) {
          return ChoiceChip(
            label: Text(_options[index]),
            selected: _selectedIndices.contains(index),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _selectedIndices.add(index);
                } else {
                  _selectedIndices.remove(index);
                }
              });
            },
            selectedColor: AppPallete.gradient2,
            backgroundColor: AppPallete.transparentColor,
            side: BorderSide(
              color: _selectedIndices.contains(index)
                  ? AppPallete.gradient2
                  : AppPallete.borderColor,
            ),
            labelStyle: TextStyle(
              color: _selectedIndices.contains(index)
                  ? AppPallete.whiteColor
                  : AppPallete.greyColor,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          );
        },
      ).toList(),
    );
  }
}
