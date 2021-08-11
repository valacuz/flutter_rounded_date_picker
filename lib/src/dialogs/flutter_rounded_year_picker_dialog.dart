import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/src/era_mode.dart';
import 'package:flutter_rounded_date_picker/src/flutter_rounded_button_action.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_year_picker_style.dart';
import 'package:flutter_rounded_date_picker/src/widgets/flutter_rounded_year_picker.dart';
import 'package:flutter_rounded_date_picker/src/widgets/flutter_rounded_year_picker_header.dart';

class FlutterRoundedYearPickerDialog extends StatefulWidget {
  const FlutterRoundedYearPickerDialog({
    Key? key,
    this.height,
    required this.initialYear,
    required this.minimumYear,
    required this.maximumYear,
    required this.era,
    this.locale,
    required this.borderRadius,
    this.imageHeader,
    this.description = "",
    this.fontFamily,
    this.textNegativeButton,
    this.textPositiveButton,
    this.textActionButton,
    this.onTapActionButton,
    this.styleDatePicker,
    this.styleYearPicker,
  }) : super(key: key);

  final DateTime initialYear;
  final DateTime minimumYear;
  final DateTime maximumYear;

  /// double height.
  final double? height;

  /// Custom era year.
  final EraMode era;
  final Locale? locale;

  /// Border
  final double borderRadius;

  ///  Header;
  final ImageProvider? imageHeader;
  final String description;

  /// Font
  final String? fontFamily;

  /// Button
  final String? textNegativeButton;
  final String? textPositiveButton;
  final String? textActionButton;

  final VoidCallback? onTapActionButton;

  /// Style
  final MaterialRoundedDatePickerStyle? styleDatePicker;
  final MaterialRoundedYearPickerStyle? styleYearPicker;

  @override
  _FlutterRoundedYearPickerDialogState createState() =>
      _FlutterRoundedYearPickerDialogState();
}

class _FlutterRoundedYearPickerDialogState
    extends State<FlutterRoundedYearPickerDialog> {
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialYear;
  }

  bool _announcedInitialDate = false;

  late MaterialLocalizations localizations;
  late TextDirection textDirection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
    textDirection = Directionality.of(context);
    if (!_announcedInitialDate) {
      _announcedInitialDate = true;
      SemanticsService.announce(
        localizations.formatFullDate(_selectedDate),
        textDirection,
      );
    }
  }

  late DateTime _selectedDate;
  final GlobalKey _pickerKey = GlobalKey();

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
      default:
        break;
    }
  }

  void _handleYearChanged(DateTime value) {
    if (value.isBefore(widget.minimumYear)) {
      value = widget.minimumYear;
    } else if (value.isAfter(widget.maximumYear)) {
      value = widget.maximumYear;
    }
    if (value == _selectedDate) return;

    _vibrate();
    setState(() {
      _selectedDate = value;
    });
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  void _handleOk() {
    Navigator.of(context).pop(_selectedDate);
  }

  Widget _buildPicker() {
    return FlutterRoundedYearPicker(
      key: _pickerKey,
      selectedDate: _selectedDate,
      onChanged: _handleYearChanged,
      firstDate: widget.minimumYear,
      lastDate: widget.maximumYear,
      era: widget.era,
      fontFamily: widget.fontFamily,
      style: widget.styleYearPicker,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget picker = _buildPicker();

    final Widget actions = FlutterRoundedButtonAction(
      textButtonNegative: widget.textNegativeButton,
      textButtonPositive: widget.textPositiveButton,
      onTapButtonNegative: _handleCancel,
      onTapButtonPositive: _handleOk,
      textActionButton: widget.textActionButton,
      onTapButtonAction: widget.onTapActionButton,
      localizations: localizations,
      textStyleButtonNegative: widget.styleDatePicker?.textStyleButtonNegative,
      textStyleButtonPositive: widget.styleDatePicker?.textStyleButtonPositive,
      textStyleButtonAction: widget.styleDatePicker?.textStyleButtonAction,
      borderRadius: widget.borderRadius,
      paddingActionBar: widget.styleDatePicker?.paddingActionBar,
      background: widget.styleDatePicker?.backgroundActionBar,
    );

    Color backgroundPicker =
        widget.styleYearPicker?.backgroundPicker ?? theme.dialogBackgroundColor;

    final Dialog dialog = Dialog(
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        final Widget header = FlutterRoundedYearPickerHeader(
          selectedDate: _selectedDate,
          orientation: orientation,
          era: widget.era,
          borderRadius: widget.borderRadius,
          imageHeader: widget.imageHeader,
          description: widget.description,
          fontFamily: widget.fontFamily,
          style: widget.styleDatePicker,
        );
        switch (orientation) {
          case Orientation.landscape:
            return Container(
              decoration: BoxDecoration(
                color: backgroundPicker,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(flex: 1, child: header),
                  Flexible(
                    flex: 2, // have the picker take up 2/3 of the dialog width
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Flexible(child: picker),
                        actions,
                      ],
                    ),
                  ),
                ],
              ),
            );
          case Orientation.portrait:
          default:
            return Container(
              decoration: BoxDecoration(
                color: backgroundPicker,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  header,
                  if (widget.height == null)
                    Flexible(child: picker)
                  else
                    SizedBox(
                      height: widget.height,
                      child: picker,
                    ),
                  actions,
                ],
              ),
            );
        }
      }),
    );

    return Theme(
      data: theme.copyWith(dialogBackgroundColor: Colors.transparent),
      child: dialog,
    );
  }
}
