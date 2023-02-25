import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OrderTrackingPage(title: 'Search Team Tracking App'),
    );
  }
}

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key, required this.title});
  final String title;

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  Set<LatLng> loc = Set.from([]);
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        debugPrint("new location: $newLoc");
        if (!loc.contains(LatLng(newLoc.latitude!, newLoc.longitude!))) {
          circles.add(
            Circle(
              circleId: CircleId(circles.length.toString()),
              center: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
              radius: 100,
              fillColor: Colors.blue.withOpacity(0.5),
              strokeWidth: 0,
            ),
          );
          loc.add(LatLng(newLoc.latitude!, newLoc.longitude!));
        }

        debugPrint(circles.length.toString());
        debugPrint(circles.first.center.toString());
        setState(() {});
      },
    );
  }

  Set<Circle> circles = Set.from([]);

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 12)),
      ),
      body: currentLocation == null
          ? const Center(child: Text("Loading"))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 13.5,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                const Marker(
                  markerId: MarkerId("source"),
                  position: sourceLocation,
                ),
                const Marker(
                  markerId: MarkerId("destination"),
                  position: destination,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
              circles: circles,
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: getCurrentLocation,
            ),
          ],
        ),
      ),
    );
  }
}
