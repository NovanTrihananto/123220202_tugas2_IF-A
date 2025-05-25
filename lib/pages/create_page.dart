import 'package:flutter/material.dart';
import '../models/clothing.dart';
import '../services/api_service.dart';

class CreateClothingPage extends StatefulWidget {
  @override
  _CreateClothingPageState createState() => _CreateClothingPageState();
}

class _CreateClothingPageState extends State<CreateClothingPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _brandController = TextEditingController();
  final _soldController = TextEditingController();
  final _ratingController = TextEditingController();
  final _stockController = TextEditingController();
  final _yearReleasedController = TextEditingController();
  final _materialController = TextEditingController();

  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final clothing = Clothing(
      name: _nameController.text,
      price: int.parse(_priceController.text),
      category: _categoryController.text,
      brand: _brandController.text,
      sold: int.parse(_soldController.text),
      rating: double.parse(_ratingController.text),
      stock: int.parse(_stockController.text),
      yearReleased: int.parse(_yearReleasedController.text),
      material: _materialController.text,
    );

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.createClothing(clothing);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clothing created successfully!')),
      );
      Navigator.pop(context); // kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _brandController.dispose();
    _soldController.dispose();
    _ratingController.dispose();
    _stockController.dispose();
    _yearReleasedController.dispose();
    _materialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Clothing')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Price is required';
                  if (int.tryParse(v) == null) return 'Price must be an integer';
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (v) => v == null || v.isEmpty ? 'Category is required' : null,
              ),
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(labelText: 'Brand'),
                validator: (v) => v == null || v.isEmpty ? 'Brand is required' : null,
              ),
              TextFormField(
                controller: _soldController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Sold'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Sold is required';
                  if (int.tryParse(v) == null) return 'Sold must be an integer';
                  return null;
                },
              ),
              TextFormField(
                controller: _ratingController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Rating (0 - 5)'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Rating is required';
                  final r = double.tryParse(v);
                  if (r == null || r < 0 || r > 5) return 'Rating must be between 0 and 5';
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Stock'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Stock is required';
                  if (int.tryParse(v) == null) return 'Stock must be an integer';
                  return null;
                },
              ),
              TextFormField(
                controller: _yearReleasedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Year Released (2018 - 2025)'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Year released is required';
                  final y = int.tryParse(v);
                  if (y == null || y < 2018 || y > 2025) return 'Year must be between 2018 and 2025';
                  return null;
                },
              ),
              TextFormField(
                controller: _materialController,
                decoration: InputDecoration(labelText: 'Material'),
                validator: (v) => v == null || v.isEmpty ? 'Material is required' : null,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text('Create Clothing'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
