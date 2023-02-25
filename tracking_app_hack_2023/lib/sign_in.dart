import 'package:flutter/material.dart';
import 'package:tracking_app_hack_2023/main.dart';
import 'package:tracking_app_hack_2023/services/auth_service.dart';

class SignIn extends StatelessWidget {

  const SignIn({super.key});


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
            onPressed: () {
              AuthService().signInWithGoogle();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderTrackingPage(title:"test")),
              );
            },
            child: const Text('Sign In With Google'),
          ),
        ],
      ),
    );
  }
}
