import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../../Core/NavBar/navigation_bar.dart';

class SignUpController extends GetxController {
  // Obtém uma instância do SignUpController.
  static SignUpController get instance => Get.find();

  // Instância do banco de dados Firestore.
  final _db = FirebaseFirestore.instance;

  // Observáveis para controlar a visibilidade da senha e o status de carregamento do Google e Facebook.
  final showPassword = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  // Chave para acessar e validar o formulário de registro.
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // Instâncias do Firebase Auth e Firestore para autenticação e armazenamento de dados, respectivamente.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controladores de texto para obter e definir os valores dos campos do formulário.
  final fullName = TextEditingController();
  final emailController = TextEditingController();
  final phoneNo = TextEditingController();
  final password = TextEditingController();
  final cpf = TextEditingController();

  //* Observáveis para controlar o status de carregamento e se o usuário é um administrador.
  final isLoading = false.obs;
  final isAdmin = false.obs;

  //* Registra um novo usuário utilizando autenticação via [EmailAndPassword]
  Future<void> createUser(String email) async {
    try {
      // Verifica se o e-mail já existe no sistema.
      if (await recordExist(email)) {
        throw "O e-mail informado já possui um cadastro";
      } else {
        isLoading.value = true; // Indica que o processo de registro começou.

        // Valida o formulário.
        if (!signupFormKey.currentState!.validate()) {
          isLoading.value = false;
          return;
        }

        // Instância do repositório de autenticação.
        final auth = AuthenticationRepository();

        // Registra o usuário no Firebase usando e-mail e senha.
        await auth.registerWithEmailAndPassword(
          emailController.text.trim(),
          password.text.trim(),
        );

        // Insere os detalhes do usuário no Firestore.
        await _firestore.collection('Users').doc(_auth.currentUser!.uid).set({
          "id": _auth.currentUser!.uid,
          "E-mail": emailController.text.trim(),
          "Nome Completo": fullName.text.trim(),
          "Numero de Telefone": phoneNo.text.trim(),
          "CPF": cpf.text.trim(),
          "Admin": isAdmin.value = false,
        }).catchError(
          (e) => log('Erro ao criar coleção: $e'),
        );

        // Define a tela inicial após o registro bem-sucedido.
        auth.setInitialScreen(auth.firebaseUser);

        // Navega para a tela principal.
        Get.to(() => const MyNavigationBar());
      }
    } catch (e) {
      // Interrompe o carregamento e mostra o erro.
      isLoading.value = false;
      Get.snackbar(
        'Erro',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
      );
      log(e.toString());
    }
  }

  //* Verifica se um registro do usuário já existe usando um e-mail específico.
  Future<bool> recordExist(String email) async {
    try {
      // Busca no Firestore um usuário com o e-mail fornecido.
      final snapshot =
          await _db.collection("Users").where("E-mail", isEqualTo: email).get();
      // Retorna verdadeiro se um registro existente foi encontrado, caso contrário, falso.
      return snapshot.docs.isEmpty ? false : true;
    } catch (e) {
      throw "Erro ao buscar registro.";
    }
  }

  // /// [PhoneNumberAuthentication]
  // Future<void> phoneAuthentication(String phoneNo) async {
  //   try {
  //     await AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  //   } on Exception catch (e) {
  //     throw e.toString();
  //   }
  // }
}
