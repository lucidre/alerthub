import 'dart:convert';
import 'package:collection/collection.dart';

class Healthenter {
  final String? mongoId;
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

  const Healthenter({
    this.mongoId,
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
  });

  @override
  String toString() {
    return 'Datum(mongoId: $mongoId, fullName: $fullName, userId: $userId, email: $email, description: $description, location: $location, lat: $lat, lng: $lng, images: $images, country: $country, helpline: $helpline, drivers: $drivers )';
  }

  factory Healthenter.fromMap(Map<String, dynamic> data) => Healthenter(
        mongoId: data['mongoId'] as String?,
        fullName: data['fullName'] as String?,
        userId: data['userId'] as String?,
        email: data['email'] as String?,
        description: data['description'] as String?,
        location: data['location'] as String?,
        helpline: data['helpline'] as String?,
        country: data['country'] as String?,
        lat: (data['lat'] as num?)?.toDouble(),
        lng: (data['lng'] as num?)?.toDouble(),
        images: (data['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        drivers: (data['drivers'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'mongoId': mongoId,
        'userId': userId,
        'fullName': fullName,
        'email': email,
        'description': description,
        'location': location,
        'lat': lat,
        'lng': lng,
        'images': images,
        'drivers': drivers,
        'helpline': helpline,
        'country': country,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Healthenter].
  factory Healthenter.fromJson(String data) {
    return Healthenter.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Healthenter] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Healthenter) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      mongoId.hashCode ^
      userId.hashCode ^
      fullName.hashCode ^
      description.hashCode ^
      location.hashCode ^
      email.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      drivers.hashCode ^
      helpline.hashCode ^
      images.hashCode;
}
