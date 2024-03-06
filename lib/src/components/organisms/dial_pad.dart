import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// Dial pad gives the user the ability to dial a number and start a call.
///
/// It also has a quick dial security action and a delete entry action.
class ZdsDialPad extends StatefulWidget {
  /// Constructs a [ZdsDialPad].
  const ZdsDialPad({
    super.key,
    this.subtitle,
    this.subtitleColor,
    this.onNumberTapped,
    this.onCallTapped,
    this.onSecurityTapped,
    this.initialValue = '',
    this.leftButton,
    this.buttonValues,
    this.onTextTapped,
    this.showText = false,
  });

  /// (Optional) Text that appears above the entered number.
  final String? subtitle;

  /// Color of subtitle text that appears above the entered number.
  ///
  /// Defaults to primary color.
  final Color? subtitleColor;

  /// Returns tapped number for each tap.
  ///
  /// When backspace is selected, `-1` is returned.
  final ValueChanged<String>? onNumberTapped;

  /// Returns tapped text for each tap after a short delay
  ///
  /// When backspace is selected, `-1` is returned.
  final ValueChanged<String>? onTextTapped;

  /// Returns full number entered when call button is tapped.
  final ValueChanged<String>? onCallTapped;

  /// Returns full number entered when security button is tapped.
  final ValueChanged<String>? onSecurityTapped;

  /// Initial value in dial pad.
  final String initialValue;

  /// Button to show left of call button, typically a [ZdsRoundButton] with [ZdsRoundButtonSize.medium].
  ///
  /// Defaults to Security button using [onSecurityTapped].
  ///
  /// To hide this button, pass an empty widget, such as a [SizedBox].
  final Widget? leftButton;

  /// See [ZetaDialPad.buttonValues].
  final Map<String, String>? buttonValues;

  /// Whether the display should show text or number.
  ///
  /// Defaults to false (shows numbers).
  final bool showText;

  @override
  State<ZdsDialPad> createState() => _ZdsDialPadState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('subtitle', subtitle))
      ..add(ColorProperty('subtitleColor', subtitleColor))
      ..add(ObjectFlagProperty<ValueChanged<String>>.has('onNumberTapped', onNumberTapped))
      ..add(ObjectFlagProperty<ValueChanged<String>>.has('onCall', onCallTapped))
      ..add(ObjectFlagProperty<ValueChanged<String>>.has('onSecurity', onSecurityTapped))
      ..add(StringProperty('initialValue', initialValue))
      ..add(DiagnosticsProperty<Map<String, String>?>('buttonValues', buttonValues))
      ..add(ObjectFlagProperty<ValueChanged<String>?>.has('onTextTapped', onTextTapped))
      ..add(DiagnosticsProperty<bool>('showText', showText));
  }
}

const Map<String, String> _defaultButtonValues = {
  '1': '',
  '2': 'ABC',
  '3': 'DEF',
  '4': 'GHI',
  '5': 'JKL',
  '6': 'MNO',
  '7': 'PQRS',
  '8': 'TUV',
  '9': 'WXYZ',
  '*': '',
  '0': '+',
  '#': '',
};

