import 'dart:convert';

import 'package:collection/collection.dart';

import 'hospital.dart';

class HospitalData {
  String? message;
  Hospital? data;

  HospitalData({this.message, this.data});

  @override
  String toString() => 'HospitalData(message: $message, data: $data)';

  factory HospitalData.fromMap(Map<String, dynamic> data) => HospitalData(
        message: data['message'] as String?,
        data: data['data'] == null
            ? null
            : Hospital.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [HospitalData].
  factory HospitalData.fromJson(String data) {
    return HospitalData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [HospitalData] to a JSON string.
  String toJson() => json.encode(toMap());

  HospitalData copyWith({
    String? message,
    Hospital? data,
  }) {
    return HospitalData(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! HospitalData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}
