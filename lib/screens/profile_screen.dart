import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ✅ Variable to keep track of which profile is currently "Selected"
  Map<String, dynamic>? selectedProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProfile == null ? 'Profile Manager' : 'User Profile'),
        leading: selectedProfile != null
            ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => selectedProfile = null))
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () => _showCreateProfileDialog(context),
          ),
        ],
      ),
      body: selectedProfile == null
          ? _buildProfileList() // Show the list if none selected
          : _buildFullProfilePage(selectedProfile!), // Show FULL PAGE if selected
    );
  }

  /// ✅ 1. THE LIST VIEW (For selecting a profile)
  Widget _buildProfileList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No profiles found. Create one above!"));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(child: Text(data['name'][0])),
                title: Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(data['registrationNumber']),
                onTap: () => setState(() => selectedProfile = data), // Set selected profile
              ),
            );
          }).toList(),
        );
      },
    );
  }

  /// ✅ 2. THE FULL PROFILE PAGE (Shows the full details like your screenshot)
  Widget _buildFullProfilePage(Map<String, dynamic> profile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Large Avatar
          const Center(
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Color(0xFFFFE0B2),
              child: Icon(Icons.person, size: 80, color: Colors.orange),
            ),
          ),
          const SizedBox(height: 20),
          // Large Name and ID
          Text(profile['name'], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(profile['registrationNumber'], style: const TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 30),

          // Info Cards (Full Page Details)
          _buildDetailCard(Icons.person, "Name", profile['name']),
          _buildDetailCard(Icons.badge, "Registration Number", profile['registrationNumber']),
          _buildDetailCard(Icons.email, "Email", "${profile['registrationNumber'].toLowerCase()}@university.edu.pk"),

          const SizedBox(height: 30),
          // Switch Profile Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => setState(() => selectedProfile = null),
                child: const Text("Switch Profile"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withOpacity(0.1),
          child: Icon(icon, color: Colors.orange),
        ),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  /// ✅ 3. DIALOG TO CREATE NEW PROFILE (Firestore)
  void _showCreateProfileDialog(BuildContext context) {
    final nameController = TextEditingController();
    final regController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: regController, decoration: const InputDecoration(labelText: 'Registration ID')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && regController.text.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('users').add({
                    'name': nameController.text,
                    'registrationNumber': regController.text,
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Create')
          ),
        ],
      ),
    );
  }
}