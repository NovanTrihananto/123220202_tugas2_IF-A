import 'package:flutter/material.dart';
import '../models/clothing.dart';
import '../services/api_service.dart';
import 'create_page.dart';
import 'detail_page.dart';
import '../widget/clothing_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Clothing>> clothes;

  @override
  void initState() {
    super.initState();
    clothes = ApiService.fetchClothes();
  }

  void refresh() {
    setState(() {
      clothes = ApiService.fetchClothes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clothes List')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreateClothingPage()),
            );
          },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: clothes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('${snapshot.error}'));

          final data = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) => ClothingCard(
              cloth: data[index],
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(clothing: data[index]),
                  ),
                );
                refresh();
              },
            ),
          );
        },
      ),
    );
  }
}