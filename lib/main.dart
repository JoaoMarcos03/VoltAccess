import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voltaccess/registration_and_login/login_view.dart';
import 'marcos/services/location_service.dart';
import 'marcos/services/car_service.dart';
import 'marcos/services/rental_service.dart';
import 'marcos/services/photo_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => CarService()),
        ChangeNotifierProvider(create: (_) => RentalService()),
        ChangeNotifierProvider(create: (_) => PhotoService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginView(title: 'Flutter Demo Home Page'),
    );
  }
}
