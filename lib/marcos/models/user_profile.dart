import '../models/membership.dart';

class UserProfile {
  final String email;
  final String name;
  final String phoneNumber;
  final String creditCard;
  final String dateOfBirth;
  final MembershipType defaultMembership;

  const UserProfile({
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.creditCard,
    required this.dateOfBirth,
    required this.defaultMembership,
  });
}
