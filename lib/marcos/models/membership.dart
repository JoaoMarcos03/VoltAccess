enum MembershipType {
  payAsYouGo,
  basic,
  premium,
}

class Membership {
  final MembershipType type;
  final double monthlyFee;
  final int freeMinutesPerWeek;
  final DateTime? startDate;
  final bool hasDeposit;

  const Membership({
    required this.type,
    required this.monthlyFee,
    required this.freeMinutesPerWeek,
    this.startDate,
    this.hasDeposit = false,
  });

  static const Map<MembershipType, Membership> plans = {
    MembershipType.payAsYouGo: Membership(
      type: MembershipType.payAsYouGo,
      monthlyFee: 0,
      freeMinutesPerWeek: 0,
    ),
    MembershipType.basic: Membership(
      type: MembershipType.basic,
      monthlyFee: 30,
      freeMinutesPerWeek: 120, // 2 hours
    ),
    MembershipType.premium: Membership(
      type: MembershipType.premium,
      monthlyFee: 50,
      freeMinutesPerWeek: 300, // 5 hours
    ),
  };
}
