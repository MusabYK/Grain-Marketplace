import 'package:flutter/material.dart';
import 'package:grain_market_app/presentation/buyer/pages/buyer_profile_tab.dart';
import 'package:grain_market_app/presentation/farmer/pages/farmer_dashboard_screen.dart';
import 'package:grain_market_app/presentation/shared/ProfileScreen.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/user.dart';
import '../../auth/pages/auth_screen.dart';
import '../../auth/providers/auth_provider.dart';
import '../../farmer/pages/product_list_screen.dart';
import '../providers/buyer_dashboard_provider.dart';
import '../../farmer/pages/product_details_screen.dart'; // Re-use product details
import '../../shared/custom_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'browse_product_tab.dart';

class BuyerDashboardScreen extends StatefulWidget {
  const BuyerDashboardScreen({super.key});

  @override
  State<BuyerDashboardScreen> createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions() {
    return <Widget>[
      const _BuyerHomeTab(),
      const BrowseProductTab(),
      const ProfileTab(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch products when buyer dashboard loads
    Provider.of<BuyerDashboardProvider>(
      context,
      listen: false,
    ).fetchAvailableProducts();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    if (currentUser == null || currentUser.userType != 'buyer') {
      return const AuthScreen(); // Redirect if not logged in or not a buyer
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Buyer Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
      body: _widgetOptions().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse Grains',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _BuyerHomeTab extends StatelessWidget {
  const _BuyerHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final buyerProvider = Provider.of<BuyerDashboardProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${currentUser?.name ?? 'Buyer'}!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.lightGreen[800],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Market Insights',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard(
                        context,
                        'Available Grains',
                        '${buyerProvider.availableProducts.length}',
                        Icons.grain,
                      ),
                      _buildStatCard(
                        context,
                        'New Listings',
                        '5',
                        Icons.fiber_new,
                      ), // Placeholder
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Recently Added Grains',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          buyerProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : buyerProvider.availableProducts.isEmpty
              ? const Center(child: Text('No grains currently available.'))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: buyerProvider.availableProducts.length > 3
                      ? 3
                      : buyerProvider.availableProducts.length, // Show top 3
                  itemBuilder: (context, index) {
                    final product = buyerProvider.availableProducts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 2,
                      child: ListTile(
                        leading: product.imageUrl != null
                            ? Image.network(
                                product.imageUrl!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.grain,
                                size: 60,
                                color: Colors.grey,
                              ),
                        title: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${product.quantityAvailable} ${product.unit} @ N${product.pricePerUnit}/${product.unit}',
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () {
                // Navigate to Browse Products tab
                DefaultTabController.of(context)?.animateTo(1);
              },
              child: const Text('View All Available Grains'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.lightBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.lightBlue[700]),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
