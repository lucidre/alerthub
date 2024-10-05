import 'dart:convert';

import 'package:collection/collection.dart';

import 'data.dart';

class Notifications {
  String? message;
  Data? data;

  Notifications({this.message, this.data});

  @override
  String toString() => 'Notifications(message: $message, data: $data)';

  factory Notifications.fromMap(Map<String, dynamic> data) => Notifications(
        message: data['message'] as String?,
        data: data['data'] == null
            ? null
            : Data.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Notifications].
  factory Notifications.fromJson(String data) {
    return Notifications.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Notifications] to a JSON string.
  String toJson() => json.encode(toMap());

  Notifications copyWith({
    String? message,
    Data? data,
  }) {
    return Notifications(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Notifications) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}
