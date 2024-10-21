import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта відключень'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(48.3794, 31.1656),
          zoom: 6.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: [
                  LatLng(49.5000, 23.5000),
                  LatLng(49.5000, 24.0000),
                  LatLng(49.0000, 24.0000),
                  LatLng(49.0000, 23.5000),
                ],
                color: Colors.blue.withOpacity(0.5),
                borderStrokeWidth: 2.0,
                borderColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
