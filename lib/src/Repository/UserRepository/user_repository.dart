import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../Features/Authentication/Models/user_model.dart';
import '../AuthenticationRepository/Exceptions/exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> createUser(UserModel user) async {
    try {
      if (await recordExist(user.email)) {
        throw "O e-mail informado já possui um cadastro";
      } else {
        log('========> $user');
        log('========> ${user.toJson()}');
        DocumentReference docRef =
            await _db.collection("Users").add(user.toJson());
        // Retorna o ID do documento criado
        log('Docuemnto do usuário: $docRef');
        return docRef.id;
      }
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Algo deu errado. Por favor, tente novamente'
          : e.toString();
    }
  }

  Future<String> createUserWithGoogle(UserModel user) async {
    try {
      // Verificar se o usuário já existe baseado no e-mail
      if (await recordExist(user.email)) {
        throw "O e-mail informado já possui um cadastro";
      } else {
        // Obter uma referência ao documento que você quer adicionar/definir
        DocumentReference docRef = _db.collection("Users").doc(user.id);

        // Adicionar o UserModel ao Firestore
        await docRef.set(user.toJson());

        log('Documento do usuário pelo google: ${docRef.id}');

        // Retorna o ID do documento criado
        return docRef.id;
      }
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Algo deu errado. Por favor, tente novamente'
          : e.toString();
    }
  }

  Future<UserModel> getUserDetails(String email) async {
    try {
      final snapshot =
          await _db.collection('Users').where('E-mail', isEqualTo: email).get();
      if (snapshot.docs.isEmpty) throw 'Nenhum usuário encontrado';
      final userData =
          snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
      return userData;
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Algo deu errado. Por favor, tente novamente'
          : e.toString();
    }
  }

  Future<UserModel> getUserNameDetails(String name) async {
    try {
      final snapshot = await _db
          .collection('Users')
          .where('Nome Completo', isEqualTo: name)
          .get();
      if (snapshot.docs.isEmpty) throw 'Nenhum usuário encontrado';
      final userData =
          snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
      return userData;
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Algo deu errado. Por favor, tente novamente'
          : e.toString();
    }
  }

  Future<List<UserModel>> allUsers() async {
    try {
      final snapshot = await _db.collection("Users").get();
      final users =
          snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
      return users;
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      log('Erro ao obter os usuários: $e');
      throw 'Algo deu errado. Por favor, tente novamente';
    }
  }

  Future<void> updateUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).update(user.toJson());
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      log('Erro ao atualizar os dados: $e');
      throw 'Algo deu errado. Por favor, tente novamente';
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _db.collection("Users").doc(id).delete();
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      log('Erro ao apagar o usuário: $e');
      throw 'Algo deu errado. Por favor, tente novamente';
    }
  }

  Future<UserModel> getUserDetailsById(String uid) async {
    try {
      final snapshot = await _db.collection("Users").doc(uid).get();
      if (!snapshot.exists || snapshot.data() == null) {
        throw 'Nenhum usuário encontrado';
      }
      return UserModel.fromSnapshot(snapshot);
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Algo deu errado. Por favor, tente novamente'
          : e.toString();
    }
  }

  //* Verifica se o usuario existe com o email ou telefone informado
  Future<bool> recordExist(String email) async {
    try {
      final snapshot =
          await _db.collection("Users").where("E-mail", isEqualTo: email).get();
      return snapshot.docs.isEmpty ? false : true;
    } catch (e) {
      throw "Erro ao buscar registro.";
    }
  }
}
