import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/providers/auth_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the AuthProvider and current user data
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    // Define colors based on role for a subtle visual distinction
    final Color primaryColor = currentUser?.userType == 'farmer'
        ? Colors.lightGreen
        : Colors.blue.shade700!;
    final Color accentColor = currentUser?.userType == 'farmer'
        ? Colors.green.shade100!
        : Colors.blue.shade100!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: accentColor,
              child: Icon(Icons.person, size: 60, color: primaryColor),
            ),
            const SizedBox(height: 20),
            Text(
              // Display user's name
              currentUser?.name ?? 'User',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              // Display user's email
              currentUser?.email ?? 'N/A',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              // Display user's role, capitalized
              'Role: ${currentUser?.userType.capitalize() ?? 'N/A'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 30),

            // --- Edit Profile Button ---
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement Edit Profile screen navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit Profile functionality coming soon!'),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                backgroundColor: primaryColor, // Use the role-based color
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Logout Button ---
            OutlinedButton.icon(
              onPressed: () async {
                // Call the signOut method from the AuthProvider
                await authProvider.signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                side: const BorderSide(color: Colors.redAccent),
                foregroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    // Safety check for null/empty string before capitalizing
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
