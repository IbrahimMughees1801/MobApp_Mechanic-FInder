import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'mechanic_location_screen.dart';

class NearbyMechanicsScreen extends StatelessWidget {
  NearbyMechanicsScreen({super.key});

  final List<Map<String, dynamic>> mechanics = [
    {
      'name': 'AutoZone Workshop',
      'rating': 4.8,
      'distance': '2.5 km',
      'description': 'Expert car repairs and maintenance.',
      'location': const LatLng(31.5123, 74.3542),
    },
    {
      'name': 'SpeedFix Garage',
      'rating': 4.5,
      'distance': '3.1 km',
      'description': 'Fast and reliable service for all vehicles.',
      'location': const LatLng(31.5189, 74.3621),
    },
    {
      'name': '5 Star Mechanics',
      'rating': 5.0,
      'distance': '4.0 km',
      'description': 'Premium mechanic service with towing support.',
      'location': const LatLng(31.5281, 74.3478),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Nearby Mechanics",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: mechanics.length,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        itemBuilder: (context, index) {
          final mechanic = mechanics[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MechanicLocationScreen(
                    name: mechanic['name'],
                    location: mechanic['location'],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Icon
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.build_circle_outlined,
                        color: Colors.orange,
                        size: 35,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Mechanic Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mechanic['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            mechanic['description'],
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amber.shade700, size: 18),
                              Text(
                                ' ${mechanic['rating']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.location_on_outlined,
                                  color: Colors.redAccent, size: 18),
                              Text(
                                mechanic['distance'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Arrow icon
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 18),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
