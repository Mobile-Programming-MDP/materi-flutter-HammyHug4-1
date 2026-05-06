import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapDetailScreen extends StatelessWidget {
  final double lat;
  final double lng;

  const MapDetailScreen({
    super.key,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Lokasi")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, lng),
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 50,
                height: 50,
                point: LatLng(lat, lng),
                child: Icon(Icons.location_on, color: Colors.red, size: 50),
              ),
            ],
          ),
        ],
      ),
    );
  }
}