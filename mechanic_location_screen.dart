import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MechanicLocationScreen extends StatefulWidget {
  final String name;
  final LatLng location;

  const MechanicLocationScreen({
    super.key,
    required this.name,
    required this.location,
  });

  @override
  State<MechanicLocationScreen> createState() => _MechanicLocationScreenState();
}

class _MechanicLocationScreenState extends State<MechanicLocationScreen> {
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: widget.location,
          zoom: 15.5,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('shopMarker'),
            position: widget.location,
            infoWindow: InfoWindow(title: widget.name),
          ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
