import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputAddress extends StatelessWidget {
  const InputAddress({super.key, required this.address});

  final TextEditingController address;

  // Método para obter a localização atual do usuário.
  Future<loc.LocationData?> getCurrentLocation() async {
    // Inicializa o objeto de localização (com alias 'loc').
    loc.Location location = loc.Location();

    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData? locationData;

    // Verifica se o serviço de localização está ativado.
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // Solicita ao usuário que ative o serviço de localização.
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    // Verifica as permissões para acessar a localização.
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      // Solicita ao usuário permissão para acessar a localização.
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }

    // Obtém a localização atual.
    locationData = await location.getLocation();
    return locationData;
  }

  // Método para obter o endereço completo com base na latitude e longitude fornecidas.
  Future<String> getAddress(double latitude, double longitude) async {
    try {
      // Busca os detalhes do endereço a partir das coordenadas.
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        // Retorna o nome da rua ou avenida.
        return '${pos.thoroughfare}';  
      }
      return "Endereço não disponível";
    } catch (e) {
      // Em caso de erro, retorna a mensagem de erro.
      return "Erro: ${e.toString()}";
    }
  }

  // Método para preencher automaticamente o endereço com base na localização atual.
  Future<void> fillAddress() async {
    // Obtém a localização atual.
    loc.LocationData? locationData = await getCurrentLocation();
    if (locationData != null) {
      double? latitude = locationData.latitude;
      double? longitude = locationData.longitude;
      if (latitude != null && longitude != null) {
        // Se a latitude e a longitude forem válidas, busca o endereço e define no `TextEditingController`.
        String addressText = await getAddress(latitude, longitude);
        address.text = addressText;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Endereço',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(6),
        InputTextField(
          controller: address,
          keyBoardType: TextInputType.streetAddress,
          hintText: 'Preencha seu endereço aqui',
          maxLines: 1,
          obscureText: false,
          onValidator: (value) {
            // Verifica se o endereço está em branco.
            return value.isBlank ? 'Insira um endereço' : null;
          },
          suffixIcon: IconButton(
            icon: const Icon(Icons.location_searching_rounded),
            onPressed: () => fillAddress(),
          ),
        ),
      ],
    );
  }
}
