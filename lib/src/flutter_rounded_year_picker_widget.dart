// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rounded_date_picker/src/era_mode.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_year_picker_style.dart';

import 'dialogs/flutter_rounded_year_picker_dialog.dart';

Future<DateTime?> showRoundedYearPicker({
  required BuildContext context,
  double? height = 320.0,
  DateTime? initialYear,
  DateTime? minimumYear,
  DateTime? maximumYear,
  Locale? locale,
  TextDirection? textDirection,
  ThemeData? theme,
  double borderRadius = 16,
  EraMode era = EraMode.BUDDHIST_YEAR,
  ImageProvider? imageHeader,
  String description = "",
  String? fontFamily,
  bool barrierDismissible = false,
  Color background = Colors.transparent,
  String? textNegativeButton,
  String? textPositiveButton,
  String? textActionButton,
  VoidCallback? onTapActionButton,
  MaterialRoundedDatePickerStyle? styleDatePicker,
  MaterialRoundedYearPickerStyle? styleYearPicker,
}) async {
  initialYear ??= DateTime.now();
  minimumYear ??= DateTime(initialYear.year - 1);
  maximumYear ??= DateTime(initialYear.year + 1);
  theme ??= ThemeData();

  assert(
    !initialYear.isBefore(minimumYear),
    'initialDate must be on or after firstDate',
  );
  assert(
    !initialYear.isAfter(maximumYear),
    'initialDate must be on or before lastDate',
  );
  assert(
    !minimumYear.isAfter(maximumYear),
    'lastDate must be on or after firstDate',
  );
  assert(
    (onTapActionButton != null && textActionButton != null) ||
        onTapActionButton == null,
    "If you provide onLeftBtn, you must provide leftBtn",
  );
  assert(debugCheckHasMaterialLocalizations(context));

  Widget child = GestureDetector(
    onTap: () {
      if (!barrierDismissible) {
        Navigator.pop(context);
      }
    },
    child: Container(
      color: background,
      child: GestureDetector(
        onTap: () {
          //
        },
        child: FlutterRoundedYearPickerDialog(
          height: height,
          initialYear: initialYear,
          minimumYear: minimumYear,
          maximumYear: maximumYear,
          era: era,
          locale: locale,
          borderRadius: borderRadius,
          imageHeader: imageHeader,
          description: description,
          fontFamily: fontFamily,
          textNegativeButton: textNegativeButton,
          textPositiveButton: textPositiveButton,
          textActionButton: textActionButton,
          onTapActionButton: onTapActionButton,
          styleDatePicker: styleDatePicker,
          styleYearPicker: styleYearPicker,
        ),
      ),
    ),
  );

  if (textDirection != null) {
    child = Directionality(
      textDirection: textDirection,
      child: child,
    );
  }

  if (locale != null) {
    child = Localizations.override(
      context: context,
      locale: locale,
      child: child,
    );
  }

  return await showDialog<DateTime>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => Theme(data: theme!, child: child),
  );
}
