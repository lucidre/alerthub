import 'dart:convert';

import 'package:collection/collection.dart';

import 'driver.dart';

class DriverData {
  String? message;
  Driver? data;

  DriverData({this.message, this.data});

  @override
  String toString() => 'DriverData(message: $message, data: $data)';

  factory DriverData.fromMap(Map<String, dynamic> data) => DriverData(
        message: data['message'] as String?,
        data: data['data'] == null
            ? null
            : Driver.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DriverData].
  factory DriverData.fromJson(String data) {
    return DriverData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DriverData] to a JSON string.
  String toJson() => json.encode(toMap());

  DriverData copyWith({
    String? message,
    Driver? data,
  }) {
    return DriverData(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! DriverData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}
