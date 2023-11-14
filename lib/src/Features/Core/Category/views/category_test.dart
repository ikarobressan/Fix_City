import 'package:flutter/material.dart';

import '../components/category_title.dart';
import '../models/category.dart';
import '../provider/firestore_provider.dart';

class CategoryTest extends StatelessWidget {
  const CategoryTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirestoreProvider.getdocumentsStream('categories'),
        builder: (context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar dados: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhuma categoria encontrada.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (ctx, i) =>
                CategoryTile(snapshot.data?[i] as Category),
          );
        },
      ),
    );
  }
}
