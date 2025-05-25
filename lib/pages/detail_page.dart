import 'package:flutter/material.dart';
import '../models/clothing.dart';

class DetailPage extends StatelessWidget {
  final Clothing clothing;

  const DetailPage({super.key, required this.clothing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(clothing.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Category: ${clothing.category}"),
            Text("Brand: ${clothing.brand}"),
            Text("Material: ${clothing.material}"),
            Text("Price: Rp${clothing.price}"),
            Text("Stock: ${clothing.stock}"),
            Text("Sold: ${clothing.sold}"),
            Text("Rating: ${clothing.rating}"),
            Text("Year Released: ${clothing.yearReleased}"),
          ],
        ),
      ),
    );
  }
}
