import 'package:flutter/material.dart';
import '../models/clothing.dart';
import '../services/api_service.dart';
import 'edit_page.dart';

class DetailPage extends StatefulWidget {
  final Clothing clothing;
  const DetailPage({super.key, required this.clothing});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Clothing _clothing;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _clothing = widget.clothing;
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final updated = await ApiService.fetchClothing(_clothing.id!);
      setState(() {
        _clothing = updated;
      });
    } catch (e) {
      debugPrint('Failed to refresh clothing data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh data')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_clothing.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  _infoRow('Category', _clothing.category),
                  _infoRow('Brand', _clothing.brand),
                  _infoRow('Material', _clothing.material),
                  _infoRow('Price', 'Rp${_clothing.price}'),
                  _infoRow('Stock', '${_clothing.stock}'),
                  _infoRow('Sold', '${_clothing.sold}'),
                  _infoRow('Rating', '${_clothing.rating}'),
                  _infoRow('Year Released', '${_clothing.yearReleased}'),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => EditPage(clothing: _clothing),
            ),
          );

          if (result == true) {
            await _refreshData();
            Navigator.pop(context, true); // beri tahu HomePage untuk refresh
          }
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
