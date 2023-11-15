import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// Define um formatador de data para o formato 'dd/MM/yyyy'
final formatter = DateFormat('dd/MM/yyyy');

// Instância de autenticação do Firebase
final FirebaseAuth _auth = FirebaseAuth.instance;

// Enum para categorias de problemas
// enum Category {
//   buracoRua,
//   buracoCalcada,
//   posteQueimado,
//   bueiroEntupido,
//   iluminacaoInadequada,
//   sinalizacaoInadequada,
//   lixoAcumulado,
//   vazamentoAgua,
//   obstrucaoVia,
//   arvoreCaida,
//   pichacao,
//   outro,
// }

// Obtém a data atual
DateTime currentDate = DateTime.now();

// Formata a data atual para o formato desejado
String formattedDate =
    "${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month}/${currentDate.year}";

// Extensão do enum Category para obter descrições humanas-legíveis
// extension CategoryExtension on Category {
//   String get categoryDescription {
//     switch (this) {
//       case Category.buracoRua:
//         return 'Buraco na rua';
//       case Category.buracoCalcada:
//         return 'Buraco na calçada';
//       case Category.posteQueimado:
//         return 'Luz do Poste Queimada';
//       case Category.bueiroEntupido:
//         return 'Bueiro Emtupido';
//       case Category.iluminacaoInadequada:
//         return 'Iluminação Inadequada';
//       case Category.sinalizacaoInadequada:
//         return 'Sinalização Inadequada';
//       case Category.lixoAcumulado:
//         return 'Lixo Acumulado';
//       case Category.vazamentoAgua:
//         return 'Vazamento de Água';
//       case Category.obstrucaoVia:
//         return 'Obstrução na Via';
//       case Category.arvoreCaida:
//         return 'Árvore Caída';
//       case Category.pichacao:
//         return 'Pichação';
//       case Category.outro:
//         return 'Outro';
//     }
//   }
// }

// // Função para mapear uma string para um enum de Categoria
// Category getCategoryFromString(String category) {
//   switch (category) {
//     case 'Buraco na rua':
//       return Category.buracoRua;
//     case 'Buraco na calçada':
//       return Category.buracoCalcada;
//     case 'Luz do Poste Queimada':
//       return Category.posteQueimado;
//     case 'Bueiro Entupido':
//       return Category.bueiroEntupido;
//     case 'Iluminação Inadequada':
//       return Category.iluminacaoInadequada;
//     case 'Sinalização Inadequada':
//       return Category.sinalizacaoInadequada;
//     case 'Lixo Acumulado':
//       return Category.lixoAcumulado;
//     case 'Vazamento de Água':
//       return Category.vazamentoAgua;
//     case 'Obstrução na Via':
//       return Category.obstrucaoVia;
//     case 'Árvore Caída':
//       return Category.arvoreCaida;
//     case 'Pichação':
//       return Category.pichacao;
//     case 'Outro':
//       return Category.outro;
//     default:
//       return Category.buracoRua; // Padrão para 'Buraco na rua'
//   }
// }

// Classe para representar um modelo de chaamdo
class ReportingModel {
  ReportingModel({
    this.chamadoId,
    this.userId, // Id do usuário
    this.isDone, // Concluido ou não [Visivel apenas se conluido]
    this.address, // Endereço
    this.cep, // CEP da rua
    this.addressNumber, // Número de residencia ou comercio próximo
    this.referPoint, // Tiutlo do chamado
    this.description, // Subtitulo do chamado
    this.category, // Categoria
    this.date, // Data
    this.statusMessage, // Status [Enviado, Analise, Andamento, Finalizado]
    this.definicaoCategoria, //& Definição manual do chamado
    this.showMessage, //! Exibir ou não a mensagem do admin
    this.messageString, //@ Mensagem do ADM
    this.imageFile,
    this.videoFile,
    this.locationReport,
    this.observationsAdmin,
  });

  final String? chamadoId;
  final String? userId;
  final bool? isDone;
  final String? address;
  final String? cep;
  final String? addressNumber;
  final String? referPoint;
  final String? description;
  final String? category;
  final String? definicaoCategoria;
  final DateTime? date;
  final String? statusMessage;
  final bool? showMessage;
  final String? messageString;
  final String? imageFile;
  final String? videoFile;
  final GeoPoint? locationReport;
  final dynamic observationsAdmin;

