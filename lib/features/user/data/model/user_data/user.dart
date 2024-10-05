import 'dart:convert';

import 'package:collection/collection.dart';

class User {
  String? mongoId;
  String? userId;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? country;
  String? imageUrl;

  User({
    this.mongoId,
    this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.country,
    this.imageUrl,
  });

  @override
  String toString() {
    return 'Data(mongoId: $mongoId, userId: $userId, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, country: $country, imageUrl: $imageUrl)';
  }

  factory User.fromMap(Map<String, dynamic> data) => User(
        mongoId: data['mongoId'] as String?,
        userId: data['userId'] as String?,
        fullName: data['fullName'] as String?,
        email: data['email'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
        country: data['country'] as String?,
        imageUrl: data['imageUrl'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'mongoId': mongoId,
        'userId': userId,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'country': country,
        'imageUrl': imageUrl,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());

  User copyWith({
    String? mongoId,
    String? userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? country,
    String? imageUrl,
  }) {
    return User(
      mongoId: mongoId ?? this.mongoId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! User) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      mongoId.hashCode ^
      userId.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      country.hashCode ^
      imageUrl.hashCode;
}
