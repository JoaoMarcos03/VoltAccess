import 'package:flutter/material.dart';

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
  String email = 'johndoe@example.com';
  String phoneNumber = '+1 123 456 7890';
  String creditCard = '1234 5678 9012 3456';
  String membership = 'Pay-as-you-go';

  final List<String> membershipPlans = [
    'Pay-as-you-go',
    'Basic Plan (€30/month-2 hrs free/week)',
    'Premium Plan (€50/month-5 hrs free/week)'
  ];

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
            _buildInfoRow('First Name', firstName, () => _editField(context, 'First Name', firstName, (val) => setState(() => firstName = val))),
            _buildInfoRow('Last Name', lastName, () => _editField(context, 'Last Name', lastName, (val) => setState(() => lastName = val))),
            _buildInfoRow('Date of Birth', dateOfBirth, () => _editField(context, 'Date of Birth', dateOfBirth, (val) => setState(() => dateOfBirth = val))),
            _buildInfoRow('Email', email, () => _editField(context, 'Email', email, (val) => setState(() => email = val))),
            _buildInfoRow('Phone Number', phoneNumber, () => _editField(context, 'Phone Number', phoneNumber, (val) => setState(() => phoneNumber = val))),
            _buildInfoRow('Credit Card', creditCard, () => _editField(context, 'Credit Card', creditCard, (val) => setState(() => creditCard = val))),
            _buildMembershipSelection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, VoidCallback onEdit) {
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
                  onPressed: onEdit,
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
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
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
