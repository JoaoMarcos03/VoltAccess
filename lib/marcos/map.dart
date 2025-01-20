import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'services/location_service.dart';
import 'services/car_service.dart';
import 'services/rental_service.dart';
import 'screens/car_rental_screen.dart';
import 'widgets/rental_overlay.dart';
import 'widgets/photo_check_widget.dart';

/// Main screen showing available cars on map and handling rental interactions
class RentingCarsPage extends StatefulWidget {
  const RentingCarsPage({super.key});

  @override
  State<RentingCarsPage> createState() => _RentingCarsPageState();
}

class _RentingCarsPageState extends State<RentingCarsPage> {
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  /// Initialize location and car services
  void _initializeServices() {
    Future.delayed(Duration.zero, () {
      context.read<LocationService>().getCurrentLocation();
      context.read<CarService>().initializeMockCars();
    });
  }

  /// Shows rental control dialog for selected car
  void _showRentalControls(BuildContext context, Map<String, dynamic> car, bool isNearby) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _buildRentalDialog(car, isNearby),
    );
  }

  /// Builds the rental control dialog content
  Widget _buildRentalDialog(Map<String, dynamic> car, bool isNearby) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<RentalService>(
        builder: (context, rentalService, _) {
          final isCurrentCar = rentalService.currentCarId == car['id'];
          final isActiveRental = rentalService.isRenting && isCurrentCar;

          return AlertDialog(
            title: Text(car['name']),
            content: _buildDialogContent(rentalService, isActiveRental),
            actions: _buildDialogActions(context, car, isNearby, rentalService, isCurrentCar, isActiveRental),
          );
        },
      ),
    );
  }

  /// Builds the dialog content
  Widget _buildDialogContent(RentalService rentalService, bool isActiveRental) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isActiveRental) ...[
          const Text('€0.30 per minute'),
          const Text('Daily cap: €20.00'),
        ],
        if (isActiveRental) ...[
          const Text('Rental in progress:'),
          const SizedBox(height: 10),
          Text('Time: ${_formatDuration(rentalService.elapsedSeconds)}',
              style: Theme.of(context).textTheme.titleLarge),
          Text('Cost: €${rentalService.currentCost.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge),
        ],
      ],
    );
  }

  /// Builds the dialog actions
  List<Widget> _buildDialogActions(BuildContext context, Map<String, dynamic> car, bool isNearby,
      RentalService rentalService, bool isCurrentCar, bool isActiveRental) {
    return [
      if (!isNearby)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Get closer to rent this car', 
              style: TextStyle(color: Colors.red)),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        )
      else if (!rentalService.isRenting)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => _startRentalProcess(context, car),
              child: const Text('Start Rental'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        )
      else if (isCurrentCar)
        ElevatedButton(
          onPressed: () => _endRentalProcess(context, car['id']),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('End Rental'),
        )
      else
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Another car is currently being rented', 
              style: TextStyle(color: Colors.orange[700])),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
    ];
  }

  void _startRentalProcess(BuildContext context, Map<String, dynamic> car) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoCheckWidget(
          isPreRide: true,
          onComplete: () {
            final rentalService = context.read<RentalService>();
            Navigator.pop(context); // Close photo check
            rentalService.startRental(car['id']);
            // Show rental dialog again, now with active rental
            _showRentalControls(context, car, true);
          },
        ),
      ),
    );
  }

  void _endRentalProcess(BuildContext context, String carId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoCheckWidget(
          isPreRide: false,
          onComplete: () {
            final rentalService = context.read<RentalService>();
            final seconds = rentalService.elapsedSeconds;
            final cost = rentalService.endRental();
            Navigator.of(context).pop(); // Close photo check
            Navigator.of(context).pop(); // Close rental dialog
            _showRentalSummary(context, cost, seconds);
          },
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showRentalSummary(BuildContext context, double cost, int seconds) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Rental Complete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration: ${_formatDuration(seconds)}'),
            Text('Total cost: €${cost.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Just close the summary dialog
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Renting Cars')),
      body: Consumer3<LocationService, CarService, RentalService>(
        builder: _buildMapContent,
      ),
    );
  }

  /// Builds the map content with markers
  Widget _buildMapContent(BuildContext context, LocationService locationService,
      CarService carService, RentalService rentalService, Widget? child) {
    if (locationService.currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: locationService.currentLocation!,
        zoom: 15,
      ),
      onMapCreated: (controller) => _controller = controller,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: _createMarkers(locationService, carService),
    );
  }

  /// Creates markers for the map
  Set<Marker> _createMarkers(LocationService locationService, CarService carService) {
    final userLocation = LatLng(
      locationService.currentLocation!.latitude,
      locationService.currentLocation!.longitude,
    );

    return carService.carLocations.map((car) {
      final position = LatLng(car['lat'], car['lng']);
      final isNearby = carService.isCarNearby(userLocation, position);

      return Marker(
        markerId: MarkerId(car['id']),
        position: position,
        infoWindow: InfoWindow(title: car['name']),
        onTap: () => _showRentalControls(context, car, isNearby),
      );
    }).toSet();
  }
}