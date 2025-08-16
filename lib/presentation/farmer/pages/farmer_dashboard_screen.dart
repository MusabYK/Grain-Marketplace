import 'package:flutter/material.dart';
import 'package:grain_market_app/presentation/farmer/pages/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/user.dart';
import '../../auth/pages/auth_screen.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/farmer_dashboard_provider.dart';
import 'post_product_screen.dart';
import 'product_list_screen.dart';
import '../../shared/custom_app_bar.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions(User? currentUser) {
    return <Widget>[
      // Home Dashboard for Farmers - could show quick stats, recent inquiries etc.
      _FarmerHomeTab(farmerId: currentUser?.uid ?? ''),
      // Farmer's own posted products
      ProductListScreen(farmerId: currentUser?.uid ?? ''),
      // Market Info - general product listing for market trend analysis [cite: 16, 22, 26]
      _MarketInfoTab(),
      // Profile Tab - farmer's profile, settings etc.
      _ProfileTab(),
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
    // Fetch farmer's products and all products when the dashboard loads
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser?.userType == 'farmer') {
      Provider.of<FarmerDashboardProvider>(
        context,
        listen: false,
      ).fetchFarmerProducts(authProvider.currentUser!.uid);
    }
    Provider.of<FarmerDashboardProvider>(
      context,
      listen: false,
    ).fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    if (currentUser == null || currentUser.userType != 'farmer') {
      // Redirect to AuthScreen if not logged in or not a farmer
      return const AuthScreen();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Farmer Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
      body: _widgetOptions(currentUser).elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'My Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Market Info',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton:
          _selectedIndex ==
              1 // Only show FAB on "My Products" tab
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PostProductScreen(),
                  ),
                );
              },
              label: const Text('Post New Grain'),
              icon: const Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _FarmerHomeTab extends StatelessWidget {
  final String farmerId;
  const _FarmerHomeTab({required this.farmerId});

  @override
  Widget build(BuildContext context) {
    final farmerProvider = Provider.of<FarmerDashboardProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, Farmer!',
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
                    'Quick Stats',
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
                        'Total Listings',
                        '${farmerProvider.farmerProducts.length}',
                        Icons.list_alt,
                      ),
                      _buildStatCard(
                        context,
                        'Active Listings',
                        '${farmerProvider.farmerProducts.where((p) => p.status == 'available').length}',
                        Icons.check_circle_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Add more stats, e.g., total sales, pending orders
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Your Recent Listings',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          farmerProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : farmerProvider.farmerProducts.isEmpty
              ? const Center(child: Text('No products listed yet.'))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: farmerProvider.farmerProducts.length > 3
                      ? 3
                      : farmerProvider.farmerProducts.length, // Show top 3
                  itemBuilder: (context, index) {
                    final product = farmerProvider.farmerProducts[index];
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
                          '${product.quantityAvailable} ${product.unit} @ ₦${product.pricePerUnit}/${product.unit}',
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
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
                // Navigate to My Products tab
                DefaultTabController.of(
                  context,
                )?.animateTo(1); // Assuming a TabBar or similar
              },
              child: const Text('View All My Products'),
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
          color: Colors.lightGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Theme.of(context).primaryColor),
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
                color: Colors.lightGreen[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketInfoTab extends StatelessWidget {
  const _MarketInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final farmerProvider = Provider.of<FarmerDashboardProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Market Overview',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: farmerProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : farmerProvider.allProducts.isEmpty
              ? const Center(child: Text('No market data available.'))
              : ListView.builder(
                  itemCount: farmerProvider.allProducts.length,
                  itemBuilder: (context, index) {
                    final product = farmerProvider.allProducts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            product.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      product.imageUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.grain,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${product.quantityAvailable} ${product.unit} available',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '₦${product.pricePerUnit.toStringAsFixed(2)} / ${product.unit}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Posted on: ${product.postedDate.day}/${product.postedDate.month}/${product.postedDate.year}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.lightGreen.shade100,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.lightGreen.shade700,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentUser?.name ?? 'Farmer User',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              currentUser?.email ?? 'N/A',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Role: ${currentUser?.userType.capitalize() ?? 'N/A'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement Edit Profile
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
                backgroundColor: Colors.lightGreen[500],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () async {
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
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
