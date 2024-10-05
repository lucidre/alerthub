// ignore_for_file: avoid_print

import 'package:url_launcher/url_launcher_string.dart';

import 'package:alerthub/common_libs.dart';
import 'package:intl/intl.dart';

AppUtils $appUtil = AppUtils();

class AppUtils {
  bool isEmailValid(String? email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@+[a-zA-Z0-9]+\.[a-zA-Z]")
      .hasMatch(email ?? "");
  bool isNameValid(String? name) =>
      RegExp(r'^[a-zA-Z\-]{2,70}$').hasMatch(name ?? "");
  bool isUsernameValid(String? name) =>
      RegExp(r'^[a-zA-Z0-9\-\_]{2,70}$').hasMatch(name ?? "");
  bool isPhoneValid(String? phone) =>
      RegExp(r'^[+]{0,1}[0-9]{6,19}$').hasMatch(phone ?? "");
  bool isZipCodeValid(String? code) =>
      RegExp(r'^[a-zA-Z0-9\- ]{3,15}$').hasMatch(code ?? "");

  bool isTagValid(String? tag) =>
      RegExp(r'^[a-zA-Z0-9\-_()#.,\/ ]{2,255}$').hasMatch(tag ?? "");
  bool isAddressValid(String? address) =>
      RegExp(r'^[a-zA-Z0-9\-_()#.,\/ ]{2,100}$').hasMatch(address ?? "");

  String formattedDate(int timestamp) {
    try {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (exception) {
      return "";
    }
  }

  String formattedDateFull(int timestamp) {
    try {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat('MMMM dd, yyyy').format(dateTime);
    } catch (exception) {
      return "";
    }
  }

  String detailedFormattedDate(int timestamp) {
    try {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (today.day == dateTime.day &&
          today.month == dateTime.month &&
          today.year == dateTime.year) {
        return DateFormat('h:mm a').format(dateTime);
      } else {
        return DateFormat('MMM dd, yyyy').format(dateTime);
      }
    } catch (exception) {
      return "";
    }
  }

  String slashedDateFormat(DateTime dateTime) {
    try {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (exception) {
      return "";
    }
  }

  String hyphenedDateFormat(DateTime dateTime) {
    try {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (exception) {
      return "";
    }
  }

  onPhoneClicked(String phone) async {
    try {
      await launchUrlString("tel://$phone",
          mode: LaunchMode.externalApplication);
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  onEmailClicked(String email) async {
    try {
      await launchUrlString("mailto:$email",
          mode: LaunchMode.externalApplication);
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  onLinkClicked(String url) async {
    try {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
