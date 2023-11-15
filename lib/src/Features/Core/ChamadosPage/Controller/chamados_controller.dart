import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/chamados_model.dart';
import '../model/generate_report_id.dart';

// Classe para gerenciar operações relacionadas aos chamados
class ReportController extends GetxController {
  // Inicializações das instâncias do Firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser;

  //! Define nomes de coleções do Firestore como constantes
  static const usersCollection = 'Users';
  static const chamadosCollection = 'Chamados';

  // Função para construir o caminho do arquivo no armazenamento
  String buildFilePath(
    String baseFolder,
    String userName,
    String fileName,
    int chamadoNumber,
  ) {
    final chamadoFolder = 'Chamado${chamadoNumber.toString().padLeft(3, '0')}';
    return '$baseFolder/$userName/$chamadoFolder/$fileName';
  }

  //* Método para fazer upload de arquivos (imagens e vídeos) para o Firebase Storage
  Future<String?> uploadFile(String fileName, String filePath) async {
    if (filePath.isEmpty) {
      return null;
    }

    File file = File(filePath);

    try {
      // Cria uma referência no Firebase Storage para salvar o arquivo
      final ref = _firebaseStorage.ref().child('path_to_save/$fileName');
      await ref.putFile(file);

      // Obter a URL do arquivo após o upload
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // Exibe uma notificação de erro caso ocorra alguma falha
      Get.snackbar('Erro', 'Erro ao fazer o upload do arquivo.');
      return null;
    }
  }

  // Função para fazer upload de vários arquivos e salvar o relatório no Firestore
  Future<Map<String, String?>> uploadFilesAndSaveReport(
    PlatformFile imageFile,
    PlatformFile? videoFile,
    String userName,
  ) async {
    try {
      final chamadoNumber = await getChamadoNumberForUser(userName);

      // Constrói os caminhos dos arquivos para o armazenamento
      final imagePath = buildFilePath(
        'Chamados',
        userName,
        imageFile.name,
        chamadoNumber,
      );
      final videoPath = videoFile != null
          ? buildFilePath(
              'Chamados',
              userName,
              videoFile.name,
              chamadoNumber,
            )
          : null;

      // Faz upload dos arquivos e obtém suas URLs
      final imageUrl = await uploadFile(imagePath, imageFile.path!);
      final videoUrl = videoFile != null
          ? await uploadFile(videoPath!, videoFile.path!)
          : null;

      if (imageUrl == null) {
        throw Exception("Erro ao fazer upload da imagem.");
      }

      // Retorna um mapa com as URLs dos arquivos
      return {
        'imagemChamado': imageUrl,
        'videoChamado': videoUrl,
      };
    } catch (e) {
      // Registra e notifica sobre qualquer erro ocorrido
      log('Erro ao fazer upload dos arquivos: $e');
      Get.snackbar('Erro', 'Erro ao fazer upload dos arquivos selecionados.');
      rethrow;
    }
  }

  // Função para obter o nome completo do usuário com base no ID do usuário
  Future<String?> getUserName(String userId) async {
    // Busca o documento do usuário no Firestore pelo seu ID
    DocumentSnapshot userDoc =
        await _firestore.collection(usersCollection).doc(userId).get();

    // Converte os dados do documento em um mapa
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

    // Verifica se o documento contém um campo 'Nome Completo' e retorna seu valor
    if (userData != null && userData.containsKey('Nome Completo')) {
      return userData['Nome Completo'];
    }

    // Se não encontrar o campo 'Nome Completo', retorna null
    return null;
  }

// Função para obter o número de chamados feitos por um usuário
  Future<int> getChamadoNumberForUser(String userName) async {
    try {
      //+ Faz uma consulta no Firestore para contar quantos chamados o usuário já fez
      int existingChamados = await _firestore
          .collection(usersCollection)
          .doc(userName)
          .collection(chamadosCollection)
          .get()
          .then((snapshot) => snapshot.docs.length);

      // Retorna o número de chamados existentes + 1
      return existingChamados + 1;
    } catch (e) {
      // Registra o erro no console e relança a exceção
      log('Erro ao obter o número do chamado: $e');
      rethrow; // Re-lança a exceção para ser tratada em outro lugar, se necessário
    }
  }

