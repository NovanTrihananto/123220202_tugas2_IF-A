import 'package:flutter/material.dart';
import '../models/clothing.dart';
import '../services/api_service.dart';

class EditPage extends StatefulWidget {
  final Clothing clothing;
  const EditPage({super.key, required this.clothing});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;

  @override
  void initState() {
    super.initState();
    _formData = {
      'name': widget.clothing.name,
      'price': widget.clothing.price,
      'category': widget.clothing.category,
      'brand': widget.clothing.brand,
      'sold': widget.clothing.sold,
      'rating': widget.clothing.rating,
      'stock': widget.clothing.stock,
      'yearReleased': widget.clothing.yearReleased,
      'material': widget.clothing.material,
    };
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final success = await ApiService.updateClothing(widget.clothing.id, _formData);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clothing updated successfully')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update clothing')),
        );
      }
    }
  }

  String? _validateRating(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    final rating = double.tryParse(value);
    if (rating == null) return 'Invalid number';
    if (rating < 0 || rating > 5) return 'Rating must be between 0 and 5';
    return null;
  }

  String? _validateYearReleased(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    final year = int.tryParse(value);
    if (year == null) return 'Invalid number';
    if (year < 2018 || year > 2025) return 'Year must be between 2018 and 2025';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Clothing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField('name'),
              _buildTextFormField('category'),
              _buildTextFormField('brand'),
              _buildTextFormField('material'),
              _buildTextFormField('price', isNumber: true),
              _buildTextFormField('sold', isNumber: true),
              _buildTextFormField('rating', isDecimal: true, validator: _validateRating),
              _buildTextFormField('stock', isNumber: true),
              _buildTextFormField('yearReleased', isNumber: true, validator: _validateYearReleased),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Update')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    String key, {
    bool isNumber = false,
    bool isDecimal = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: _formData[key].toString(),
      decoration: InputDecoration(labelText: key),
      keyboardType: isDecimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : (isNumber ? TextInputType.number : TextInputType.text),
      onSaved: (value) {
        if (isNumber) {
          _formData[key] = int.tryParse(value ?? '') ?? 0;
        } else if (isDecimal) {
          _formData[key] = double.tryParse(value ?? '') ?? 0.0;
        } else {
          _formData[key] = value ?? '';
        }
      },
      validator: validator ?? (value) => (value == null || value.isEmpty) ? 'Field cannot be empty' : null,
    );
  }
}
