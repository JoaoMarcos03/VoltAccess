class PricingService {
  static const double PER_MINUTE_RATE = 0.30;
  static const double DAILY_CAP = 20.0;
  static const double BASIC_PLAN_PRICE = 30.0;
  static const double PREMIUM_PLAN_PRICE = 50.0;
  static const int BASIC_PLAN_FREE_MINUTES = 120; // 2 hours per week
  static const int PREMIUM_PLAN_FREE_MINUTES = 300; // 5 hours per week

  double calculateRentalCost(int minutes, String membershipType) {
    double cost = minutes * PER_MINUTE_RATE;
    
    // Apply daily cap if applicable
    if (cost > DAILY_CAP) {
      cost = DAILY_CAP;
    }

    // Apply membership discounts
    switch (membershipType) {
      case 'basic':
        if (minutes <= BASIC_PLAN_FREE_MINUTES) {
          cost = 0;
        }
        break;
      case 'premium':
        if (minutes <= PREMIUM_PLAN_FREE_MINUTES) {
          cost = 0;
        }
        break;
      default: // pay-as-you-go
        break;
    }

    return cost;
  }
}
