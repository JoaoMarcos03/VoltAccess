import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../services/location_service.dart';
import '../services/car_service.dart';
import 'car_rental_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<LocationService>().getCurrentLocation();
      context.read<CarService>().initializeMockCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Cars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CarService>().initializeMockCars();
            },
          ),
        ],
      ),
      body: Consumer2<LocationService, CarService>(
        builder: (context, locationService, carService, child) {
          if (locationService.currentLocation == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final userLocation = LatLng(
            locationService.currentLocation?.latitude ?? 0,
            locationService.currentLocation?.longitude ?? 0,
          );

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: userLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) => _controller = controller,
            myLocationEnabled: true,
            markers: carService.carMarkers.map((marker) {
              return marker.copyWith(
                onTapParam: () {
                  if (carService.isCarNearby(userLocation, marker.position)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarRentalScreen(
                          carId: marker.markerId.value,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Get closer to the car to start rental'),
                      ),
                    );
                  }
                },
              );
            }).toSet(),
          );
        },
      ),
    );
  }
}
