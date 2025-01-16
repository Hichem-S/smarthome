import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = 'No First Name';
  String lastName = 'No Last Name';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Fetch user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Check if document exists and contains the fields
        if (userDoc.exists) {
          setState(() {
            firstName = userDoc['firstName'] ?? 'No First Name';
            lastName = userDoc['lastName'] ?? 'No Last Name';
          });
        } else {
          print('User document does not exist in Firestore.');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();
    bool confirmed = false;

    // Confirmation dialog
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Delete Account',
      desc: 'Are you sure you want to delete your account?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        confirmed = true;
      },
    ).show();

    if (!confirmed) return;

    // Password input dialog
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    if (result != true || passwordController.text.isEmpty) return;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email!;
        // Reauthenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: passwordController.text,
        );
        await user.reauthenticateWithCredential(credential);

        // Delete user document from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        // Delete account from Firebase Authentication
        await user.delete();

        // Navigate to login screen after successful deletion
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Success',
          desc: 'Account deleted successfully.',
          btnOkOnPress: () {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          },
        ).show();
      }
    } on FirebaseAuthException catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: e.message ?? 'Failed to delete account.',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$firstName $lastName',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                style: _buildButtonStyle(Colors.teal[700]),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.updateProfile);
                },
                style: _buildButtonStyle(Colors.teal[700]),
                child: const Text(
                  'Update Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _deleteAccount(context),
                style: _buildButtonStyle(Colors.teal[700]),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable button style function
  ButtonStyle _buildButtonStyle(Color? backgroundColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
