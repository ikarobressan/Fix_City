import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Features/Authentication/Models/user_model.dart';
import '../../Features/Authentication/Screens/UpdateOrRegister/update_or_register_screen.dart';
import '../../Features/Authentication/Screens/Welcome/home_page.dart';
import '../../Features/Core/NavBar/navigation_bar.dart';
import '../../Utils/Helper/helper_controller.dart';
import 'Exceptions/exceptions.dart';
import 'Result/login_result.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //* Variavéis
  Rx<User?> _firebaseUser = Rx<User?>(null);
  final _auth = FirebaseAuth.instance;
  final phoneVerificationId = ''.obs;
  final firestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    setInitialScreen(_firebaseUser.value);
    // ever(_firebaseUser, _setInitialScreen);
  }

  //* Getters
  User? get firebaseUser => _firebaseUser.value;
  String get getUserID => firebaseUser?.uid ?? "";
  String get getUserEmail => firebaseUser?.email ?? "";
  String get getDisplayName => firebaseUser?.displayName ?? "";
  String get getPhoneNo => firebaseUser?.phoneNumber ?? "";

  setInitialScreen(User? user) async {
    user == null
        ? Get.offAll(() => const WelcomeScreen())
        : Get.offAll(() => const MyNavigationBar());
  }

  //* ---------------------------- Autenticação por Email e Senha ---------------------------------*//

  //* Método para verificar se o login falhou devido a credenciais inválidas
  bool isInvalidCredentialsError(FirebaseAuthException e) {
    // O código de erro 'user-not-found' indica que o e-mail não foi encontrado
    // O código de erro 'wrong-password' indica que a senha está incorreta
    return e.code == 'user-not-found' || e.code == 'wrong-password';
  }

  /// [EmailAuthentication] - LOGIN
  Future<MyLoginResult> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return MyLoginResult.success();
    } on FirebaseAuthException catch (e) {
      if (isInvalidCredentialsError(e)) {
        return MyLoginResult.failure(
          'Verifique o e-mail ou a senha e tente novamente.',
        );
      } else {
        final result = MyExceptions.fromCode(e.code);
        throw result.message;
      }
    } catch (e) {
      log('Erro ao efetuar o login com e-mail: $e');
      const result = MyExceptions();
      throw result.message;
    }
  }

  /// [EmailAuthentication] - REGISTRO
  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      log('Erro ao registrar usuário: $e');
      const ex = MyExceptions();
      throw ex.message;
    }
  }

  /// [EmailVerification] - VERIFICAÇÃO DE E-MAIL
  Future<void> sendEmailVerification() async {
    try {
      // Verificando o estado do usuário antes de enviar o e-mail
      if (_auth.currentUser != null && !_auth.currentUser!.emailVerified) {
        await _auth.currentUser?.sendEmailVerification();
      } else {
        throw const MyExceptions();
      }
    } on FirebaseAuthException catch (e) {
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      log('Erro ao enviar e-mail de verificação: $e');
      const ex = MyExceptions();
      throw ex.message;
    }
  }

  //* ---------------------------- LOGIN Social ---------------------------------*//

  /// [GoogleAuthentication] - GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    GoogleSignInAccount? google;
    try {
      // Aciona a autenticação do Google
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      google = googleUser;
    } catch (e) {
      log('Erro de autenticação com Google: $e');
      rethrow;
    }

    try {
      // Obtem detalhes da requisição
      final GoogleSignInAuthentication? googleAuth =
          await google?.authentication;

      // Cria uma nova credencial
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Redirecionar para MyNavigationBar após o login bem-sucedido
      Get.to(() => const MyNavigationBar());

      // Uma vez conectado, retorne o UserCredential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('Erro com Firestore na criação de usuário com Google: $e');
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      log('Erro de autenticação de usuário com Google: $e');
      const ex = MyExceptions();
      throw ex.message;
    }
  }

  ///[FacebookAuthentication] - FACEBOOK
  Future<UserCredential> signInWithFacebook() async {
    try {
      // Aciona o fluxo de Login
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email'],
      );

      // Crie uma credencial a partir do token de acesso
      final AccessToken accessToken = loginResult.accessToken!;
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(accessToken.token);

      // Uma vez conectado, retorne o UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      log('Erro ao logar com o facebook: $e');
      throw 'Algo saiu errado. Tente novamente!';
    }
  }

  Future<void> resetPasswordEmail(String email) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      // Removido o .then e usando await
      await auth.sendPasswordResetEmail(email: email).then(
            (value) => log('E-mail enviado'),
          );
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } catch (e) {
      log('Erro ao enviar email de recuperação de senha: $e');
      const result = MyExceptions();
      throw result.message;
    }
  }

  //? Desloga o usuário do aplicativo
  /// [LogoutUser] - Valido para qualquer autenticação.
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      //await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      log('Erro ao deslogar: $e');
      throw 'Não foi possível sair. Tente novamente.';
    }
  }

  /// [PhoneAuthentication] - LOGIN
  /*loginWithPhoneNo(String phoneNumber) async {
    try {
      await _auth.signInWithPhoneNumber(phoneNumber);
    } on FirebaseAuthException catch (e) {
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Um erro desconhecido ocorreu. Tente novamente!'
          : e.toString();
    }
  }*/

  /// [PhoneAuthentication] - REGISTRO
  Future<void> phoneAuthentication(String phoneNo) async {
    try {
      //Verifica se o número de telefone ja está associado a uma conta.
      final isRegistered = await isPhoneNumberRegistered(phoneNo);
      log('Está registrado: $isRegistered');

      if (isRegistered) {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNo,
          verificationCompleted: (credential) async {
            await _auth.signInWithCredential(credential);
          },
          codeSent: (verificationId, resendToken) {
            phoneVerificationId.value = verificationId;
          },
          codeAutoRetrievalTimeout: (verificationId) {
            phoneVerificationId.value = verificationId;
          },
          verificationFailed: (e) {
            log('Erro de verificação: $e');
            final result = MyExceptions.fromCode(e.code);
            throw result.message;
          },
        );
      } else {
        /// Se não estiver associado, exibe uma tela informando ao usuário
        /// para atualizar os dados ou criar uma conta.
        Get.to(() => const UpdateOrRegisterScreen());
      }
    } on FirebaseAuthException catch (e) {
      log('Erro do Firebase Auth Execeptions: $e');
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } catch (e) {
      log('Erro: $e');
      throw e.toString().isEmpty
          ? 'Um erro desconhecido ocorreu. Tente novamente!'
          : e.toString();
    }
  }

  Future<bool> isPhoneNumberRegistered(String phoneNo) async {
    try {
      // Buscar o número de telefone na coleção 'Users'
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Numero de Telefone', isEqualTo: phoneNo)
          .get();

      // Se encontrarmos algum documento com esse número de telefone, retornamos verdadeiro
      if (querySnapshot.docs.isNotEmpty) {
        final UserModel user = UserModel.fromSnapshot(querySnapshot.docs.first);
        // Aqui você pode logar ou fazer qualquer coisa com o usuário, se necessário.
        log('User Found: ${user.phoneNo}');
        return true;
      }

      return false;
    } on FirebaseException catch (e) {
      log('Erro da Firestore: $e');
      throw 'Erro da Firestore: $e';
    } catch (e) {
      log("Erro ao verificar o número de telefone: $e");
      return false;
    }
  }

  /// [PhoneAuthentication] - VERIFICA O NUMERO DE TELEFONE VIA OTP
  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: phoneVerificationId.value,
        smsCode: otp,
      ),
    );
    return credentials.user != null ? true : false;
  }

  /// Updates the user's password
  Future<void> resetPasswordWithOTP(
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      // Validação das senhas
      if (newPassword != confirmPassword) {
        throw const MyExceptions('As senhas não coincidem.');
      }
      if (newPassword.length < 8) {
        Helper.validatePassword(newPassword);
      }

      // Atualizar a senha
      if (_firebaseUser.value != null) {
        await _firebaseUser.value!.updatePassword(newPassword);
      } else {
        throw const MyExceptions('Erro ao atualizar a senha.');
      }
    } on FirebaseAuthException catch (e) {
      log('Erro do FirebaseAuthException: $e');
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      log('Erro na redefinição de senha: $e');
      throw e.toString();
    }
  }
}
