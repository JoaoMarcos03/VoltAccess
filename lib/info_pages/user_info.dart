import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // User Information
  String firstName = 'John';
  String lastName = 'Doe';
  String dateOfBirth = '01/01/1990';
  String email = 'test@example.com';
  String phoneNumber = '+1 123 456 7890';
  String creditCard = '1234 5678 9012 3456';
  String membership = 'Pay-as-you-go';

  final List<String> membershipPlans = [
    'Pay-as-you-go',
    'Basic Plan (€30/month-2 hrs free/week)',
    'Premium Plan (€50/month-5 hrs free/week)'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? firstName;
      lastName = prefs.getString('lastName') ?? lastName;
      dateOfBirth = prefs.getString('dateOfBirth') ?? dateOfBirth;
      email = prefs.getString('email') ?? email;
      phoneNumber = prefs.getString('phoneNumber') ?? phoneNumber;
      creditCard = prefs.getString('creditCard') ?? creditCard;
      membership = prefs.getString('membership') ?? membership;
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('dateOfBirth', dateOfBirth);
    await prefs.setString('email', email);
    await prefs.setString('phoneNumber', phoneNumber);
    await prefs.setString('creditCard', creditCard);
    await prefs.setString('membership', membership);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white), // Ensures back arrow is white
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'lib/logo.webp',
                height: 80,
              ),
            ),
            const SizedBox(height: 30),
            _buildInfoRow('First Name', firstName, (val) => setState(() { firstName = val; _saveUserData(); })),
            _buildInfoRow('Last Name', lastName, (val) => setState(() { lastName = val; _saveUserData(); })),
            _buildInfoRow('Date of Birth', dateOfBirth, (val) => setState(() { dateOfBirth = val; _saveUserData(); })),
            _buildInfoRow('Email', email, (val) => setState(() { email = val; _saveUserData(); })),
            _buildInfoRow('Phone Number', phoneNumber, (val) => setState(() { phoneNumber = val; _saveUserData(); })),
            _buildInfoRow('Credit Card', creditCard, (val) => setState(() { creditCard = val; _saveUserData(); })),
            _buildMembershipSelection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Function(String) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () => _editField(context, label, value, onSave),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Membership Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField<String>(
              value: membership,
              items: membershipPlans.map((plan) => DropdownMenuItem(value: plan, child: Text(plan, style: const TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false)) ).toList(),
              onChanged: (value) {
                setState(() {
                  membership = value!;
                  _saveUserData();
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              dropdownColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _editField(BuildContext context, String label, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black, width: 2),
          ),
          title: Text(label, style: const TextStyle(color: Colors.black)),
          content: TextField(
            controller: controller,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.black))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
