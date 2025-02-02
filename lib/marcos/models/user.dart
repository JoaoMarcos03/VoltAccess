import '../models/membership.dart';

class User {
  final String id;
  final String name;
  final String email;
  String? profilePicturePath;
  String? drivingLicensePath;
  Membership membership;
  DateTime membershipStartDate;
  int usedFreeMinutesThisWeek;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicturePath,
    this.drivingLicensePath,
    required this.membership,
    required this.membershipStartDate,
    this.usedFreeMinutesThisWeek = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'profilePicturePath': profilePicturePath,
    'drivingLicensePath': drivingLicensePath,
    'membershipType': membership.type.toString(),
    'membershipStartDate': membershipStartDate.toIso8601String(),
    'usedFreeMinutesThisWeek': usedFreeMinutesThisWeek,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    profilePicturePath: json['profilePicturePath'],
    drivingLicensePath: json['drivingLicensePath'],
    membership: Membership.plans[MembershipType.values.byName(json['membershipType'])]!,
    membershipStartDate: DateTime.parse(json['membershipStartDate']),
    usedFreeMinutesThisWeek: json['usedFreeMinutesThisWeek'],
  );
}
