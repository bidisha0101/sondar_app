import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // For location services

// Convert to StatefulWidget
class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // --- State Variables ---
  bool _isLoadingLocation = false;
  Position? _currentPosition; // To potentially store/pass the location
  String? _locationError; // To display errors if needed
  // --- End State Variables ---

  // --- Implemented Geolocation Logic ---
  Future<void> _handleUseCurrentLocation() async {
    // Prevent multiple clicks while loading
    if (_isLoadingLocation) return;

    // Set loading state and clear previous errors/positions
    if (mounted) {
      setState(() {
        _isLoadingLocation = true;
        _locationError = null;
        _currentPosition = null;
      });
    }

    try {
      // 1. Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
          'Location services are disabled. Please enable location services.',
        );
      }

      // 2. Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions were denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. Please enable them in your app settings.',
        );
        // Consider guiding the user to settings: await Geolocator.openAppSettings();
      }

      // 3. Get the current location
      debugPrint('Getting current location...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best, // was: medium
      );

      debugPrint(
        'Location fetched: Lat: ${position.latitude}, Lon: ${position.longitude}',
      );

      // Store position and navigate if still mounted
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });

        // // --- Navigate after successful fetch ---
        // // Navigate to the manual location page, passing the fetched position
        // Navigator.pushNamed(
        //   context,
        //   '/manual-location',
        //   arguments: _currentPosition, // Pass the Position object
        // );
        // // --- End Navigation ---
      }
    } catch (e) {
      // 1. Log the detailed error for debugging purposes
      print("Error getting location: $e");
      String detailedError =
          e.toString(); // Get the full error string representation

      if (mounted) {
        // 2. Update state with the detailed error (optional, for potential display elsewhere)
        setState(() {
          _locationError = detailedError;
        });

        // 3. Show a user-friendly message in the SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // Provide a helpful message to the user, not necessarily the raw error string
            content: const Text(
              'Failed to get location. Please check settings/permissions and try again.',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      // ... (finally block remains the same) ...
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }
  // --- End Geolocation Logic ---

  // --- Build Method moved into State ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Skip Button (Functionality not implemented here)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    // Example: Navigate somewhere else directly if skipped
                    // Navigator.pushReplacementNamed(context, '/some_other_route');
                    debugPrint("Skip pressed");
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              // Main Content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        const Text(
                          "We want to give you the right recommendation",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Where should we reserve your seat?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 32),

                        // Location Button - Updated
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            // Disable button while loading
                            onPressed:
                                _isLoadingLocation
                                    ? null
                                    : _handleUseCurrentLocation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              // Optionally change style when disabled
                              disabledBackgroundColor: Colors.grey.shade400,
                            ),
                            icon:
                                _isLoadingLocation
                                    ? Container(
                                      // Show progress indicator instead of icon when loading
                                      width: 24,
                                      height: 24,
                                      padding: const EdgeInsets.all(2.0),
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                    : const Icon(
                                      Icons.location_pin,
                                    ), // Original icon
                            label: Text(
                              _isLoadingLocation
                                  ? "Fetching Location..."
                                  : "Use my current location",
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Manual Location Link
                        GestureDetector(
                          onTap:
                              _isLoadingLocation
                                  ? null
                                  : () {
                                    // Prevent tap during loading
                                    Navigator.pushNamed(
                                      context,
                                      '/manual-location',
                                    );
                                  },
                          child: Text(
                            "Set location manually",
                            style: TextStyle(
                              color:
                                  _isLoadingLocation
                                      ? Colors.grey
                                      : Colors.blue.shade600, // Dim if loading
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        // Optional: Display Error Message
                        if (_locationError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Error: $_locationError',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- End Build Method ---
}
