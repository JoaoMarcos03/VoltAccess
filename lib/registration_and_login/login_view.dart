import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voltaccess/registration_and_login/register_view.dart';
import 'package:voltaccess/registration_and_login/home_page.dart';
import '../marcos/services/user_service.dart';
import '../marcos/models/membership.dart';

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

  void _handleLogin(BuildContext context, String email, String password) {
    if (UserService.testUsers.containsKey(email) &&
        UserService.testUsers[email]!['password'] == password) {
      
      final userService = Provider.of<UserService>(context, listen: false);
      userService.loginUser(email);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Tło białe
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'lib/logo.webp',
                  height: 100,
                ),
              ),
              const SizedBox(height: 40),

              // Pole Email
              _buildTextField(_email, "Email", "Enter your email"),
              const SizedBox(height: 16),

              // Pole Password
              _buildTextField(_password, "Password", "Enter your password", isPassword: true),
              const SizedBox(height: 30),

              // Przycisk Login
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final email = _email.text;
                  final password = _password.text;

                  _handleLogin(context, email, password);
                },
                child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              const SizedBox(height: 20),

              // Przycisk Register
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300], // Szare tło
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Po kliknięciu przenosi do strony rejestracji
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterView(title: 'Register')),
                  );
                },
                child: const Text('Register', style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      autocorrect: false,
      enableSuggestions: !isPassword,
      keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      cursorColor: Colors.black, // Czarny kursor
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200], // Jasnoszare tło pola tekstowego
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2), // Czarna ramka
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2), // Czarna ramka gdy nie kliknięte
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2), // Czarna ramka gdy kliknięte
        ),
      ),
      style: const TextStyle(color: Colors.black), // Czarny tekst w polu
    );
  }
}
