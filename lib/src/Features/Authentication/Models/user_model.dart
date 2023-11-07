import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // Variáveis do modelo
  final String? id;
  final String? password;
  final String fullName;
  final String email;
  final String? phoneNo;
  final String? cpf;
  final bool isAdmin;

  /// Construtor para criar uma instância de UserModel.
  const UserModel({
    this.id,
    this.password,
    required this.email,
    required this.fullName,
    this.phoneNo,
    this.cpf,
    this.isAdmin = false,
  });

  /// Converte o modelo para um mapa (formato Json) para armazenar no Firebase.
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "Nome Completo": fullName,
      "E-mail": email,
      "Numero de Telefone": phoneNo,
      "CPF": cpf,
      "Admin": isAdmin,
    };
  }

  /// Retorna uma instância vazia de UserModel.
  static UserModel empty() => const UserModel(
        id: '',
        email: '',
        fullName: '',
        phoneNo: '',
        cpf: '',
        isAdmin: false,
      );

  /// Cria uma instância de UserModel mapeando os dados do snapshot do Firebase.
  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    
    // Verifica se os dados estão vazios e retorna um modelo vazio, se necessário.
    if (data == null || data.isEmpty) {
      return UserModel.empty();
    }

    // Verifica se a chave 'Admin' está presente e é do tipo bool.
    final adminValue = data['Admin'];
    final bool isAdmin = adminValue is bool ? adminValue : false;

    return UserModel(
      id: document.id,
      email: data["E-mail"] ?? '',
      fullName: data["Nome Completo"] ?? '',
      phoneNo: data["Numero de Telefone"] ?? '',
      cpf: data["CPF"] ?? '',
      isAdmin: isAdmin,
    );
  }
}
