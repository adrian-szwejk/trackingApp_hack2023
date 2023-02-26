import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tracking_app_hack_2023/sign_in.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

void main() {
  runApp(const MyApp());
}

//import { getAuth, onAuthStateChanged } from "firebase/auth";

var color = [Colors.blue, Colors.red, Colors.green, Colors.yellow];
var currColor = Colors.blue;

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
      home: const SignIn(),
    );
  }
}

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key, required this.title, required this.id});
  final String title;
  final String id;

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage>
    with SingleTickerProviderStateMixin {
  var color = [Colors.blue, Colors.red, Colors.green, Colors.yellow];
  var currColor = Colors.blue;

  bool loading = true;
  bool circleLoaded = false;
  double radius = 20; //* circle radius
  AnimationController? animationController;

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  Set<LatLng> loc = Set.from([]);
  LocationData? currentLocation;

  //* initial delay
  _delay() {
    //* delay before loading map
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(
        (() => loading = false),
      ),
    );
  }

  //Send circles to firestore database
  Future _sendCircles(LatLng l) async {
    await FirebaseFirestore.instance.collection('circles').add({
      'color': currColor.toString(),
      'lat': l.latitude,
      'long': l.longitude,
    });
  }

  //Get all circles from all users in firestore database
  Future getCircles() async {
    circles.clear();
    try {
      await FirebaseFirestore.instance.collection('circles').get().then(
        (QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach(
            (doc) {
              debugPrint('\ntest\n');
              debugPrint(doc['color'].substring(35, 45));
              String col = doc['color'].substring(35, 45);
              circles.add(
                Circle(
                  circleId: CircleId(doc.id),
                  center: LatLng(
                    doc['lat'],
                    doc['long'],
                  ),
                  radius: radius,
                  fillColor: (col == "0xff2196f3")
                      ? color[0]
                      : (col == "0xffff0000")
                          ? color[1]
                          : ((col == "0xff4caf50") ? color[2] : color[3]),
                  strokeWidth: 0,
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

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
        // googleMapController.animateCamera(
        //   CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //       zoom: 0.0,
        //       target: LatLng(
        //         newLoc.latitude!,
        //         newLoc.longitude!,
        //       ),
        //     ),
        //   ),
        // );
        LatLng l = LatLng(
            double.parse(currentLocation!.latitude!.toStringAsFixed(4)),
            double.parse(currentLocation!.longitude!.toStringAsFixed(4)));
        debugPrint("new location: $l");
        if (!loc.contains(LatLng(l.latitude, l.longitude))) {
          circles.add(
            Circle(
              circleId: CircleId(circles.length.toString()),
              center: LatLng(
                l.latitude,
                l.longitude,
              ),
              radius: radius,
              fillColor: currColor.withOpacity(0.8),
              strokeWidth: 0,
            ),
          );
          loc.add(LatLng(l.latitude, l.longitude));
          _sendCircles(LatLng(l.latitude, l.longitude));
        }

        debugPrint(circles.length.toString());
        debugPrint(circles.first.center.toString());
        setState(() {});
      },
    );
  }

  Set<Circle> circles = Set.from([]);
  String user_Uuid = "";

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: (const Duration(milliseconds: 1800)),
    )..repeat();

    _delay();
    if (widget.id == "liaiFt5xfhY7yMaazrhUwuZPYAS2") currColor = color[1];

    getCurrentLocation();
    debugPrint("User");
    getCircles();

    super.initState();
  }

  void inputData() async {
    final User user = await firebaseAuth.currentUser!;
    user_Uuid = user.uid;
    //currColor = color[]
    debugPrint("UserID");

    debugPrint(user_Uuid);
    // here you write the codes to input the data into firestore
  }

  @override
  void dispose() {
    //* dispose animations and map here
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 12)),
      ),
      body: AnimatedBuilder(
        animation: animationController!,
        builder: (context, child) {
          return currentLocation == null
              ? const Center(child: Text("Loading"))
              : GoogleMap(
                  mapType: MapType.satellite,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  compassEnabled: true,
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                    zoom: 20.0,
                    target: LatLng(
                        double.parse(
                            currentLocation!.latitude!.toStringAsFixed(4)),
                        double.parse(
                            currentLocation!.longitude!.toStringAsFixed(4))),
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("currentLocation"),
                      position: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
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
                );
        },
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