class _ZdsDialPadState extends State<ZdsDialPad> with AutomaticKeepAliveClientMixin {
  late String _number;
  late String _text;
  String? _lastTapped;
  int _tapCounter = 0;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _number = _text = widget.initialValue.toNumber;
  }

  Map<String, String> get _buttonValues => widget.buttonValues ?? _defaultButtonValues;

  void onNumberTap(String added) {
    if (widget.showText) {
      if (_lastTapped == added) {
        _tapCounter++;
        final letters = _buttonValues[_lastTapped];
        final List<String> options = letters!.split('');
        final int index = _tapCounter % options.length;
        _debounce?.cancel();

        setState(() {
          _text = _text.substring(0, _text.length - 1) + letters[index];
          _debounce = Timer(const Duration(milliseconds: 500), _debounceCallback);
        });
      } else {
        _debounce?.cancel();
        final letters = _buttonValues[added];
        final List<String> options = letters!.split('');

        setState(() {
          _text += options.first;
          _lastTapped = added;
          _tapCounter = 0;
          _debounce = Timer(const Duration(milliseconds: 500), _debounceCallback);
        });
      }
    } else {
      setState(() => _number += added);
    }
    widget.onNumberTapped?.call(added);
  }

  void _debounceCallback() {
    setState(() {
      _lastTapped = null;
      _tapCounter = 0;
    });
  }

  void backSpace() {
    if (_number.isNotEmpty) setState(() => _number = _number.substring(0, _number.length - 1));
    if (_text.isNotEmpty) setState(() => _text = _text.substring(0, _text.length - 1));
    widget.onNumberTapped?.call('-1');
    widget.onTextTapped?.call('-1');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colors = Zeta.of(context).colors;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 384),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: ZetaSpacing.x4),
            Text(
              widget.subtitle ?? '',
              style: ZetaTextStyles.bodySmall.apply(color: widget.subtitleColor ?? colors.primary),
            ),
            const SizedBox(height: ZetaSpacing.xs),
            Text(widget.showText ? _text : _number, style: ZetaTextStyles.heading1),
            const SizedBox(height: ZetaSpacing.m),
            ZetaDialPad(
              onNumber: onNumberTap,
              buttonValues: widget.buttonValues,
              onText: widget.onTextTapped,
            ),
            const SizedBox(height: ZetaSpacing.m),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.leftButton != null
                        ? widget.leftButton is ZdsRoundButton
                            ? ZdsRoundButton(
                                type: (widget.leftButton! as ZdsRoundButton).type,
                                icon: (widget.leftButton! as ZdsRoundButton).icon,
                                activeIcon: (widget.leftButton! as ZdsRoundButton).activeIcon,
                                activeLabel: (widget.leftButton! as ZdsRoundButton).activeLabel,
                                label: (widget.leftButton! as ZdsRoundButton).label,
                                onTap: (widget.leftButton! as ZdsRoundButton).onTap,
                                size: ZdsRoundButtonSize.medium,
                              )
                            : SizedBox.square(dimension: 60, child: widget.leftButton)
                        : ZdsRoundButton(
                            type: ZdsRoundButtonType.alert,
                            icon: Icons.notifications_active_rounded,
                            label: ComponentStrings.of(context).get('SECURITY', 'Security'),
                            size: ZdsRoundButtonSize.medium,
                            onTap: () => widget.onSecurityTapped?.call(_number),
                          ))
                    .paddingTop(ZetaSpacing.x4),
                ZdsRoundButton(
                  type: ZdsRoundButtonType.positive,
                  icon: ZetaIcons.phone_round,
                  onTap: () => widget.onCallTapped?.call(_number),
                  size: ZdsRoundButtonSize.xlarge,
                ),
                IconButton(
                  onPressed: backSpace,
                  icon: const Icon(ZetaIcons.backspace_round),
                  color: Zeta.of(context).colors.iconDisabled,
                ),
              ],
            ).paddingHorizontal(ZetaSpacing.l),
          ],
        ).paddingHorizontal(ZetaSpacing.x3),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('number', _number));
  }

  @override
  bool get wantKeepAlive => true;
}

extension on String? {
  String get toNumber => this == null ? '' : this!.replaceAll(RegExp('[^0-9+*#]'), '');
}

const double _dialPadSheetSizeMax = 680;
const double _dialPadSheetSizeMin = 400;

/// Helper method to show a [ZdsDialPad] in a Modal bottom sheet.
Future<void> showZdsDialPadSheet(
  BuildContext context, {
  String? subtitle,
  Color? subtitleColor,
  ValueChanged<String>? onNumberTapped,
  ValueChanged<String>? onCallTapped,
  ValueChanged<String>? onSecurityTapped,
  String initialValue = '',
  Map<String, Widget>? pages,
  Map<String, String>? buttonValues,
  Widget? leftButton,
  ValueChanged<String>? onTextTapped,
  bool showText = false,
}) async {
  final colors = Zeta.of(context).colors;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxWidth: _dialPadSheetSizeMax,
      minWidth: MediaQuery.of(context).size.width.clamp(0, _dialPadSheetSizeMin),
      maxHeight: _dialPadSheetSizeMax + MediaQuery.of(context).padding.bottom,
    ),
    backgroundColor: colors.surfaceTertiary,
    builder: (context) {
      return SafeArea(
        child: DefaultTabController(
          length: (pages?.length ?? 0) + 1,
          child: Column(
            children: [
              Container(
                width: ZetaSpacing.x11,
                height: ZetaSpacing.x1,
                margin: const EdgeInsets.only(top: ZetaSpacing.x5, bottom: ZetaSpacing.x2),
                decoration: BoxDecoration(
                  color: colors.borderDefault,
                  borderRadius: ZetaRadius.wide,
                ),
              ),
              Expanded(
                child: Scaffold(
                  body: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          children: [
                            ZdsDialPad(
                              subtitle: subtitle,
                              subtitleColor: subtitleColor,
                              onNumberTapped: onNumberTapped,
                              onCallTapped: onCallTapped,
                              onSecurityTapped: onSecurityTapped,
                              initialValue: initialValue,
                              buttonValues: buttonValues,
                              leftButton: leftButton,
                              onTextTapped: onTextTapped,
                              showText: showText,
                            ),
                            if (pages != null && pages.isNotEmpty)
                              ...List.generate(pages.length, (index) => pages.values.toList()[index]),
                          ],
                        ),
                      ),
                      const SizedBox(height: ZetaSpacing.x6),
                      if (pages != null && pages.isNotEmpty)
                        ZdsTabBar(
                          tabs: [
                            ZdsTab(label: ComponentStrings.of(context).get('DIAL_PAD', 'Dial Pad')),
                            ...List.generate(pages.length, (index) => ZdsTab(label: pages.keys.toList()[index])),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
