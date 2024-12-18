import 'package:flutter/material.dart';
import 'package:voltaccess/registration_and_login/login_view.dart';

class RegisterView extends StatefulWidget {
  final String title;

  const RegisterView({super.key, required this.title});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _name;
  late final TextEditingController _surname; // Add a new controller for surname
  late final TextEditingController _password;
  late final TextEditingController _phone; // Add a new controller for phone number

  @override
  void initState() {
    _email = TextEditingController();
    _name = TextEditingController(); // Initialize the name controller
    _surname = TextEditingController(); // Initialize the surname controller
    _password = TextEditingController();
    _phone = TextEditingController(); // Initialize the phone controller
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _name.dispose(); // Dispose the name controller
    _surname.dispose(); // Dispose the surname controller
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
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
              controller: _surname, // Use a different controller here
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: "Surname",
                hintText: "Enter your surname",
                border: OutlineInputBorder(),
              ),
            ), 
            const SizedBox(height: 16), 
            TextField(
              controller: _phone, // Use a different controller here
              autocorrect: false,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone number",
                hintText: "Enter your phone number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),  // Odstęp między polami
            // TextField do wprowadzania hasła
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Enter your password",//możesz dodać czy ma być sprawdzane drugie hasło czy nie
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),  // Odstęp między polami
            // Przycisk logowania
            ElevatedButton(
              onPressed: () {
                  // Symulacja nieudanego logowania
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Registered succeesfully!"),
                    ),
                  );
                 
              },
              child: const Text(' Register'),
            ),
            const SizedBox(height: 20),  // Odstęp między przyciskami
            // Przycisk rejestracji
            ElevatedButton(
              onPressed: () {
                // Po kliknięciu przenosi do strony rejestracji
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
    );
  }
}
