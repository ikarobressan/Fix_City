import 'package:flutter/material.dart';

import '../../model/chamados_model.dart';
import 'search_handler.dart';

class FilterButton extends StatelessWidget {
  final String category;
  final ValueChanged<List<ReportingModel>> onFiltered;

  // Construtor da classe FilterButton
  const FilterButton({
    super.key,
    required this.category,
    required this.onFiltered,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        // Chama a função para filtrar relatórios por categoria
        final results = await SearchHandler().filterReportsByCategory(category);
        onFiltered(results); // Atualiza os resultados exibidos
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      child: Text(
        category,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
