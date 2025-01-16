import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[50],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.teal),
            onPressed: () {
              // Navigate to Login Page
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the Admin Dashboard!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildAdminButton(
                context: context,
                label: 'Add Client',
                icon: Icons.add,
                iconColor: Colors.green,
                onPressed: () {
                  Navigator.pushNamed(context, '/addclient');
                },
              ),
              const SizedBox(height: 20),
              _buildAdminButton(
                context: context,
                label: 'Delete Client',
                icon: Icons.delete,
                iconColor: Colors.red,
                onPressed: () {
                  _deleteClient(context);
                },
              ),
              const SizedBox(height: 20),
              _buildAdminButton(
                context: context,
                label: 'View Clients',
                icon: Icons.view_list,
                iconColor: Colors.orange,
                onPressed: () {
                  Navigator.pushNamed(context, '/viewclient');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteClient(BuildContext context) {
    final emailController = TextEditingController();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Delete Client',
      desc: 'Enter the email of the client to delete:',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Client Email',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      btnOk: ElevatedButton(
        onPressed: () async {
          final email = emailController.text.trim();
          if (email.isNotEmpty) {
            try {
              // Query Firestore for the user with the entered email
              final querySnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: email)
                  .get();

              if (querySnapshot.docs.isNotEmpty) {
                // Get the document ID
                final documentId = querySnapshot.docs.first.id;

                // Get the UID from Firestore
                final userData = querySnapshot.docs.first.data();
                final userUid = userData['uid'];

                // Delete the document in Firestore
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(documentId)
                    .delete();

                // Delete the user from Firebase Authentication
                await FirebaseAuth.instance.currentUser!.delete();

                Navigator.of(context).pop(); // Dismiss dialog

                // Show success message
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.topSlide,
                  title: 'Success',
                  desc: 'Client with email $email deleted successfully!',
                  btnOkOnPress: () {
                    Navigator.pushReplacementNamed(context, '/adminDashboard');
                  },
                ).show();
              } else {
                Navigator.of(context).pop(); // Dismiss dialog

                // Show not found message
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.bottomSlide,
                  title: 'Not Found',
                  desc: 'No client found with the email $email.',
                  btnOkOnPress: () {},
                ).show();
              }
            } catch (e) {
              Navigator.of(context).pop(); // Dismiss dialog

              // Show error message
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'Error',
                desc: 'Failed to delete the client: $e',
                btnOkOnPress: () {},
              ).show();
            }
          } else {
            // Show warning for empty email field
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              title: 'Warning',
              desc: 'Please enter a valid email.',
              btnOkOnPress: () {},
            ).show();
          }
        },
        child: const Text('Delete'),
      ),
      btnCancel: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
      ),
    ).show();
  }

  Widget _buildAdminButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      icon: Icon(icon, color: iconColor),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
