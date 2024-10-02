import 'dart:convert';

import 'package:collection/collection.dart';

import 'user.dart';

class UserData {
  String? message;
  User? data;

  UserData({this.message, this.data});

  @override
  String toString() => 'UserData(message: $message, data: $data)';

  factory UserData.fromMap(Map<String, dynamic> data) => UserData(
        message: data['message'] as String?,
        data: data['data'] == null
            ? null
            : User.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserData].
  factory UserData.fromJson(String data) {
    return UserData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserData] to a JSON string.
  String toJson() => json.encode(toMap());

  UserData copyWith({
    String? message,
    User? data,
  }) {
    return UserData(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}
