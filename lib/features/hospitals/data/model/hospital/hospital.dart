import 'dart:convert';
import 'package:collection/collection.dart';

class Hospital {
  final String? id;
  final String? userId;
  final String? fullName;
  final String? email;
  final String? description;
  final String? location;
  final double? lat;
  final double? lng;
  final List<String>? images;
  final String? country;
  final String? helpline;
  final List<String>? drivers;
  final List<String>? patients;

  const Hospital({
    this.id,
    this.userId,
    this.fullName,
    this.email,
    this.description,
    this.location,
    this.lat,
    this.lng,
    this.images,
    this.country,
    this.helpline,
    this.drivers,
    this.patients,
  });

  factory Hospital.fromMap(Map<String, dynamic> data) => Hospital(
        id: data['mongoId'] as String?,
        userId: data['userId'] as String?,
        helpline: data['helpline'] as String?,
        fullName: data['fullName'] as String?,
        email: data['email'] as String?,
        description: data['description'] as String?,
        location: data['location'] as String?,
        country: data['country'] as String?,
        lat: (data['lat'] as num?)?.toDouble(),
        lng: (data['lng'] as num?)?.toDouble(),
        images: (data['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        drivers: (data['drivers'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        patients: (data['patients'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'helpline': helpline,
        'fullName': fullName,
        'email': email,
        'description': description,
        'location': location,
        'lat': lat,
        'lng': lng,
        'images': images,
        'drivers': drivers,
        'patients': patients,
        'country': country,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Hospital].
  factory Hospital.fromJson(String data) {
    return Hospital.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Hospital] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Hospital) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      helpline.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      description.hashCode ^
      location.hashCode ^
      country.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      drivers.hashCode ^
      patients.hashCode ^
      images.hashCode;
}
