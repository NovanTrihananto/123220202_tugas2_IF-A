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
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update clothing')),
      );
    }
  }
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
              ..._buildTextFields(),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Update')),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return [
      _buildTextFormField('name'),
      _buildTextFormField('category'),
      _buildTextFormField('brand'),
      _buildTextFormField('material'),
      _buildTextFormField('price', isNumber: true),
      _buildTextFormField('sold', isNumber: true),
      _buildTextFormField('rating', isDecimal: true),
      _buildTextFormField('stock', isNumber: true),
      _buildTextFormField('yearReleased', isNumber: true),
    ];
  }

  Widget _buildTextFormField(String key,
      {bool isNumber = false, bool isDecimal = false}) {
    return TextFormField(
      initialValue: _formData[key].toString(),
      decoration: InputDecoration(labelText: key),
      keyboardType:
          isDecimal ? TextInputType.numberWithOptions(decimal: true) : (isNumber ? TextInputType.number : TextInputType.text),
      onSaved: (value) {
        if (isNumber) {
          _formData[key] = int.tryParse(value ?? '') ?? 0;
        } else if (isDecimal) {
          _formData[key] = double.tryParse(value ?? '') ?? 0.0;
        } else {
          _formData[key] = value ?? '';
        }
      },
      validator: (value) => (value == null || value.isEmpty)
          ? 'Field cannot be empty'
          : null,
    );
  }
}