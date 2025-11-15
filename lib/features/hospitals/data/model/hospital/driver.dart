import 'dart:convert';

import 'package:collection/collection.dart';

class Driver {
  final String? id;
  final String? fullName;
  final String? email;
  final String? password;
  final String? location;
  final double? lat;
  final double? lng;
  final String? images;
  final String? contact;
  final String? healthCenterId;
  

  const Driver({
    this.id,
    this.fullName,
    this.email,
    this.password,
    this.location,
    this.lat,
    this.lng,
    this.images,
    this.contact,
    this.healthCenterId,
  });

  factory Driver.fromMap(Map<String, dynamic> data) => Driver(
        id: data['id'] as String?,
        fullName: data['fullName'] as String?,
        email: data['email'] as String?,
        password: data['password'] as String?,
        contact: data['contact'] as String?,
        location: data['location'] as String?,
        healthCenterId: data['healthCenterId'] as String?,
        images: data['images'] as String?,
        lat: (data['lat'] as num?)?.toDouble(),
        lng: (data['lng'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullName': fullName,
        'password': password,
        'contact': contact,
        'email': email,
        'healthCenterId': password,
        'location': location,
        'lat': lat,
        'lng': lng,
        'images': images,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Driver].
  factory Driver.fromJson(String data) {
    return Driver.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Driver] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Driver) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      fullName.hashCode ^
      password.hashCode ^
      contact.hashCode ^
      email.hashCode ^
      password.hashCode ^
      location.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      images.hashCode;
}
