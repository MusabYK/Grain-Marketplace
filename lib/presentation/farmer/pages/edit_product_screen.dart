import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/app_validators.dart';
import '../../../domain/entities/product.dart';
import '../providers/farmer_dashboard_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _locationController;
  String? _selectedUnit;
  File? _newImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing product data
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _priceController = TextEditingController(
      text: widget.product.pricePerUnit.toString(),
    );
    _quantityController = TextEditingController(
      text: widget.product.quantityAvailable.toString(),
    );
    _locationController = TextEditingController(text: widget.product.location);
    _selectedUnit = widget.product.unit;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceOptions() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a new picture'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                setState(() {
                  if (pickedFile != null) {
                    _newImageFile = File(pickedFile.path);
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                setState(() {
                  if (pickedFile != null) {
                    _newImageFile = File(pickedFile.path);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedUnit == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a unit of measurement.')),
        );
        return;
      }

      final farmerProvider = Provider.of<FarmerDashboardProvider>(
        context,
        listen: false,
      );

      // Create an updated Product object
      final updatedProduct = widget.product.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        pricePerUnit: double.parse(_priceController.text),
        unit: _selectedUnit!,
        quantityAvailable: double.parse(_quantityController.text),
        location: _locationController.text.isEmpty
            ? null
            : _locationController.text,
      );

      // Call the provider method to update the product
      bool success = await farmerProvider.updateProduct(
        updatedProduct,
        _newImageFile,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully!')),
        );
        Navigator.of(context).pop(); // Go back to the details screen
      } else if (farmerProvider.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(farmerProvider.errorMessage!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<FarmerDashboardProvider>(
        builder: (context, farmerProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Grain Details',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Grain Name',
                    validator: (value) =>
                        value!.isEmpty ? 'Name cannot be empty' : null,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: _descriptionController,
                    labelText: 'Description',
                    validator: (value) =>
                        value!.isEmpty ? 'Description cannot be empty' : null,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          controller: _priceController,
                          labelText: 'Price Per Unit',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) return 'Price cannot be empty';
                            if (double.tryParse(value) == null)
                              return 'Enter a valid number';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: _selectedUnit,
                          decoration: InputDecoration(
                            labelText: 'Unit',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          items: const [
                            DropdownMenuItem(value: 'kg', child: Text('KG')),
                            DropdownMenuItem(value: 'ton', child: Text('Ton')),
                            DropdownMenuItem(value: 'bag', child: Text('Bag')),
                            DropdownMenuItem(
                              value: 'bushel',
                              child: Text('Bushel'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedUnit = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Select unit';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: _quantityController,
                    labelText: 'Quantity Available',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return 'Quantity cannot be empty';
                      if (double.tryParse(value) == null)
                        return 'Enter a valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: _locationController,
                    labelText: 'Location (Optional)',
                    keyboardType: TextInputType.streetAddress,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Update Image',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _showImageSourceOptions,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      child: _newImageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.file(
                                _newImageFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : (widget.product.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child: Image.network(
                                      widget.product.imageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.broken_image,
                                                size: 80,
                                                color: Colors.grey,
                                              ),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 50,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tap to add an image',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  )),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: farmerProvider.isLoading ? null : _updateProduct,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                      elevation: 5,
                    ),
                    child: farmerProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Update Product',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
