import 'dart:convert';

import 'package:collection/collection.dart';

class Contact {
  String? id;
  String? fullName;
  String? phoneNumber;
  String? country;

  Contact({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.country,
  });

  @override
  String toString() {
    return 'Data(id: $id, fullName: $fullName, phoneNumber: $phoneNumber, country: $country)';
  }

  factory Contact.fromMap(Map<String, dynamic> data) => Contact(
        id: data['id'] as String?,
        fullName: data['fullName'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
        country: data['country'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'country': country,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Contact].
  factory Contact.fromJson(String data) {
    return Contact.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Contact] to a JSON string.
  String toJson() => json.encode(toMap());

  Contact copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? country,
  }) {
    return Contact(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Contact) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      id.hashCode ^ fullName.hashCode ^ phoneNumber.hashCode ^ country.hashCode;
}
