import 'package:flutter/material.dart';
import 'package:voltaccess/registration_and_login/login_view.dart';
import 'package:voltaccess/registration_and_login/license_upload_page.dart'; // Import LicenseUploadPage

class RegisterView extends StatefulWidget {
  final String title;

  const RegisterView({super.key, required this.title});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _name;
  late final TextEditingController _surname;
  late final TextEditingController _password;
  late final TextEditingController _phone;

  @override
  void initState() {
    _email = TextEditingController();
    _name = TextEditingController();
    _surname = TextEditingController();
    _password = TextEditingController();
    _phone = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _surname.dispose();
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView( // Dodajemy scrollowanie
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TextField do wprowadzania emaila
              TextField(
                controller: _email,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _name,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Enter your first name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _surname,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: "Surname",
                  hintText: "Enter your surname",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phone,
                autocorrect: false,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone number",
                  hintText: "Enter your phone number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // After registration, navigate to the LicenseUploadPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LicenseUploadPage()),
                  );
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView(title: 'Login')),
                  );
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
