import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../Constants/colors.dart';
import '../../../Category/models/category.dart';
import '../../../Category/provider/firestore_provider.dart';
import '../../model/chamados_model.dart';
import '../../Controller/chamados_controller.dart';
import '../../Widgets/chamados_widget.dart';
import '../../Widgets/report_detail_screen.dart';
import '../chamados_screen.dart';
import 'Widgets/search_handler.dart';
import 'Widgets/serach_button.dart';

class AdminChamados extends StatefulWidget {
  const AdminChamados({super.key, required this.widget});

  final ChamadosScreen widget;

  @override
  State<AdminChamados> createState() => _AdminChamadosState();
}

class _AdminChamadosState extends State<AdminChamados> {
  final searchBar = TextEditingController();
  final SearchHandler searchHandler = SearchHandler();
  List<ReportingModel> searchResults = [];
  List<String> categories = [];
  final isSelected = TextEditingController();

  Future<void> _loadCategories() async {
    List<String> categories =
        await FirestoreProvider.getDocuments('categories');
    setState(() {
      categories = categories;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Função para lidar com a pesquisa
  void handleSearch(String query) async {
    try {
      // Chama a função para pesquisar relatórios com base na consulta
      final results = await searchHandler.searchReports(
        query.trim(),
      );
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      log('Erro do handle: $e');
    }
  }

  // Função para limpar a pesquisa
  void clearSearch() {
    // Limpa o texto da barra de pesquisa
    searchBar.clear();
    setState(() {
      // Limpa os resultados da pesquisa
      searchResults = [];
    });
  }

  void clearSearchCategory(isSelected) {
    setState(() {
      // Limpa os resultados da pesquisa
      isSelected.text = isSelected;
      searchResults = [];
    });
  }

  // Função para atualizar os resultados da pesquisa após filtragem
  void onFiltered(List<ReportingModel> filteredResults) {
    setState(() {
      searchResults = filteredResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onFieldSubmitted: handleSearch,
          controller: searchBar,
          decoration: InputDecoration(
            labelText: 'Pesquisar',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: clearSearch,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // Botões de Filtro
        StreamBuilder(
          stream: FirestoreProvider.getdocumentsStream('categories'),
          builder: (context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar dados: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Nenhuma categoria encontrada.'),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
                child: Row(
                  children: [
                    Wrap(
                      spacing: 8.0, // espaço horizontal entre os botões
                      runSpacing: 4.0, // espaço vertical entre os botões
                      children: snapshot.data!.map(
                        (category) {
                          return FilterButton(
                            category: category.name,
                            onFiltered: onFiltered,
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Expanded(
          child: searchResults.isEmpty
              ? StreamBuilder<QuerySnapshot>(
                  stream: ReportController().adminStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text(
                          'Nenhum dado disponível',
                          style: TextStyle(color: whiteColor),
                        ),
                      );
                    }
                    final reportList = snapshot.data!.docs.map(
                      (doc) {
                        return ReportingModel.fromSnapshot(
                          doc as QueryDocumentSnapshot<Map<String, dynamic>>,
                        );
                      },
                    ).toList();
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final report = reportList[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => ReportDetailScreen(
                                reportingModel: report,
                              ),
                            );
                          },
                          child: ChamadosWidget(report),
                        );
                      },
                      itemCount: reportList.length,
                    );
                  },
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final report = searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ReportDetailScreen(
                            reportingModel: report,
                          ),
                        );
                      },
                      child: ChamadosWidget(report),
                    );
                  },
                  itemCount: searchResults.length,
                ),
        ),
      ],
    );
  }
}
