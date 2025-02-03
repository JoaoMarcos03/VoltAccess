import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../marcos/services/user_service.dart';
import '../marcos/models/membership.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _birthController;
  late TextEditingController _cardController;
  bool _isEditing = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _birthController = TextEditingController();
    _cardController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final userService = context.read<UserService>();
      final user = userService.currentUser;
      if (user != null) {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text = user.phoneNumber;
        _birthController.text = user.dateOfBirth;
        _cardController.text = user.creditCard;
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Widget _buildUserInfoField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        readOnly: !_isEditing,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: _isEditing ? Colors.white : Colors.grey[200],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              final userService = context.read<UserService>();
              if (_isEditing) {
                // Save changes
                userService.updateUserInfo(
                  name: _nameController.text,
                  email: _emailController.text,
                  phoneNumber: _phoneController.text,
                  dateOfBirth: _birthController.text,
                  creditCard: _cardController.text,
                );
              } else {
                // Start editing - load current values
                final user = userService.currentUser!;
                _nameController.text = user.name;
                _emailController.text = user.email;
                _phoneController.text = user.phoneNumber;
                _birthController.text = user.dateOfBirth;
                _cardController.text = user.creditCard;
              }
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
      body: Consumer<UserService>(
        builder: (context, userService, _) {
          final user = userService.currentUser;
          if (user == null) {
            return const Center(child: Text('No user data available'));
          }

          // When not editing, ensure fields show current data
          if (!_isEditing) {
            _nameController.text = user.name;
            _emailController.text = user.email;
            _phoneController.text = user.phoneNumber;
            _birthController.text = user.dateOfBirth;
            _cardController.text = user.creditCard;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                      ),
                      if (_isEditing)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 18,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, size: 18),
                              color: Colors.white,
                              onPressed: () {
                                // TODO: Implement photo change
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Personal Information Section
                const Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildUserInfoField('Name', _nameController),
                _buildUserInfoField('Email', _emailController),
                _buildUserInfoField('Phone Number', _phoneController),
                _buildUserInfoField('Date of Birth', _birthController),
                _buildUserInfoField('Credit Card', _cardController),

                const SizedBox(height: 24),

                // Membership Section
                const Text(
                  'Membership Plan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<MembershipType>(
                  value: userService.currentMembership,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
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

                if (userService.currentMembership != MembershipType.payAsYouGo) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Remaining free time: ${userService.formatDuration(userService.remainingFreeSeconds)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
