// ignore_for_file: must_be_immutable, unnecessary_null_comparison, prefer_interpolation_to_compose_strings

import 'package:alerthub/common_libs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? helperText;
  final TextStyle? helperStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? icon;
  final String? errorText;
  final String? prefixText;
  final String? suffixText;
  final String? counterText;
  final String? semanticCounterText;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final BorderSide? borderSide;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final TextStyle? prefixStyle;
  final TextStyle? suffixStyle;
  final TextStyle? counterStyle;
  final TextStyle? floatingLabelStyle;
  final EdgeInsets? padding;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function(String?, String?)? locationUpdate;
  final bool ignoreMaxLine;

  const AddressTextField({
    super.key,
    this.labelText,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.helperText,
    this.helperStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.icon,
    this.padding,
    this.errorText,
    this.prefixText,
    this.suffixText,
    this.counterText,
    this.semanticCounterText,
    this.border,
    this.ignoreMaxLine = false,
    this.focusedBorder,
    this.borderSide,
    this.enabledBorder,
    this.errorBorder,
    this.labelStyle,
    this.errorStyle,
    this.prefixStyle,
    this.suffixStyle,
    this.counterStyle,
    this.floatingLabelStyle,
    this.textInputAction,
    this.focusNode,
    this.locationUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      textStyle: satoshi500S14,
      googleAPIKey: dotenv.env['mapKey'] ?? '',
      focusNode: focusNode,
      inputDecoration: textFieldDecoration,
      debounceTime: 800,
      isLatLngRequired: false,
      itemClick: (prediction) => onItemClicked(prediction),
      itemBuilder: (context, index, prediction) {
        return buildItem(prediction)
            .fadeInAndMoveFromBottom(delay: Duration.zero);
      },
      seperatedBuilder:
          context.divider.fadeInAndMoveFromBottom(delay: Duration.zero),
      isCrossBtnShown: false,
      containerHorizontalPadding: 0,
      boxDecoration: const BoxDecoration(),
    );
  }

  InputDecoration get textFieldDecoration {
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
      fillColor: whiteBrownBg1Color,
      filled: true,
      icon: icon,
      contentPadding:
          padding ?? const EdgeInsets.only(left: space12, right: space12),
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

  onItemClicked(Prediction prediction) {
    final description = prediction.description ?? '';
    if (description.isNotEmpty) {
      controller.text = description;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: description.length),
      );
    }

    if (locationUpdate != null) {
      final lat = prediction.lat;
      final long = prediction.lng;

      locationUpdate!.call(lat, long);
    }
  }

  Padding buildItem(Prediction prediction) {
    return Padding(
      padding: const EdgeInsets.all(space16),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.location_solid,
            size: 18,
          ),
          horizontalSpacer8,
          Expanded(
            child: Text(
              prediction.description ?? "",
              style: satoshi500S16.copyWith(fontWeight: FontWeight.w600),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
