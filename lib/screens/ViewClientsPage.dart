import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewClientsPage extends StatefulWidget {
  const ViewClientsPage({Key? key}) : super(key: key);

  @override
  _ViewClientsPageState createState() => _ViewClientsPageState();
}

class _ViewClientsPageState extends State<ViewClientsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query.trim().toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Column(
        children: [
          const SizedBox(height: 50), // Move the search bar further down
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search clients by name or email',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No clients found.',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  );
                }

                final clients = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name =
                      "${data['firstName']} ${data['lastName']}".toLowerCase();
                  final email = data['email']?.toLowerCase() ?? "";

                  return name.contains(_searchQuery) ||
                      email.contains(_searchQuery);
                }).toList();

                if (clients.isEmpty) {
                  return const Center(
                    child: Text(
                      'No matching clients found.',
                      style: TextStyle(fontSize: 18, color: Colors.orange),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client =
                        clients[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(
                          client['firstName']?.substring(0, 1).toUpperCase() ??
                              "?",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        "${client['firstName']} ${client['lastName']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(client['email'] ?? "No email"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
