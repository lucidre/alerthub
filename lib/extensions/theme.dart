import 'package:alerthub/common_libs.dart';

extension DeviceTheme on BuildContext {
  Brightness get _platformBrightness => MediaQuery.of(this).platformBrightness;
  bool get $isLightMode => _platformBrightness == Brightness.light;
  bool get $isDarkMode => _platformBrightness == Brightness.dark;

  Color get textColor => blackShade1Color;
  Color get backgroundColor => whiteBrownColor;

  Divider get divider => Divider(
        color: textColor.withOpacity(.1),
        height: 1,
      );

  ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: kPrimaryColor),
        canvasColor: backgroundColor,
        dialogBackgroundColor: backgroundColor,
        cardColor: shadeWhite,
        iconTheme:
            ThemeData.light().iconTheme.copyWith(color: textColor, size: 24),
      );
}
