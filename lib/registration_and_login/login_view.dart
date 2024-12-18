import 'package:flutter/material.dart';
import 'package:voltaccess/registration_and_login/register_view.dart';

class LoginView extends StatefulWidget {
  final String title;

  const LoginView({super.key, required this.title});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
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
            const SizedBox(height: 16),  // Odstęp między polami
            // TextField do wprowadzania hasła
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
            const SizedBox(height: 16),  // Odstęp między polami
            // Przycisk logowania
            ElevatedButton(
              onPressed: () {
                final email = _email.text;
                final password = _password.text;

                if (email == "test@example.com" && password == "password123") {
                  // Symulacja udanego logowania
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Login successful!"),
                    ),
                  );
                } else {
                  // Symulacja nieudanego logowania
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid email or password."),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),  // Odstęp między przyciskami
            // Przycisk rejestracji
            ElevatedButton(
              onPressed: () {
                // Po kliknięciu przenosi do strony rejestracji
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterView(title: 'Register')),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
