import 'package:blogify/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class ChoiceChipWidget extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;

  const ChoiceChipWidget({super.key, required this.onSelectionChanged});

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                widget.onSelectionChanged(
                    _selectedIndices.map((i) => _options[i]).toList());
              });
            },
            selectedColor:
                isDarkMode ? AppPalette.darkAccent : AppPalette.lightAccent,
            backgroundColor: AppPalette.transparent,
            side: BorderSide(
              color: _selectedIndices.contains(index)
                  ? (isDarkMode
                      ? AppPalette.darkPrimary
                      : AppPalette.lightPrimary)
                  : (isDarkMode
                      ? AppPalette.darkSurface
                      : AppPalette.lightSurface),
            ),
            labelStyle: TextStyle(
              color: _selectedIndices.contains(index)
                  ? (isDarkMode ? AppPalette.darkText : AppPalette.lightText)
                  : (isDarkMode
                      ? AppPalette.darkText.withOpacity(0.7)
                      : AppPalette.lightText.withOpacity(0.7)),
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
