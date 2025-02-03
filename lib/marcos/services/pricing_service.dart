import 'dart:math';
import '../models/membership.dart';

class PricingService {
  static const double PER_MINUTE_RATE = 0.30;
  static const double PER_SECOND_RATE = PER_MINUTE_RATE / 60;
  static const double DAILY_CAP = 20.0;
  static const double DEPOSIT_AMOUNT = 100.0;

  double calculateRentalCost(int totalSeconds, MembershipType membershipType, DateTime startTime, int remainingFreeSeconds) {
    if (membershipType == MembershipType.payAsYouGo) {
      return min((totalSeconds * PER_SECOND_RATE), DAILY_CAP);
    }

    // If we have enough free time, cost is 0
    if (remainingFreeSeconds >= totalSeconds) {
      return 0.0;
    }

    // Calculate cost only for seconds after free time is used
    int paidSeconds = totalSeconds - remainingFreeSeconds;
    return min((paidSeconds * PER_SECOND_RATE), DAILY_CAP);
  }

  int _calculateRemainingFreeSeconds(MembershipType membershipType, DateTime startTime) {
    if (membershipType == MembershipType.payAsYouGo) {
      return 0;
    }

    final membership = Membership.plans[membershipType]!;
    final weekStart = startTime.subtract(Duration(days: startTime.weekday - 1));
    return membership.freeMinutesPerWeek * 60;
  }

  double calculateHourlyRate(int hours) {
    return min(hours * PER_MINUTE_RATE * 60, DAILY_CAP);
  }

  double getDepositAmount(bool isFirstTimeUser) {
    return isFirstTimeUser ? DEPOSIT_AMOUNT : 0;
  }

  double getMembershipFee(MembershipType type) {
    return Membership.plans[type]?.monthlyFee ?? 0;
  }
}
