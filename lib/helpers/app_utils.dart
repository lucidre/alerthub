// ignore_for_file: avoid_print

import 'dart:io';

import 'package:alerthub/common_libs.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

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

  Future<DateTime?> pickDate(BuildContext context, DateTime? date) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primary600,
              onPrimary: shadeWhite,
              onSurface: neutral800,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: neutral800, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return selected;
  }

  Future<Position> determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled/turned off.';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied/turned off.';
        }
      } else if (permission == LocationPermission.unableToDetermine) {
        throw 'Unable to determine current location.';
      } else if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions have been permanentely denied.';
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }
      final position = await Geolocator.getCurrentPosition();
      return position;
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<void> requestPositionPermission() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled/turned off.';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<int> isLocationPermissionGranted() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();

      if (serviceEnabled &&
          (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always)) {
        return 0;
      }
      if (permission == LocationPermission.deniedForever) {
        return -1;
      } else {
        return 1;
      }
    } catch (_) {
      return 1;
    }
  }

  Future<void> requestLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled/turned off.';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  int getFileQuality(File file, [int maxSize = 150]) {
    int fileSize = file.lengthSync();
    double fileSizeKB = fileSize / 1024;

    int quality = 100;

    if (fileSizeKB <= maxSize) {
      quality = 100;
    } else {
      quality = ((maxSize / fileSizeKB) * 100).toInt();
      if (quality > 100) {
        quality = 100;
      }
    }

    return quality;
  }
}
