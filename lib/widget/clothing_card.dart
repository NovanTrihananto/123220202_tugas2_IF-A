import 'package:flutter/material.dart';
import '../models/clothing.dart';

class ClothingCard extends StatelessWidget {
  final Clothing cloth;
  final VoidCallback onTap;
  const ClothingCard({required this.cloth, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.checkroom, size: 40),
              Text(cloth.name, style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Rp ${cloth.price}'),
              Text('⭐ ${cloth.rating}')
            ],
          ),
        ),
      ),
    );
  }
}