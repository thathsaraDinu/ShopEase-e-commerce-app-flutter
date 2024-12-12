import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginChecker extends StatelessWidget {
  const LoginChecker({super.key, required this.routeName});
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
        stream:
            FirebaseAuth.instance.authStateChanges(), // Listen to auth state
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ShopEase(1).png',
                    height: 200,
                  ),
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 113, 44, 44)),
                    strokeWidth: 4.0,
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
                child: Text(
              'An Error occured',
              style: TextStyle(color: Colors.red),
            ));
          }
          if (!snapshot.hasData) {
            // If no user is logged in, redirect to the sign-up/login page
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/signupandlogin',
                (routes) => false,
              );
            });
            return Container(); // Empty container while navigating
          } else {
            // If the user is logged in, navigate to the specified route
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(
                context,
                routeName,
              );
            });
            return Container(); // Empty container while navigating
          }
        },
      ),
    );
  }
}
