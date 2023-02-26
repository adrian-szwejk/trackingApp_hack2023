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
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 150.0,
                width: 190.0,
                padding: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                ),
                child: const Center(
                  child: Text(
                    "ResQ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 200,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
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
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image.asset(
                      'assets/images/google-logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                child: const Text(
                  "Sign in with Google",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
