import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRoute Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LiveLocationPage(),
    );
  }
}

class LiveLocationPage extends StatefulWidget {
  const LiveLocationPage({Key? key}) : super(key: key);

  @override
  State<LiveLocationPage> createState() => _LiveLocationPageState();
}

LatLng _currentMapPosition = const LatLng(11.3406, 77.7171);
class _LiveLocationPageState extends State<LiveLocationPage> {
  String _status = "Press button to report location";
  final MapController _mapController = MapController();

  Future<void> _sendLocationToBackend() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _status = "Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _status = "Location permissions are permanently denied.");
      return;
    }

    setState(() => _status = "Fetching GPS coordinates...");
    
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      _mapController.move(LatLng(position.latitude, position.longitude), 16.0);

      setState(() => _status = "Connecting to SafeRoute Backend...");

      // Uses the standard loopback address for Android Emulators to connect to your local PC host
      final url = Uri.parse(
        'http://10.78.186.50:8080/api/incidents/report' 
        '?title=User reported location'
        '&description=Testing route connection'
        '&lat=${position.latitude}'
        '&lng=${position.longitude}'
        '&severity=Low'
        );
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
         _status = "Area Profile: ${data['status']}\n"
                   "Safety Index: ${data['safetyScore']}/100\n\n"
                   "${data['description']}";
              
         _currentMapPosition = LatLng(position.latitude, position.longitude);
      });
  
      _mapController.move(_currentMapPosition, 16.0);
      } else {
        setState(() => _status = "Server Error: Received Status Code ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _status = "Connection failed: Ensure Spring Boot is running.\nDetails: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeRoute Minimal Tracker'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Container(
               height: 350,
               margin: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: Colors.blueAccent),
              ),
              child: ClipRRect( 
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(11.3406, 77.7171), // Centers on your coordinates
                    initialZoom: 16.0,
                  ),
                  children: [
                    TileLayer( // This fetches the free map background imagery layers
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.saferoute.backend',
                   ),
                   MarkerLayer(
                     markers: [
                      Marker(
                        point: _currentMapPosition,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
         ),
              Text(
                _status, 
                textAlign: TextAlign.center, 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _sendLocationToBackend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                icon: const Icon(Icons.location_on, color: Colors.white),
                label: const Text(
                  "Send Live Location", 
                  style: TextStyle(fontSize: 16, color: Colors.white)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}