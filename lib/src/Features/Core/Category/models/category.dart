import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String? id;
  final String name;

  const Category({
    this.id,
    required this.name,
  });

  factory Category.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Category(
      id: document.id,
      name: data['name'],
    );
  }
}