  String get formattedDate => formatter.format(date!);

  @override
  String toString() {
    return 'ReportingModel: {Categoria: $category, \nDefinição Categoria: $definicaoCategoria, \nPonto de Referencia: $referPoint, \nEndereço: $address, \nNumero do Endereço: $addressNumber, \nCEP: $cep, \nStatus do Chamado: $statusMessage}';
  }

  // Converter o modelo em um mapa para o Firebase Firestor
  Map<String, dynamic> toMap() {
    return {
      'Id do Chamado': chamadoId,
      'Id do Usuario': userId,
      'Concluido': isDone,
      'Endereco-Local': address,
      'CEP': cep,
      'Numero do Endereco': addressNumber,
      'Ponto de Referencia': referPoint,
      'Descricao': description,
      'Categoria': category,
      'Categoria do chamado': definicaoCategoria,
      'Data do Chamado': Timestamp.fromDate(date!),
      'Exibir Mensagem': showMessage,
      'Status do chamado': statusMessage,
      'Mensagem do Admin': messageString,
      'Imagem do Chamado': imageFile,
      'Video do Chamado': videoFile,
      'location_report': locationReport,
      'observations_admin': observationsAdmin
    };
  }

  // Método de fábrica para criar um ReportingModel a partir de um mapa
  factory ReportingModel.fromMap(Map<String, dynamic> map) {
    return ReportingModel(
      chamadoId: map['Id do Chamado'] ?? '',
      userId: map['Id do Usuario'] ?? '',
      isDone: map['Concluido'] ?? false,
      address: map['Endereco-Local'] ?? '',
      cep: map['CEP'] ?? '',
      addressNumber: map['Numero do Endereco'] ?? '',
      referPoint: map['Ponto de Referencia'] ?? '',
      description: map['Descricao'] ?? '',
      category: map['Categoria'] ?? '',
      definicaoCategoria: map['Categoria do chamado'] ?? '',
      date: (map['Data do Chamado'] as Timestamp).toDate(),
      showMessage: map['Exibir Mensagem'] ?? false,
      statusMessage: map['Status do chamado'] ?? '',
      messageString: map['Mensagem do Admin'],
      imageFile: map['Imagem do Chamado'] ?? '',
      videoFile: map['Video do Chamado'] ?? '',
      locationReport: map["location_report"] ?? '',
      observationsAdmin: map["observations_dmin"] ?? [{}]
    );
  }

  // Método de fábrica para criar um ReportingModel a partir de um snapshot de documento Firestore
  factory ReportingModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    log(data.toString());

    // Função para analisar e converter uma data em formato dinâmico para DateTime
    DateTime parseDate(dynamic input) {
      if (input == ''){
        return DateTime(1, 1, 1);
      }
      if (input is Timestamp) {
        // Se o input for do tipo Timestamp (Firestore), converte para DateTime e retorna
        return input.toDate();
      } else if (input is String) {
        // Se o input for do tipo String, divide a string em partes usando '/' como separador
        final parts = input.split('/');

        if (parts.length != 3) {
          // Verifica se existem três partes (dia, mês e ano)
          throw const FormatException('Formato de data inválido');
          // Lança uma exceção se o formato for inválido
        }

        final day = int.parse(parts[0]); // Extrai o dia da primeira parte
        final month = int.parse(parts[1]); // Extrai o mês da segunda parte
        final year = int.parse(parts[2]); // Extrai o ano da terceira parte

        // Cria um objeto DateTime e o retorna
        return DateTime(year, month, day);
      } else {
        // Se o input não for nem Timestamp nem String, lança uma exceção
        throw Exception(
            'Esperava Timestamp ou String, recebeu ${input.runtimeType}');
      }
    }

