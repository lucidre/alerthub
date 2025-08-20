import 'dart:convert';

import 'package:collection/collection.dart';

import 'contact.dart';

class ContactData {
  String? message;
  List<Contact>? data;

  ContactData({this.message, this.data});

  @override
  String toString() => 'ContactData(message: $message, data: $data)';

  factory ContactData.fromMap(Map<String, dynamic> data) => ContactData(
        message: data['message'] as String?,
        data: data['data'] == null
            ? null
            : (data['data'] as List<dynamic>)
                .map((e) => Contact.fromMap(e as Map<String, dynamic>))
                .toList(),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ContactData].
  factory ContactData.fromJson(String data) {
    return ContactData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ContactData] to a JSON string.
  String toJson() => json.encode(toMap());

  ContactData copyWith({
    String? message,
    List<Contact>? data,
  }) {
    return ContactData(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ContactData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}
