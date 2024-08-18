import 'package:blogify/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

enum SnackBarType { info, success, error, warning }

void showSnackBar({
  required BuildContext context,
  required String content,
  SnackBarType type = SnackBarType.info,
  Duration duration = const Duration(seconds: 4),
}) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  Color getColor() {
    switch (type) {
      case SnackBarType.success:
        return AppPalette.success;
      case SnackBarType.error:
        return AppPalette.error;
      case SnackBarType.warning:
        return AppPalette.warning;
      case SnackBarType.info:
      default:
        return AppPalette.info;
    }
  }

  IconData getIcon() {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_rounded;
      case SnackBarType.info:
      default:
        return Icons.info_outline;
    }
  }

  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(getIcon(),
            color: isDarkMode ? AppPalette.darkText : AppPalette.lightText),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDarkMode ? AppPalette.darkText : AppPalette.lightText,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: getColor(),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    duration: duration,
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: isDarkMode ? AppPalette.darkText : AppPalette.lightText,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
