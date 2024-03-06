import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../zds_flutter.dart';

/// Button type for [ZdsRoundButton]
enum ZdsRoundButtonType {
  /// Positive button, defaults to green
  positive,

  /// Negative button, defaults to red
  negative,

  ///Alert button, defaults to white
  alert,

  /// Untoggled button, defaults to white
  base,

  /// Toggled button, defaults to black
  toggled
}

/// Button size for [ZdsRoundButton]
enum ZdsRoundButtonSize {
  /// 100 x 100
  xlarge,

  /// 80 x 80
  large,

  /// 60 x 60
  medium,

  /// 44 x 44
  small
}

extension on ZdsRoundButtonSize {
  TextStyle get textStyle {
    switch (this) {
      case ZdsRoundButtonSize.xlarge:
      case ZdsRoundButtonSize.large:
        return ZetaTextStyles.labelLarge;
      case ZdsRoundButtonSize.medium:
        return ZetaTextStyles.labelMedium;
      case ZdsRoundButtonSize.small:
        return ZetaTextStyles.labelSmall;
    }
  }
}

extension on ZdsRoundButtonType {
  Color color(ZetaColors colors) {
    switch (this) {
      case ZdsRoundButtonType.positive:
        return colors.positive;
      case ZdsRoundButtonType.negative:
        return colors.negative;
      case ZdsRoundButtonType.alert:
        return colors.surfacePrimary;
      case ZdsRoundButtonType.base:
        return colors.cool.shade20;
      case ZdsRoundButtonType.toggled:
        return colors.cool.shade90;
    }
  }

  Color borderColor(ZetaColors colors) {
    switch (this) {
      case ZdsRoundButtonType.alert:
        return colors.error;
      case ZdsRoundButtonType.base:
      case ZdsRoundButtonType.toggled:
        return colors.borderSubtle;
      case ZdsRoundButtonType.positive:
      case ZdsRoundButtonType.negative:
        return Colors.transparent;
    }
  }

  bool get border => index > 1;
}

/// Component [ZdsRoundButton]
class ZdsRoundButton extends StatefulWidget {
  /// Constructor for [ZdsRoundButton]

  const ZdsRoundButton({
    super.key,
    this.size = ZdsRoundButtonSize.large,
    required this.type,
    required this.icon,
    this.label,
    this.activeIcon,
    this.activeLabel,
    this.onTap,
  });

  /// Size for [ZdsRoundButton]
  final ZdsRoundButtonSize size;

  /// Type of [ZdsRoundButton]
  final ZdsRoundButtonType type;

  /// Default icon
  final IconData icon;

  /// Default label
  final String? label;

  /// Toggled icon
  final IconData? activeIcon;

  /// Toggled label
  final String? activeLabel;

  /// Callback function
  final VoidCallback? onTap;

  @override
  State<ZdsRoundButton> createState() => _CircleIconButton();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ZdsRoundButtonSize>('size', size))
      ..add(EnumProperty<ZdsRoundButtonType>('type', type))
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<IconData?>('activeIcon', activeIcon))
      ..add(StringProperty('activeLabel', activeLabel))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

class _CircleIconButton extends State<ZdsRoundButton> {
  late ZdsRoundButtonType type;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    type = widget.type;
  }

  Future<void> handleClick() async {
    final bool isToggleable = type == ZdsRoundButtonType.toggled || type == ZdsRoundButtonType.base;

    //Change style to show button clicking effect
    if (!isToggleable) {
      setState(() {
        isPressed = true;
      });
    }

    await Future<void>.delayed(const Duration(milliseconds: 100));

    if (isToggleable) {
      setState(() {
        type = (type == ZdsRoundButtonType.toggled) ? ZdsRoundButtonType.base : ZdsRoundButtonType.toggled;
      });
    }

    setState(() {
      isPressed = false;
    });

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    final bool toggled = type == ZdsRoundButtonType.toggled;
    final backgroundColor = type.color(colors);
    final foregroundColor = type == ZdsRoundButtonType.alert ? colors.negative : backgroundColor.onColor;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: ZetaRadius.full,
            border: type.border ? Border.all(color: type.borderColor(colors), width: 2) : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: handleClick,
              splashColor: Colors.transparent,
              borderRadius: ZetaRadius.full,
              child: Icon(
                toggled ? widget.activeIcon : widget.icon,
                size: _iconSize,
                color: foregroundColor,
              ).padding(_iconPadding),
            ),
          ),
        ),
        if (widget.label != null)
          Text(
            toggled ? widget.activeLabel! : widget.label!,
            style: widget.size.textStyle,
          ),
      ].divide(const SizedBox(height: ZetaSpacing.xxs)).toList(),
    );
  }

  double get _iconPadding {
    switch (widget.size) {
      case ZdsRoundButtonSize.xlarge:
        return 25;
      case ZdsRoundButtonSize.large:
        return ZetaSpacing.x5;
      case ZdsRoundButtonSize.medium:
        return 15;
      case ZdsRoundButtonSize.small:
        return 11;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case ZdsRoundButtonSize.xlarge:
        return 55;
      case ZdsRoundButtonSize.large:
        return ZetaSpacing.x10;
      case ZdsRoundButtonSize.medium:
        return ZetaSpacing.x7_5;
      case ZdsRoundButtonSize.small:
        return 22;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ZdsRoundButtonType>('type', type))
      ..add(DiagnosticsProperty<bool>('isPressed', isPressed));
  }
}
