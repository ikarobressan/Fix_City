// Importações necessárias para o funcionamento da classe.
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../Repository/AuthenticationRepository/Exceptions/exceptions.dart';
import '../../../../Repository/UserRepository/user_repository.dart';
import '../../../Authentication/Models/user_model.dart';

class UserController extends GetxController {
  // Inicializa a autenticação via FirebaseAuth.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Inicializa a referência do Firestore.
  final _db = FirebaseFirestore.instance;

  // Define uma variável reativa do tipo UserModel. Esta variável irá armazenar os detalhes do usuário.
  final _user = Rxn<UserModel>();

  // Getter que retorna o valor atual do usuário.
  UserModel? get currentUser => _user.value;

  @override
  void onInit() {
    super.onInit();
    // Carrega os dados do usuário assim que o controlador é inicializado.
    _loadUserData();
  }

  /// Função para obter os detalhes de um usuário usando seu UID.
  Future<UserModel?> getUserDetailsById(String uid) async {
    try {
      // Busca os dados do usuário no Firestore usando o UID fornecido.
      final snapshot = await _db.collection("Users").doc(uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        UserModel user = UserModel.fromSnapshot(snapshot);
        // Atualiza o valor de _user com os detalhes do usuário.
        _user.value = user;
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Trata exceções específicas do FirebaseAuth.
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      // Trata exceções gerais do Firebase.
      throw e.message.toString();
    } catch (e) {
      // Trata exceções genéricas e retorna uma mensagem de erro.
      throw e.toString().isEmpty
          ? 'Something went wrong. Please Try Again'
          : e.toString();
    }
  }

  /// Stream que observa as mudanças nos dados do usuário.
  Stream<UserModel?> get userStream {
    return _db.collection("Users").doc(_auth.currentUser!.uid).snapshots().map(
          (snapshot) => snapshot.exists && snapshot.data() != null
              ? UserModel.fromSnapshot(snapshot)
              : null,
        );
  }

  // Função privada para carregar os dados do usuário atualmente autenticado.
  void _loadUserData() async {
    try {
      UserModel? user = await UserRepository.instance
          .getUserDetailsById(_auth.currentUser!.uid);
      // Atualiza o valor de _user com os detalhes do usuário.
      _user.value = user;
      // Notifica os ouvintes sobre a atualização.
      update();
    } catch (e) {
      log('Erro ao obter dados do usuário: $e');
    }
  }
}
