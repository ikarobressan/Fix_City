import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/chamados_model.dart';

class SearchHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função para pesquisar relatórios com base em uma consulta
  Future<List<ReportingModel>> searchReports(String query) async {
    try {
      // Consulta todos os documentos na coleção 'Chamados'
      final QuerySnapshot snapshot =
          await _firestore.collection('Chamados').get();

      // Mapeia os documentos para objetos ReportingModel
      final List<ReportingModel> reports = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReportingModel.fromMap(data);
      }).toList();

      // Filtra os relatórios que contêm a consulta nos campos relevantes
      final filteredReports = reports.where((report) {
        return report.category!.toLowerCase().contains(query.toLowerCase()) ||
        report.description!.toLowerCase().contains(query.toLowerCase()) ||
        report.statusMessage!.toLowerCase().contains(query.toLowerCase());
      }).toList();

      // Retorna os relatórios filtrados
      return filteredReports; 
    } catch (e) {
      log('Erro ao pesquisar relatórios: $e');
      // Retorna uma lista vazia em caso de erro
      return []; 
    }
  }

  // Função para filtrar relatórios por categoria
  Future<List<ReportingModel>> filterReportsByCategory(String category) async {
    try {
      // Consulta documentos na coleção 'Chamados' com categoria igual à especificada
      final QuerySnapshot snapshot = await _firestore
          .collection('Chamados')
          .where('Categoria', isEqualTo: category)
          .get();

      // Mapeia os documentos para objetos ReportingModel
      final List<ReportingModel> reports = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReportingModel.fromMap(data);
      }).toList();

      // Retorna os relatórios filtrados por categoria
      return reports; 
    } catch (e) {
      log('Erro ao filtrar relatórios por categoria: $e');
      // Retorna uma lista vazia em caso de erro
      return []; 
    }
  }
}
