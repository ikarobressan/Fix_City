import 'package:flutter/material.dart';

import '../models/category.dart';
import '../provider/firestore_provider.dart';

class CategoryForm extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  final Category? category;

  CategoryForm({super.key, this.category});

  void _loadFormData(Category category) {
    _formData['name'] = category.name;
    _formData['id'] = category.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (category != null) {
      _loadFormData(category as Category);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Criar categoria',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final isValid = _form.currentState!.validate();

              if (isValid) {
                _form.currentState?.save();
                final data = <String, String>{
                  "name": _formData['name']!,
                };
                FirestoreProvider.putDocument(
                  'categories',
                  data,
                  documentId: _formData['id'],
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                initialValue: _formData['name'],
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  return null;
                },
                onSaved: (value) => _formData['name'] = value!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
