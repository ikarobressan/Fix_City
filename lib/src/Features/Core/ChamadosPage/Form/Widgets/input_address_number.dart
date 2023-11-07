import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
// Importando a biblioteca de localização com um alias 'loc' para evitar conflitos de nomes.
import 'package:location/location.dart' as loc;  
import '../../../../../Utils/Widgets/input_text_field.dart';

// Widget que permite ao usuário inserir um número de endereço e também obter o número de endereço com base na localização atual.
class InputAddressNumber extends StatelessWidget {
  
  // Construtor da classe que requer um `TextEditingController` para o número do endereço.
  const InputAddressNumber({super.key, required this.addressNumber});

  final TextEditingController addressNumber;

  // Método para obter o número da residência/comércio com base na latitude e longitude fornecidas.
  Future<String> getAddressWithHouseNumber(
      double latitude, double longitude) async {
    try {
      // Busca os detalhes do endereço a partir das coordenadas.
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        // Retorna o número do endereço.
        return '${pos.subThoroughfare}';  
      }
      return "Endereço não disponível";
    } catch (e) {
      // Em caso de erro, retorna a mensagem de erro.
      return "Erro: ${e.toString()}";  
    }
  }

  // Método para preencher automaticamente o número da residência/comércio com base na localização atual.
  Future<void> fillHouseNumber() async {
    // Inicializa o objeto de localização (com alias 'loc').
    loc.Location location = loc.Location();  

    // Verifica se o serviço de localização está ativado.
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Verifica as permissões para acessar a localização.
    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    // Busca a localização atual.
    loc.LocationData? locationData = await location.getLocation();
    double? latitude = locationData.latitude;
    double? longitude = locationData.longitude;

    if (latitude != null && longitude != null) {
      // Se a latitude e a longitude forem válidas, busca o número da residência/comércio e define no `TextEditingController`.
      String houseNumberText =
          await getAddressWithHouseNumber(latitude, longitude);
      addressNumber.text = houseNumberText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Espaçamento vertical.
        const Gap(12),  
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Número do Endereço',
              // Define o estilo do texto.
              style: Theme.of(context).textTheme.headlineMedium,  
            ),
          ],
        ),
        // Espaçamento vertical.
        const Gap(6),  
        InputTextField(
          controller: addressNumber,
          // Define o teclado como numérico.
          keyBoardType: TextInputType.number,
          // Placeholder para o campo de entrada. 
          hintText: 'Número do Endereço',  
          // Limita a entrada a uma única linha.
          maxLines: 1,
          // Não oculta o texto.
          obscureText: false,  
          onValidator: (value) {
            // Validação: Garante que o número do endereço não esteja em branco.
            return value.isBlank
                ? 'Insira um número de residencia ou comércio próximo'
                : null;
          },
          suffixIcon: IconButton(
            icon: const Icon(Icons.location_city_rounded),
            onPressed: () {
              // Ao pressionar o ícone, preenche o número da residência/comércio com base na localização e exibe um aviso.
              fillHouseNumber();
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Atenção'),
                  content: const Text(
                    'Por favor, verique se o número do endereço está correto.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Fecha o diálogo.
                        Navigator.pop(ctx);  
                      },
                      child: const Text('Okay'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
