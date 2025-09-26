import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../farmer/pages/product_list_screen.dart';
import '../providers/buyer_dashboard_provider.dart';

class BrowseProductTab extends StatelessWidget {
  const BrowseProductTab({super.key});

  @override
  Widget build(BuildContext context) {
    final buyerProvider = Provider.of<BuyerDashboardProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Browse Available Grains',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: buyerProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : buyerProvider.availableProducts.isEmpty
              ? const Center(
                  child: Text('No grains currently available for purchase.'),
                )
              : ListView.builder(
                  itemCount: buyerProvider.availableProducts.length,
                  itemBuilder: (context, index) {
                    final product = buyerProvider.availableProducts[index];
                    return ProductCard(
                      product: product,
                    ); // Re-use the ProductCard
                  },
                ),
        ),
      ],
    );
  }
}
