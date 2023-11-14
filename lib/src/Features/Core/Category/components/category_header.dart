import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../views/category_form.dart';

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({super.key, required this.formattedDate});

  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Categorias',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                formattedDate,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // Exibir o botão apenas para usuários não administradores
        Column(
          children: [
            const Gap(10),
            ElevatedButton(
              onPressed: () {
                Get.to(() => CategoryForm());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '+ Criar Categoria ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
