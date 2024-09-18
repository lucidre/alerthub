import 'dart:convert';

import 'package:collection/collection.dart';

class UserModel {
  String? fullName;
  String? email;
  String? uid;
  String? phoneNumber;
  String? country;
  String? imageUrl;

  UserModel({
    this.fullName,
    this.email,
    this.uid,
    this.phoneNumber,
    this.country,
    this.imageUrl,
  });

  @override
  String toString() {
    return 'UserModel(fullName: $fullName, email: $email, uid: $uid, phoneNumber: $phoneNumber, country: $country, imageUrl: $imageUrl)';
  }

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        fullName: data['fullName'] as String?,
        email: data['email'] as String?,
        uid: data['uid'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
        country: data['country'] as String?,
        imageUrl: data['imageUrl'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'email': email,
        'uid': uid,
        'phoneNumber': phoneNumber,
        'country': country,
        'imageUrl': imageUrl,
      };

  /// `dart:convert`
  /// Parses the string and returns the resulting Json object as [Usermodels].
  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  /// Converts [Usermodels] to a JSON string.
  String toJson() => json.encode(toMap());

  UserModel copyWith({
    String? fullName,
    String? email,
    String? uid,
    String? phoneNumber,
    String? country,
    String? imageUrl,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      fullName.hashCode ^
      email.hashCode ^
      uid.hashCode ^
      phoneNumber.hashCode ^
      country.hashCode ^
      imageUrl.hashCode;
}
