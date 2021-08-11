import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/src/era_mode.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';

class FlutterRoundedYearPickerHeader extends StatelessWidget {
  const FlutterRoundedYearPickerHeader({
    Key? key,
    required this.selectedDate,
    required this.orientation,
    required this.era,
    required this.borderRadius,
    this.imageHeader,
    this.description = "",
    this.fontFamily,
    this.style,
  }) : super(key: key);

  final DateTime selectedDate;
  final Orientation orientation;
  final MaterialRoundedDatePickerStyle? style;

  /// Era custom
  final EraMode era;

  /// Border
  final double borderRadius;

  ///  Header
  final ImageProvider? imageHeader;

  /// Header description
  final String description;

  /// Font
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme headerTextTheme = themeData.primaryTextTheme;
    Color? yearColor;
    switch (themeData.primaryColorBrightness) {
      case Brightness.light:
        yearColor = Colors.black87;
        break;
      case Brightness.dark:
        yearColor = Colors.white;
        break;
    }

    final TextStyle yearStyle = style?.textStyleYearButton ??
        headerTextTheme.subtitle1!
            .copyWith(color: yearColor, fontFamily: fontFamily);

    Color? backgroundColor;
    if (style?.backgroundHeader != null) {
      backgroundColor = style?.backgroundHeader;
    } else {
      switch (themeData.brightness) {
        case Brightness.dark:
          backgroundColor = themeData.backgroundColor;
          break;
        case Brightness.light:
          backgroundColor = themeData.primaryColor;
          break;
      }
    }

    EdgeInsets padding;
    MainAxisAlignment mainAxisAlignment;
    switch (orientation) {
      case Orientation.landscape:
        padding = style?.paddingDateYearHeader ?? EdgeInsets.all(8.0);
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case Orientation.portrait:
      default:
        padding = style?.paddingDateYearHeader ?? EdgeInsets.all(16.0);
        mainAxisAlignment = MainAxisAlignment.center;
        break;
    }

    BorderRadius borderRadiusData = BorderRadius.only(
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
    );

    if (orientation == Orientation.landscape) {
      borderRadiusData = BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        bottomLeft: Radius.circular(borderRadius),
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: imageHeader != null
            ? DecorationImage(image: imageHeader!, fit: BoxFit.cover)
            : null,
        color: backgroundColor,
        borderRadius: borderRadiusData,
      ),
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8.0),
          Visibility(
            visible: description.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                description,
                style: yearStyle,
              ),
            ),
          ),
          const SizedBox(height: 4.0),
        ],
      ),
    );
  }
}