    // Se todos os campos estiverem presentes, continue a criação do modelo
    return ReportingModel(
      chamadoId: data['Id do Chamado'] ?? '',
      userId: data['Id do Usuario'] ?? '',
      isDone: data['Concluido'] ?? false,
      address: data['Endereco-Local'] ?? '',
      cep: data['CEP'] ?? '',
      referPoint: data['Ponto de Referencia'] ?? '',
      addressNumber: data['Numero do Endereco'] ?? '',
      description: data['Descricao'] ?? '',
      category: data['Categoria'] ?? '',
      definicaoCategoria: data['Categoria do chamado'] ?? '',
      date: parseDate(data['Data do Chamado'] ?? '') ,
      showMessage: data['Exibir Mensagem'] ?? false,
      statusMessage: data['Status do chamado'] ?? '',
      messageString: data['Mensagem do Admin'] ?? '',
      imageFile: data['Imagem do Chamado'] ?? '',
      videoFile: data['Video do Chamado'] ?? '',
      locationReport: data["location_report"] ?? '',
      observationsAdmin: data["observations_admin"] ?? [{}]
    );
  }

  // Função para criar uma cópia do objeto ReportingModel com a possibilidade de substituir propriedades específicas
  ReportingModel copyWith({
    String? userId, // Novo ID de usuário (opcional)
    bool? isDone, // Novo status de conclusão (opcional)
    String? name, // Novo nome (não utilizado no construtor original)
    String? address, // Novo endereço (opcional)
    String? cep, // Novo CEP (opcional)
    String? addressNumber, // Novo número de endereço (opcional)
    String? referPoint, // Novo ponto de referência (opcional)
    String? description, // Nova descrição (opcional)
    String? category, // Nova categoria (opcional)
    String? definicaoCategoria, // Nova definição de categoria (opcional)
    DateTime? date, // Nova data (opcional)
    String? statusMessage, // Nova mensagem de status (opcional)
    bool? showMessage, // Nova opção de exibição de mensagem (opcional)
    String? messageString, // Nova mensagem do administrador (opcional)
    String? imageFile, // Novo arquivo de imagem (opcional)
    String? videoFile, // Novo arquivo de vídeo (opcional)
  }) {
    return ReportingModel(
      chamadoId: chamadoId,
      userId: userId ?? this.userId,
      isDone: isDone ?? this.isDone,
      address: address ?? this.address,
      cep: cep ?? this.cep,
      addressNumber: addressNumber ?? this.addressNumber,
      referPoint: referPoint ?? this.referPoint,
      description: description ?? this.description,
      category: category ?? this.category,
      definicaoCategoria: definicaoCategoria ?? this.definicaoCategoria,
      date: date ?? this.date,
      statusMessage: statusMessage ?? this.statusMessage,
      showMessage: showMessage ?? this.showMessage,
      messageString: messageString ?? this.messageString,
      imageFile: imageFile ?? this.imageFile,
      videoFile: videoFile ?? this.videoFile,
    );
  }

  // Função assíncrona para gerar um novo ID para um chamado de relatório
  static Future<String> generateReportId() async {
    // Inicialização do Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Acesso à coleção de chamados do usuário atualmente autenticado
    final userCollection = firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('Chamados');

    // Inicialização da variável para armazenar o último número do chamado
    int lastUserNumber = 0;

    try {
      // Consulta o último chamado na coleção do usuário
      final userQuerySnapshot = await userCollection
          .orderBy('Id do Chamado', descending: true)
          .limit(1)
          .get();

      // Registra a consulta à coleção do usuário
      log('Consulta à coleção de usuário realizada: $userQuerySnapshot');

      if (userQuerySnapshot.docs.isNotEmpty) {
        // Obtém o ID do chamado mais recente
        final lastUserId =
            userQuerySnapshot.docs.first['Id do Chamado'] as String;

        // Extrai o número do chamado
        lastUserNumber = int.parse(lastUserId.replaceFirst('Chamado', ''));

        // Registra o último ID e número do chamado recuperados
        log('Último ID do chamado recuperado: $lastUserId');
        log('Último número do chamado recuperado: $lastUserNumber');
      } else {
        // Registra a ausência de chamados na coleção do usuário
        log('Nenhum chamado encontrado na coleção de usuário.');
      }

      // Gerar o próximo ID com base no último número do chamado
      String nextId =
          'Chamado${(lastUserNumber + 1).toString().padLeft(3, '0')}';

      // Registra o próximo ID gerado
      log('Próximo ID do chamado gerado: $nextId');

      return nextId; // Retorna o próximo ID gerado
    } catch (e) {
      // Registra e lança uma exceção em caso de erro
      log('Erro: $e');
      throw Exception('Erro ao gerar ID do chamado: $e');
    }
  }
}
