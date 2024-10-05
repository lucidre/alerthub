import 'package:alerthub/common_libs.dart';

extension DeviceStyles on BuildContext {
  InputDecoration inputDecoration(
      {Widget? prefixIcon,
      Widget? suffixIcon,
      Widget? icon,
      String? labelText,
      String? hintText,
      String? errorText,
      String? helperText,
      String? prefixText,
      String? suffixText,
      String? counterText,
      String? semanticCounterText,
      InputBorder? border,
      InputBorder? focusedBorder,
      BorderSide? borderSide,
      InputBorder? enabledBorder,
      InputBorder? errorBorder,
      TextStyle? hintStyle,
      TextStyle? labelStyle,
      TextStyle? errorStyle,
      TextStyle? helperStyle,
      TextStyle? prefixStyle,
      TextStyle? suffixStyle,
      TextStyle? counterStyle,
      TextStyle? floatingLabelStyle,
      Color? fillColor,
      EdgeInsets? padding}) {
    final borderRadius = BorderRadius.circular(cornersSmall);
    final side = borderSide ??
        const BorderSide(
          width: 1,
          color: neutral400,
        );
    final neutralSide = borderSide ??
        const BorderSide(
          width: 1,
          color: neutral200,
        );
    const errorSide = BorderSide(
      width: 1,
      color: destructive300,
    );
    return InputDecoration(
      errorMaxLines: 5,
      hintStyle: hintStyle ?? satoshi500S14.copyWith(color: neutral400),
      labelStyle: labelStyle ?? satoshi500S14,
      errorStyle: errorStyle ?? satoshi500S14.copyWith(color: Colors.red),
      helperStyle: helperStyle ?? satoshi500S14,
      prefixStyle: prefixStyle ?? satoshi500S14,
      suffixStyle: suffixStyle ?? satoshi500S14,
      counterStyle: counterStyle ?? satoshi500S14,
      floatingLabelStyle: floatingLabelStyle ?? satoshi500S14,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      fillColor: fillColor ?? whiteBrownBg1Color,
      filled: true,
      icon: icon,
      contentPadding: padding ??
          const EdgeInsets.only(
            left: space12,
            right: space12,
          ),
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      helperText: helperText,
      prefixText: prefixText,
      suffixText: suffixText,
      counterText: counterText,
      semanticCounterText: semanticCounterText,
      border: border ??
          OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: neutralSide,
          ),
      focusedBorder: focusedBorder ??
          OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: side,
          ),
      enabledBorder: enabledBorder ??
          OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: neutralSide,
          ),
      errorBorder: errorBorder ??
          OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: errorSide,
          ),
    );
  }
}
