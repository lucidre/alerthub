import 'dart:convert';
import 'package:collection/collection.dart';

 
class Hospital {
  final String? id;
  final String? creatorId;
  final String? name;
  final String? description;
  final String? location;
  final double? lat;
  final double? lng;
  final List<String>? images;
  final String? country;
  final String? helpline;
  final List<String>? drivers;

  const Hospital({
    this.id,
    this.name,
    this.creatorId,
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
    return 'Datum(id: $id, name: $name, creatorId: $creatorId, description: $description, location: $location, lat: $lat, lng: $lng, images: $images, country: $country, helpline: $helpline, drivers: $drivers )';
  }

  factory Hospital.fromMap(Map<String, dynamic> data) => Hospital(
        id: data['id'] as String?,
        name: data['name'] as String?,
        creatorId: data['creatorId'] as String?,
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
        'id': id,
        'name': name,
        'creatorId': creatorId,
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
      name.hashCode ^
      description.hashCode ^
      location.hashCode ^
      creatorId.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      drivers.hashCode ^
      helpline.hashCode ^
      images.hashCode;
}
