import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// Este widget é usado para mostrar um dropdown (menu suspenso) que permite ao usuário escolher se quer exibir uma mensagem.
class DisplayMessageDropdown extends StatefulWidget {
  
  // Construtor que requer o valor inicial do dropdown e uma função callback para tratar mudanças no dropdown.
  const DisplayMessageDropdown(
    this.initialValue,
    this.onChanged, {
    Key? key,
  }) : super(key: key);

  // O valor inicial do dropdown (Sim/Não).
  final bool initialValue;
  // Função callback para tratar mudanças de valor no dropdown.
  final ValueChanged<bool> onChanged;

  // Cria o estado para este widget.
  @override
  State<DisplayMessageDropdown> createState() => _DisplayMessageDropdownState();
}

class _DisplayMessageDropdownState extends State<DisplayMessageDropdown> {
  
  // Variável para armazenar o valor atualmente selecionado no dropdown.
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    // Inicializa o valor selecionado com base no valor inicial fornecido.
    _selectedValue = widget.initialValue ? 'Sim' : 'Não';
    // Registra o valor selecionado no log.
    log('Valor selecionado: $_selectedValue');
  }

  // Função para tratar mudanças de valor no dropdown.
  void _handleDropdownChanged(String? newValue) {
    log('Dropdown changed: $newValue');
    if (newValue != null) {
      setState(() {
        _selectedValue = newValue;
      });
      // Invoca a função callback com o novo valor.
      widget.onChanged(newValue == 'Sim');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construindo o widget.
    return Column(
      children: [
        // Um espaço entre os widgets.
        const Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Etiqueta "Exibir mensagem".
            Text(
              'Exibir mensagem: ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // Dropdown com opções "Sim" e "Não".
            DropdownButton<String>(
              value: _selectedValue,
              items: <String>['Sim', 'Não']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: _handleDropdownChanged,
            ),
          ],
        ),
      ],
    );
  }
}
