import 'dart:convert';

import 'package:collection/collection.dart';

import 'driver.dart';

class Drivers {
  final String? message;
  final List<Driver>? data;

  const Drivers({this.message, this.data});

  @override
  String toString() => 'Event(message: $message, data: $data)';

  factory Drivers.fromMap(Map<String, dynamic> data) => Drivers(
        message: data['message'] as String?,
        data: (data['data'] as List<dynamic>?)
            ?.map((e) => Driver.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Drivers].
  factory Drivers.fromJson(String data) {
    return Drivers.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Drivers] to a JSON string.
  String toJson() => json.encode(toMap());

  Drivers copyWith({
    String? message,
    List<Driver>? data,
  }) {
    return Drivers(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Drivers) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}
