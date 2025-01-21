import 'dart:math';
import '../models/membership.dart';

class PricingService {
  // €0.30 per minute = €0.005 per second (0.30/60)
  static const double PER_MINUTE_RATE = 0.30;
  static const double PER_SECOND_RATE = PER_MINUTE_RATE / 60; // Equals 0.005 euros per second
  static const double DAILY_CAP = 20.0;
  static const double DEPOSIT_AMOUNT = 100.0;

  double calculateRentalCost(int seconds, MembershipType membershipType, DateTime startTime) {
    // First, check if seconds are covered by membership free minutes
    final freeSecondsRemaining = _calculateRemainingFreeSeconds(membershipType, startTime);
    final paidSeconds = seconds > freeSecondsRemaining ? 
                       seconds - freeSecondsRemaining : 0;

    // Calculate base cost using seconds (€0.30 per minute = €0.005 per second)
    double cost = (paidSeconds * PER_SECOND_RATE);

    // Apply daily cap if applicable
    return min(cost, DAILY_CAP);
  }

  int _calculateRemainingFreeSeconds(MembershipType membershipType, DateTime startTime) {
    if (membershipType == MembershipType.payAsYouGo) {
      return 0;
    }

    final membership = Membership.plans[membershipType]!;
    final weekStart = startTime.subtract(Duration(days: startTime.weekday - 1));
    // Convert free minutes to seconds
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
