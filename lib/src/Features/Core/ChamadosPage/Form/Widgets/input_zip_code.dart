import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputZipCode extends StatelessWidget {
  
  // Construtor que inicializa o widget com um `TextEditingController`.
  const InputZipCode({super.key, required this.cep});

  // Controlador para o campo de texto onde o CEP será inserido.
  final TextEditingController cep;

  // Método assíncrono para obter a localização atual do dispositivo.
  Future<loc.LocationData?> getCurrentLocation() async {
    // Instancia um novo objeto de localização.
    loc.Location location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData? locationData;

    // Verifica se o serviço de localização está habilitado.
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    // Verifica as permissões de localização.
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }

    // Obtém a localização atual.
    locationData = await location.getLocation();
    return locationData;
  }

  // Método assíncrono para obter o código postal (CEP) a partir de coordenadas geográficas.
  Future<String> getPostalCode(double latitude, double longitude) async {
    try {
      // Obtém uma lista de 'Placemark' a partir das coordenadas.
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        return pos.postalCode ?? "CEP não disponível";  // Retorna o CEP se disponível.
      }
      return "CEP não disponível";
    } catch (e) {
      return "Erro: ${e.toString()}";  // Retorna uma mensagem de erro se ocorrer algum problema.
    }
  }

  // Método para preencher automaticamente o campo CEP.
  Future<void> fillPostalCode() async {
    loc.LocationData? locationData = await getCurrentLocation();
    if (locationData != null) {
      double? latitude = locationData.latitude;
      double? longitude = locationData.longitude;
      if (latitude != null && longitude != null) {
        String postalCode = await getPostalCode(latitude, longitude);
        cep.text = postalCode;  // Define o CEP obtido no campo de texto.
      }
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
            // Título do campo de entrada.
            Text(
              'CEP',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        
        // Espaçamento vertical.
        const Gap(6),
        
        // Campo de entrada personalizado para inserção do CEP.
        InputTextField(
          controller: cep,
          keyBoardType: TextInputType.number,
          hintText: 'CEP',
          maxLines: 1,
          obscureText: false,
          // Função para validar a entrada. Retorna uma mensagem de erro se o valor for em branco.
          onValidator: (value) {
            return value.isBlank ? 'Insira o CEP' : null;
          },
          // Ícone de ação para preencher o CEP automaticamente.
          suffixIcon: IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              fillPostalCode();
            },
          ),
        ),
      ],
    );
  }
}