  //? Função para salvar um novo chamado na coleção do usuário no Firestore.
  Future<void> addNewReport(
    String address,
    String cep,
    String referPoint,
    String addressNumber,
    String description,
    String category,
    String definicaoCategoria,
    double? longitudeReport,
    double? latitudeReport, {
    PlatformFile? imageFile,
    PlatformFile? videoFile,
    String? messageString,
    String statusMessage = 'Enviado',
    bool showMessage = false,
    bool isDone = false,
  }) async {
    // Seção para validar os dados inseridos pelo usuário.
    try {
      // Obtem o nome do usuário pelo seu ID.
      String? userName = await getUserName(user!.uid);

      Map<String, String?> fileUrls = {};

      // Se o nome do usuário e o arquivo de imagem forem válidos, faz upload dos arquivos.
      if (userName != null && imageFile != null) {
        fileUrls = await uploadFilesAndSaveReport(
          imageFile,
          videoFile,
          userName,
        );
      } else {
        throw Exception("Erro ao obter o nome do usuário.");
      }

      // Define a data e hora atual e gera um ID para o chamado.
      DateTime dateTime = DateTime.now();
      final chamadoId = GenerateReportId.generateRandomNumber();
      //final chamadoId = await ReportingModel.generateReportId();

      // Cria um novo modelo de chamado com os dados fornecidos.
      final report = ReportingModel(
        chamadoId: chamadoId,
        userId: user!.uid,
        isDone: isDone,
        address: address,
        cep: cep,
        referPoint: referPoint,
        addressNumber: addressNumber,
        description: description,
        category: category,
        date: dateTime,
        statusMessage: statusMessage,
        messageString: messageString ?? '',
        definicaoCategoria: definicaoCategoria,
        showMessage: showMessage,
        imageFile: fileUrls['imagemChamado'] ?? 'imagem não disponivel',
        videoFile: fileUrls['videoChamado'] ?? 'vídeo não disponivel',
        locationReport: GeoPoint(latitudeReport!, longitudeReport!),
      );

      // Salva o chamado no Firestore sob a coleção de chamados
      DocumentReference documentReference =
          _firestore.collection(chamadosCollection).doc(chamadoId);

      await documentReference.set(report.toMap());

      Get.snackbar(
        'Sucesso!',
        'Chamado enviado com sucesso. ID: $chamadoId',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao enviar o chamado: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  // StreamController para lidar com os chamados de um usuário específico.
  final StreamController<QuerySnapshot> _streamController =
      StreamController.broadcast();

  // StreamController para lidar com todos os chamados (para admin).
  final StreamController<QuerySnapshot> _adminStreamController =
      StreamController.broadcast();

  //? Stream para ouvir as atualizações de todos os chamados (para admin).
  Stream<QuerySnapshot> adminStream() {
    // Configura um listener no Firestore para todos os chamados.
    _firestore.collection(chamadosCollection).snapshots().listen(
      (data) {
        // Quando novos dados são recebidos, adiciona-os ao StreamController.
        _adminStreamController.add(data);
      },
      onError: (error) {
        // Em caso de erro, adiciona o erro ao StreamController.
        _adminStreamController.addError(error);
      },
    );

    // Retorna o stream para ser ouvido por outros componentes ou widgets.
    return _adminStreamController.stream;
  }

  //? Função para priorizar documentos com a categoria 'Árvore Caída'.
  List<QueryDocumentSnapshot> prioritizeDocs(List<QueryDocumentSnapshot> docs) {
    // Listas para armazenar documentos de acordo com a categoria.
    final arvoreCaidaDocs = <QueryDocumentSnapshot>[];
    final otherDocs = <QueryDocumentSnapshot>[];

    // Iterar por cada documento.
    for (final doc in docs) {
      // Se a categoria do documento é 'Árvore Caída', adiciona à lista arvoreCaidaDocs.
      if (doc['Categoria'] == 'Árvore Caída') {
        arvoreCaidaDocs.add(doc);
      } else {
        // Caso contrário, adiciona à lista otherDocs.
        otherDocs.add(doc);
      }
    }
    // Retorna os documentos de 'Árvore Caída' primeiro, seguidos por outros documentos.
    return [...arvoreCaidaDocs, ...otherDocs];
  }

  //? Função chamada ao fechar o controller; fecha os StreamControllers.
  @override
  void onClose() {
    // Fechar o StreamController relacionado ao usuário.
    _streamController.close();
    // Fechar o StreamController relacionado ao admin.
    _adminStreamController.close();
    super.onClose();
  }

  //? Função para buscar os chamados feitos por um usuário específico do Firestore.
  Future<List<ReportingModel>> fetchUserReports() async {
    try {
      // Consulta ao Firestore para buscar chamados do usuário atual.
      final querySnapshot = await _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(chamadosCollection)
          .get();

      // Mapeia os documentos retornados para o modelo ReportingModel.
      return querySnapshot.docs.map(
        (doc) {
          final data = doc.data();
          return ReportingModel.fromMap(data);
        },
      ).toList();
    } catch (e) {
      // Loga qualquer erro que ocorrer.
      log(e.toString());
      return [];
    }
  }

  //? Função para buscar todos os chamados (para admin) do Firestore.
  Future<List<ReportingModel>> fetchAdminReports() async {
    try {
      // Consulta ao Firestore para buscar todos os chamados.
      final querySnapshot =
          await _firestore.collection(chamadosCollection).get();

      // Mapeia os documentos retornados para o modelo ReportingModel.
      return querySnapshot.docs.map(
        (doc) {
          final data = doc.data();
          return ReportingModel.fromMap(data);
        },
      ).toList();
    } catch (e) {
      // Loga qualquer erro que ocorrer.
      log(e.toString());
      return [];
    }
  }

  // Método para buscar um chamado pelo seu ID e editar seus atributos.
  Future<void> fetchAndEditReport(
    String chamadoId, {
    //? Parâmetros opcionais para os novos valores dos atributos do chamado.
    String? newAddress,
    String? newCep,
    String? newReferPoint,
    String? newAddressNumber,
    String? newDescription,
    String? newCategory,
    String? newCategoryString,
    String? newStatusMessage,
    bool? newShowMessage,
    bool? newIsDone,
  }) async {
    try {
      // Referência do documento do chamado no Firestore.
      final docRef = _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(chamadosCollection)
          .doc(chamadoId);

      // Busca o chamado pelo seu ID.
      DocumentSnapshot docSnapshot = await docRef.get();

      // Verifica se o chamado existe.
      if (!docSnapshot.exists || docSnapshot.data() == null) {
        log('Erro: Chamado não encontrado.');
        return;
      }

      // Converte os dados do chamado em um modelo de chamado.
      ReportingModel report =
          ReportingModel.fromMap(docSnapshot.data() as Map<String, dynamic>);

      // Atualiza os atributos do chamado com os novos valores fornecidos.
      final updatedReport = report.copyWith(
        address: newAddress ?? report.address,
        cep: newCep ?? report.cep,
        referPoint: newReferPoint ?? report.referPoint,
        addressNumber: newAddressNumber ?? report.addressNumber,
        description: newDescription ?? report.description,
        category: newCategory ?? report.category,
        definicaoCategoria: newCategoryString ?? report.definicaoCategoria,
        statusMessage: newStatusMessage ?? report.statusMessage,
        showMessage: newShowMessage ?? report.showMessage,
        isDone: newIsDone ?? report.isDone,
      );

      // Salva o chamado atualizado no Firestore.
      await docRef.update(updatedReport.toMap());

      // Mostra uma notificação de sucesso.
      Get.snackbar(
        'Sucesso!',
        'Chamado atualizado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      log('Erro ao buscar ou editar o chamado: $e');
      Get.snackbar(
        'Erro',
        'Falha ao atualizar o chamado: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  // Método para buscar um chamado pelo seu ID.
  Future<ReportingModel?> getReportById(String reportId) async {
    try {
      // Busca o chamado pelo seu ID no Firestore.
      DocumentSnapshot docSnapshot =
          await _firestore.collection(chamadosCollection).doc(reportId).get();
      // Se o chamado existir, converte os dados em um modelo de chamado e o retorna.
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return ReportingModel.fromMap(
          docSnapshot.data() as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      log('Erro ao buscar o relatório: $e');
      return null;
    }
  }

  // Método para atualizar um chamado existente no Firestore.
  Future<void> updateReport(
    String reportId,
    Map<String, dynamic> updatedReport,
  ) async {
    try {
      // Referência ao documento do chamado na coleção principal de chamados.
      final docRef = _firestore.collection(chamadosCollection).doc(reportId);

      // Atualiza o chamado na coleção principal de chamados.
      await docRef.update(updatedReport);

      // Notifica o usuário sobre o sucesso da operação.
      Get.snackbar('Sucesso!', 'Chamado atualizado com sucesso');
    } catch (e) {
      log('Erro ao atualizar o chamado: $e');
      Get.snackbar('Erro', 'Falha ao atualizar o chamado: $e');
    }
  }

  // Método para atualizar a exibição da mensagem associada a um chamado.
  Future<void> updateDisplayMessage(String reportId, bool showMessage) async {
    try {
      // Atualiza a propriedade 'Exibir Mensagem' na coleção principal de chamados.
      await _firestore.collection(chamadosCollection).doc(reportId).update(
        {'Exibir Mensagem': showMessage},
      );

      // Obtém o ID do usuário associado ao chamado.
      final docSnapshot =
          await _firestore.collection(chamadosCollection).doc(reportId).get();
      final userId = docSnapshot.data()?['UserId'];

      if (userId != null) {
        // Atualiza a propriedade 'Exibir Mensagem' no documento do usuário associado.
        await _firestore
            .collection(usersCollection)
            .doc(userId)
            .collection(chamadosCollection)
            .doc(reportId)
            .update(
          {
            'Exibir Mensagem': showMessage,
          },
        );
      }
    } catch (e) {
      log('Erro ao atualizar a mensagem: $e');
      Get.snackbar('Erro', 'Falha ao atualizar a mensagem: $e');
    }
  }

  Future<String?> getChamadoImage(String chamadoId, String userId) async {
    try {
      // Consulta o Firestore para obter o chamado específico pelo chamadoId e userId.
      DocumentSnapshot chamadoSnapshot =
          await _firestore.collection('Chamados').doc(chamadoId).get();

      final data = chamadoSnapshot.data() as Map<String, dynamic>;

      // Retorna a URL da imagem se disponível.
      return data['Imagem do Chamado'] as String?;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String?> getChamadoVideo(String chamadoId, String userId) async {
    try {
      // Consulta o Firestore para obter o chamado específico pelo chamadoId e userId.
      DocumentSnapshot chamadoSnapshot =
          await _firestore.collection('Chamados').doc(chamadoId).get();

      final data = chamadoSnapshot.data() as Map<String, dynamic>;

      // Retorna a URL do vídeo se disponível.
      return data['Video do Chamado'] as String?;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
