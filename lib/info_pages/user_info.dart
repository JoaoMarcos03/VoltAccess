import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../marcos/services/user_service.dart';
import '../marcos/models/membership.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Consumer<UserService>(
        builder: (context, userService, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Membership Plan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButton<MembershipType>(
                  value: userService.currentMembership,
                  isExpanded: true,
                  items: MembershipType.values.map((type) {
                    String label;
                    switch (type) {
                      case MembershipType.payAsYouGo:
                        label = 'Pay as you go';
                        break;
                      case MembershipType.basic:
                        label = 'Basic (€30/month, 2h free/week)';
                        break;
                      case MembershipType.premium:
                        label = 'Premium (€50/month, 5h free/week)';
                        break;
                    }
                    return DropdownMenuItem(
                      value: type,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (newType) {
                    if (newType != null) {
                      userService.updateMembership(newType);
                    }
                  },
                ),
                const SizedBox(height: 20),
                if (userService.currentMembership != MembershipType.payAsYouGo)
                  Text(
                    'Remaining free time: ${userService.formatDuration(userService.remainingFreeMinutes)}',
                    style: const TextStyle(fontSize: 16),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
