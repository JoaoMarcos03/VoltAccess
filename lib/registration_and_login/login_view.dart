import 'package:flutter/material.dart';
import 'package:voltaccess/registration_and_login/register_view.dart';
import 'package:voltaccess/registration_and_login/home_page.dart';

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

                  if (email == "test@example.com" && password == "password123") {
                    // Symulacja udanego logowania: Przejście do HomePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else {
                    // Symulacja nieudanego logowania
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Invalid email or password.",
                          style: TextStyle(color: Colors.white), // Biały tekst
                        ),
                        backgroundColor: Colors.grey[850], // Ciemnoszare tło
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
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
