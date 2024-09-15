// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:io';
import 'package:alerthub/common_libs.dart';

/// Shared methods across button types
Widget _buildIcon(BuildContext context, IconData icon,
        {required bool isOutlined,
        required bool isSecondary,
        required double? size}) =>
    Icon(icon,
        color: (isOutlined) ? blackShade1Color : whiteColor, size: size ?? 18);

/// The core button that drives all other buttons.
class AppBtn extends StatelessWidget {
  // interaction:
  final VoidCallback onPressed;
  late final String semanticLabel;
  final bool enableFeedback;

  // content:
  late final Widget? child;
  late final WidgetBuilder? _builder;

  // layout:
  final EdgeInsets? padding;
  final bool expand;
  final bool circular;
  final Size? minimumSize;
  final bool isElevated;

  // style:
  final bool? isSecondary;

  final bool isOutlined;
  final bool isLoading;
  final BorderSide? border;
  final Color? bgColor;
  final Color? borderColor;
  final Color? textColor;
  final bool pressEffect;

  AppBtn({
    super.key,
    required this.onPressed,
    required this.semanticLabel,
    this.enableFeedback = true,
    this.isOutlined = false,
    this.isElevated = false,
    this.isLoading = false,
    this.pressEffect = true,
    this.child,
    this.padding,
    this.expand = false,
    required this.isSecondary,
    this.circular = false,
    this.minimumSize,
    this.bgColor,
    this.borderColor,
    this.textColor,
    this.border,
  }) : _builder = null;

  AppBtn.basic({
    super.key,
    required this.onPressed,
    this.isElevated = false,
    this.semanticLabel = '',
    this.enableFeedback = true,
    this.isOutlined = false,
    this.pressEffect = true,
    this.padding = EdgeInsets.zero,
    this.isSecondary,
    this.circular = false,
    this.minimumSize,
    required this.child,
  })  : expand = false,
        bgColor = Colors.transparent,
        borderColor = neutral300,
        textColor = neutral800,
        border = null,
        isLoading = false,
        _builder = null;

  AppBtn.from({
    super.key,
    required this.onPressed,
    this.enableFeedback = true,
    this.pressEffect = true,
    this.padding = const EdgeInsets.only(
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding / 2,
        right: kDefaultPadding / 2,
        left: kDefaultPadding / 2),
    this.expand = true,
    this.isOutlined = false,
    this.isSecondary,
    this.minimumSize,
    this.bgColor,
    this.borderColor,
    this.textColor,
    this.border,
    this.isElevated = false,
    this.isLoading = false,
    String? semanticLabel,
    required String? text,
    IconData? icon,
    double? iconSize,
  })  : child = null,
        circular = false {
    if (semanticLabel == null && text == null) {
      throw ('AppBtn.from must include either text or semanticLabel');
    }

    this.semanticLabel = semanticLabel ?? text ?? '';

    _builder = (context) {
      if (text == null && icon == null) {
        return const SizedBox.shrink();
      }
      final txt = text == null
          ? null
          : Text(text,
              style: satoshi500S14.copyWith(
                  color: textColor ??
                      (isOutlined ? blackShade1Color : shadeWhite)),
              textHeightBehavior:
                  const TextHeightBehavior(applyHeightToFirstAscent: false));
      Widget? icn = icon == null
          ? null
          : _buildIcon(
              context,
              icon,
              isSecondary: isSecondary ?? context.$isDarkMode,
              size: iconSize,
              isOutlined: isOutlined,
            );
      if (isLoading) {
        return SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator.adaptive(
            valueColor: Platform.isIOS
                ? null
                : AlwaysStoppedAnimation<Color>(
                    isOutlined ? blackShade1Color : whiteColor,
                  ),
            backgroundColor: Platform.isIOS
                ? (isOutlined ? blackShade1Color : whiteColor)
                : null,
          ),
        );
      } else if (txt != null && icn != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [txt, horizontalSpacer8, icn],
        );
      } else {
        return (txt ?? icn)!;
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    Color defaultColor = borderColor ?? neutral200;
    final secondary = isSecondary ?? context.$isDarkMode;
    Color textColor =
        (isOutlined ? !secondary : secondary) ? blackShade1Color : whiteColor;
    BorderSide side = border ??
        (isOutlined
            ? BorderSide(width: 1.0, color: defaultColor)
            : BorderSide.none);

    Widget content =
        _builder?.call(context) ?? child ?? const SizedBox.shrink();
    if (expand) content = Center(child: content);

    OutlinedBorder shape = circular
        ? CircleBorder(side: side)
        : RoundedRectangleBorder(
            side: side,
            borderRadius: BorderRadius.circular(cornersSmall),
          );

    ButtonStyle style = ButtonStyle(
      elevation: ButtonStyleButton.allOrNull<double>(isOutlined
          ? 0.0
          : isElevated
              ? 4.0
              : 0.0),
      minimumSize: ButtonStyleButton.allOrNull<Size>(minimumSize ?? Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashFactory: NoSplash.splashFactory,
      backgroundColor: ButtonStyleButton.allOrNull<Color>(
          bgColor ?? (isOutlined ? shadeWhite : blackShade1Color)),
      overlayColor: ButtonStyleButton.allOrNull<Color>(
          Colors.transparent), // disable default press effect
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(
          padding ?? const EdgeInsets.all(space4)),
      enableFeedback: enableFeedback,
    );

    Widget button = TextButton(
      onPressed: () => onPressed(),
      style: style,
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(color: textColor),
        child: content,
      ),
    );

    // add press effect:
    if (pressEffect) button = _ButtonPressEffect(button);

    // add semantics?
    if (semanticLabel.isEmpty) return button;
    return Semantics(
      label: semanticLabel,
      button: true,
      container: true,
      child: ExcludeSemantics(
        child: button.fadeIn(),
      ),
    );
  }
}

/// //////////////////////////////////////////////////
/// _ButtonDecorator
/// Add a transparency-based press effect to buttons.
/// //////////////////////////////////////////////////
class _ButtonPressEffect extends StatefulWidget {
  const _ButtonPressEffect(this.child);
  final Widget child;

  @override
  State<_ButtonPressEffect> createState() => _ButtonPressEffectState();
}

class _ButtonPressEffectState extends State<_ButtonPressEffect> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      excludeFromSemantics: true,
      onTapDown: (_) => setState(() => _isDown = true),
      onTapUp: (_) => setState(
          () => _isDown = false), // not called, TextButton swallows this.
      onTapCancel: () => setState(() => _isDown = false),
      behavior: HitTestBehavior.translucent,
      child: Opacity(
        opacity: _isDown ? 0.7 : 1,
        child: ExcludeSemantics(child: widget.child),
      ),
    );
  }
}
