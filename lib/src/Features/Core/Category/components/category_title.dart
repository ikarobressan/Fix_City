import 'package:flutter/material.dart';
import 'package:the_safe_city/src/Features/Core/Category/models/category.dart';
import 'package:the_safe_city/src/Features/Core/Category/provider/firestore_provider.dart';
import 'package:the_safe_city/src/Features/Core/Category/views/category_form.dart';

class CategoryTile extends StatelessWidget {
  final Category category;

  const CategoryTile(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(category.name),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CategoryForm(category: category)));
                  },
                  icon: const Icon(Icons.edit),
                  color: Colors.blue),
              IconButton(
                  onPressed: () {
                    FirestoreProvider.removeDocument(
                        'categories', category.id!);
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red),
            ],
          ),
        ));
  }
}
