import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/src/era_mode.dart';
import 'package:flutter_rounded_date_picker/src/flutter_cupertino_rounded_date_picker_widget.dart';

class CupertinoRoundedYearPicker {
  static show(
    BuildContext context, {
    Locale? locale,
    DateTime? initialYear,
    DateTime? minimumYear,
    DateTime? maximumYear,
    Function(DateTime)? onYearChanged,
    EraMode era = EraMode.CHRIST_YEAR,
    double borderRadius = 16,
    String? fontFamily,
    Color background = Colors.white,
    Color textColor = Colors.black54,
  }) async {
    initialYear ??= DateTime.now();
    minimumYear ??= DateTime(initialYear.year - 1);
    maximumYear ??= DateTime(initialYear.year + 1);

    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return FlutterRoundedCupertinoYearPickerWidget(
          onYearChanged: (year) {
            if (onYearChanged != null) {
              onYearChanged(year);
            }
          },
          era: era,
          background: background,
          textColor: textColor,
          borderRadius: borderRadius,
          fontFamily: fontFamily,
          initialYear: initialYear!,
          maximumYear: maximumYear!,
          minimumYear: minimumYear!,
        );
      },
    );
  }
}
