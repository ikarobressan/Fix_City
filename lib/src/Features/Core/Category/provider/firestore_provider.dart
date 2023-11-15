import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';

class FirestoreProvider with ChangeNotifier {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<List<Category>> getdocumentsStream(String collectionName) {
    return _firestore.collection(collectionName).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
      },
    );
  }

  static Stream<List<DocumentSnapshot>> getDocumentsBy(
      String collectionName, String attributeName, String attributeValue) {
    try {
      return _firestore
          .collection(collectionName)
          .where(attributeName, isEqualTo: attributeValue)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } catch (e) {
      log('Erro ao obter chamados: $e');
      return Stream.value([]);
    }
  }

  static Future<List<String>> getDocuments(String collectionName) async {
    List<String> categories = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();

    for (var doc in querySnapshot.docs) {
        categories.add(
          doc['name'],
        );
      }

    return categories;
  }

  static Future<void> putDocument(
    String collectionName,
    Map<String, dynamic> data, {
    String? documentId,
  }) async {
    try {
      if (documentId != null) {
        // Se documentId não for nulo, atualize o documento existente.
        await _firestore
            .collection(collectionName)
            .doc(documentId)
            .update(data);
      } else {
        // Se documentId for nulo, adicione um novo documento à coleção.
        await _firestore.collection(collectionName).add(data);
      }
      log("Sucess putDocument");
    } catch (e) {
      throw 'Erro ao adicionar ou atualizar o documento: $e';
    }
  }

  static Future<void> removeDocument(
    String collectionName,
    String documentId,
  ) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
      log("Sucess removeDocument");
    } catch (e) {
      throw 'Erro ao remover o documento: $e';
    }
  }

  static Future<Map<String, dynamic>> getDocumentById(
    String collectionName,
    String documentId,
  ) async {
    DocumentReference documentReference =
        _firestore.collection(collectionName).doc(documentId);

    DocumentSnapshot documentSnapshot = await documentReference.get();

    return documentSnapshot.data() as Map<String, dynamic>;
  }
}
