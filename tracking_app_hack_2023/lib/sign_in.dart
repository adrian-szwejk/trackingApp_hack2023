import 'package:flutter/material.dart';
import 'package:tracking_app_hack_2023/main.dart';
import 'package:tracking_app_hack_2023/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  Future<User> inputData() async {
    await Firebase.initializeApp();

    debugPrint("UserID");

    return (firebaseAuth.currentUser!);
    //final   = ;
    //currColor = color[]
    //return user_Uuid;
    // here you write the codes to input the data into firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //Instead of using an AppBar widget we use a flexible space to replace the appbar with a widget of our choosing
        flexibleSpace: Container(
          //We use DecoratedBox to allow us to use a gradient in the AppBar
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 5, 116, 23),
                Color.fromARGB(255, 5, 116, 23),
              ],
            ),
          ),
        ),
        title: const Text("ResQ"),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 5, 116, 23),
              Color.fromARGB(255, 221, 200, 10),
            ],
          )),
          child: Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 5, 116, 23)),
              ),
              onPressed: () async {
                await AuthService().signInWithGoogle();

                final User user = await inputData();
                final id = user.uid;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OrderTrackingPage(title: "ResQ", id: id)),
                );
              },
              child: const Text('Sign In With Google'),
            ),
          ),
        ),
      ),
    );
  }
}
