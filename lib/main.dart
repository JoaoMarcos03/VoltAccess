import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voltaccess/registration_and_login/login_view.dart';
import 'marcos/services/location_service.dart';
import 'marcos/services/car_service.dart';
import 'marcos/services/rental_service.dart';
import 'marcos/services/photo_service.dart';
import 'marcos/services/user_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => CarService()),
        ChangeNotifierProvider(create: (_) => PhotoService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (context) => RentalService(
          context.read<CarService>(),
          context.read<PhotoService>(),
          context.read<UserService>(),
        )),
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
      title: 'VoltAccess',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
        useMaterial3: true,
      ),
      home: const LoginView(title: 'VoltAccess'),
    );
  }
}
