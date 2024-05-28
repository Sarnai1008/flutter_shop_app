import 'package:json_annotation/json_annotation.dart';
part 'users.g.dart';

@JsonSerializable(createToJson: false)
class UserModel {
  // final Address? address;
  final int? id;
  final String? email;
  final String? username;
  final String? password;
  final Name? name;
  final String? phone;
  int v;
  UserModel(
      {
      // this.address,
      this.id,
      this.email,
      this.username,
      this.password,
      this.name,
      this.phone,
      this.v = 0});
  UserModel fromJSON(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  static List<UserModel> fromList(List<dynamic> data) =>
      data.map((e) => UserModel().fromJSON(e)).toList();

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

// @JsonSerializable(createToJson: false)
// class Address {
//   Geolocation? geolocation;
//   String? city;
//   String? street;
//   int? number;
//   String? zipcode;
//   Address(
//       {this.geolocation, this.city, this.street, this.number, this.zipcode});
//   factory Address.fromJson(Map<String, dynamic> json) {
//     return _$AddressFromJson(json);
//   }
// }

// @JsonSerializable(createToJson: false)
// class Geolocation {
//   double? lat;
//   double? long;
//   Geolocation({this.lat, this.long});
//   factory Geolocation.fromJson(Map<String, dynamic> json) {
//     return _$GeolocationFromJson(json);
//   }
// }

@JsonSerializable(createToJson: false)
class Name {
  String? firstname;
  String? lastname;
  Name({this.firstname, this.lastname});
  factory Name.fromJson(Map<String, dynamic> json) {
    return _$NameFromJson(json);
  }
}
