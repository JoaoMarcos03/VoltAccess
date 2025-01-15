import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Zmienna do przechowywania danych użytkownika
  String firstName = 'John';
  String lastName = 'Doe';
  String dateOfBirth = '01/01/1990';
  String email = 'johndoe@example.com';
  String phoneNumber = '+1 123 456 7890';
  String creditCard = '1234 5678 9012 3456';

  // Kontrolery do formularza
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _creditCardController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Ustawiamy początkowe wartości w kontrolerach
    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
    _dateOfBirthController.text = dateOfBirth;
    _emailController.text = email;
    _phoneNumberController.text = phoneNumber;
    _creditCardController.text = creditCard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Dodanie przewijania
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInfoRow('First Name', _firstNameController),
              _buildInfoRow('Last Name', _lastNameController),
              _buildInfoRow('Date of Birth', _dateOfBirthController),
              _buildInfoRow('Email', _emailController),
              _buildInfoRow('Phone Number', _phoneNumberController),
              _buildInfoRow('Credit Card', _creditCardController),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Wyświetl formularz do edytowania danych
                    _showEditDialog(context);
                  },
                  child: const Text('Edit Information'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Funkcja do wyświetlania formularza edycji danych
  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User Information'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(  // Dodanie przewijania w oknie dialogowym
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextFormField('First Name', _firstNameController),
                  _buildTextFormField('Last Name', _lastNameController),
                  _buildTextFormField('Date of Birth', _dateOfBirthController),
                  _buildTextFormField('Email', _emailController),
                  _buildTextFormField('Phone Number', _phoneNumberController),
                  _buildTextFormField('Credit Card', _creditCardController),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Zamknij dialog bez zapisywania
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Zapisz zmienione dane
                if (_formKey.currentState?.validate() ?? false) {
                  setState(() {
                    firstName = _firstNameController.text;
                    lastName = _lastNameController.text;
                    dateOfBirth = _dateOfBirthController.text;
                    email = _emailController.text;
                    phoneNumber = _phoneNumberController.text;
                    creditCard = _creditCardController.text;
                  });

                  // Zamknij dialog po zapisaniu zmian
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Information updated successfully!')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Funkcja do budowy formularza tekstowego
  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  // Funkcja do wyświetlania danych użytkownika
  Widget _buildInfoRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            controller.text,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
