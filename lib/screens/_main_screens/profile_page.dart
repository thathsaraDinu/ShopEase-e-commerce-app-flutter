import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth package
import 'package:google_sign_in/google_sign_in.dart'; // Google Sign-In package

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _signOut(userRepo) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      if (auth.currentUser?.providerData[0].providerId == 'google.com') {
        // If the user signed in using Google
        await GoogleSignIn().signOut(); // Sign out from Google
      }

      await userRepo.signOut(); // Sign out from Firebase
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/signupandlogin', (routes) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-out failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<FirebaseUserRepo>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                    color: Colors.red[900])),
            const SizedBox(height: 25),
            StreamBuilder<MyUser>(
              stream: userRepo.user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 30,
                    width: 30,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 113, 44, 44)),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('No user data available');
                } else {
                  MyUser user = snapshot.data!;
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final userProvider =
                      auth.currentUser?.providerData[0].providerId;

                  // For Google login, retrieve Google user info
                  String userName = '';
                  String userEmail =
                      auth.currentUser?.email ?? 'No email found';

                  if (userProvider == 'google.com') {
                    userName = auth.currentUser?.displayName ?? 'Google User';
                  } else {
                    userName = user
                        .name; // For other logins, use the user.name from Firebase
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.red,
                        child: Text(
                          userName.isNotEmpty
                              ? userName.substring(0, 1).toUpperCase()
                              : 'N', // Default to 'N' if name is empty
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$userName', // Display the correct name
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$userEmail', // Show the email (Gmail if signed in via Google)
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Display different info based on login type
                      if (userProvider == 'google.com') ...[
                        const SizedBox(height: 10),
                        Text(
                          'Logged in via Google',
                          style: TextStyle(fontSize: 16, color: Colors.green[700], fontWeight: FontWeight.bold),
                        ),
                      ] else if (userProvider == 'password') ...[
                        const SizedBox(height: 10),
                        Text(
                          'Logged in via Email/Password',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700], fontWeight: FontWeight.bold),
                        ),
                      ],
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _signOut(userRepo);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/changePassword');
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/privacyPolicy');
              },
            ),
            ListTile(
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/termsOfService');
              },
            ),
          ],
        ),
      ),
    );
  }
}
