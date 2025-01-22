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
      backgroundColor: Colors.white, // Białe tło
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo na środku (jak w LoginView)
              Center(
                child: Image.asset(
                  'lib/logo.webp',
                  height: 100,
                ),
              ),
              const SizedBox(height: 40),

              // Pola rejestracji
              _buildTextField(_email, "Email", "Enter your email"),
              const SizedBox(height: 15),

              _buildTextField(_name, "Name", "Enter your first name"),
              const SizedBox(height: 15),

              _buildTextField(_surname, "Surname", "Enter your surname"),
              const SizedBox(height: 15),

              _buildTextField(_phone, "Phone number", "Enter your phone number", isPhone: true),
              const SizedBox(height: 15),

              _buildTextField(_password, "Password", "Enter your password", isPassword: true),
              const SizedBox(height: 30),

              // Czarny przycisk "Register"
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LicenseUploadPage()),
                  );
                },
                child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              const SizedBox(height: 20),

              // Szary przycisk "Login"
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView(title: 'Login')),
                  );
                },
                child: const Text('Login', style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {bool isPassword = false, bool isPhone = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      autocorrect: false,
      enableSuggestions: !isPassword,
      keyboardType: isPhone ? TextInputType.phone : (isPassword ? TextInputType.text : TextInputType.emailAddress),
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
