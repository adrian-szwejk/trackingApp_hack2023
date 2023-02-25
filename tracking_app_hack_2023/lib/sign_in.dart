import 'package:flutter/material.dart';
import 'package:tracking_app_hack_2023/main.dart';
import 'package:tracking_app_hack_2023/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
        title: const Text('Sign In'),
      ),
      body: Column(
        children: [
          const Text('Sign In'),
          ElevatedButton(
            onPressed: () async {
              await AuthService().signInWithGoogle();

              final User user = await inputData();
              final  id = user.uid!;

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  OrderTrackingPage(title:"test", id:id )),
              );



            },
            child: const Text('Sign In With Google'),
          ),
        ],
      ),
    );
  }
}
