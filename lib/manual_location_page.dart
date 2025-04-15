import 'package:flutter/material.dart';

class ManualLocationPage extends StatefulWidget {
  const ManualLocationPage({super.key});

  @override
  State<ManualLocationPage> createState() => _ManualLocationPageState();
}

class _ManualLocationPageState extends State<ManualLocationPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> popularCities = [
    "New York",
    "Los Angeles",
    "Chicago",
    "Houston",
    "London",
    "Tokyo",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.grey),
                  label: const Text(
                    'Back',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              // Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Location',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 16),

              // Search box
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search city',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Use current location
              OutlinedButton.icon(
                onPressed: () {
                  // Handle current location logic here
                },
                icon: const Icon(Icons.location_on, color: Colors.blue),
                label: const Text("Use current location"),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  side: const BorderSide(color: Colors.grey),
                  foregroundColor: Colors.black87,
                ),
              ),

              const SizedBox(height: 24),

              // Popular Cities Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Popular Cities',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Popular Cities Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children:
                      popularCities.map((city) {
                        return OutlinedButton(
                          onPressed: () {
                            // Handle city selection
                          },
                          style: OutlinedButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(city),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
