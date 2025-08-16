import 'package:flutter/material.dart';
import '../../../domain/entities/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imageUrl != null)
              Hero(
                tag: product.id, // For smooth transition
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[200],
                child: const Icon(Icons.grain, size: 100, color: Colors.grey),
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        '₦${product.pricePerUnit.toStringAsFixed(2)} / ${product.unit}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 20),
                      Icon(Icons.scale, color: Colors.grey[700], size: 24),
                      const SizedBox(width: 5),
                      Text(
                        '${product.quantityAvailable} ${product.unit} available',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blueGrey, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        'Location: ${product.location ?? 'Not specified'}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.blueGrey,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Posted on: ${product.postedDate.day}/${product.postedDate.month}/${product.postedDate.year}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // For farmers, display options to edit/delete
                  // For buyers, display options to inquire/buy
                  // This screen can be adapted or duplicated for buyer view
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement "Contact Farmer" or "Make an Offer" for buyers
                        // TODO: Implement "Edit Product" for farmers
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Functionality to be implemented!'),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.message,
                      ), // Or Icons.edit for farmer
                      label: const Text('Contact Farmer / Make Offer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
