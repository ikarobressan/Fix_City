import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputAddress extends StatelessWidget {
  const InputAddress(
      {super.key,
      required this.address,
      required this.addressNumber,
      required this.cep,
      required this.referPoint,
      required this.latitudeReport,
      required this.longitudeReport,
      });

  final TextEditingController address;
  final TextEditingController addressNumber;
  final TextEditingController cep;
  final TextEditingController referPoint;
  final TextEditingController latitudeReport;
  final TextEditingController longitudeReport;

  // Método para obter a localização atual do usuário.
  Future<loc.LocationData?> getCurrentLocation() async {
    // Inicializa o objeto de localização (com alias 'loc').
    loc.Location location = loc.Location();

    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

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
    return await location.getLocation();
  }

  // Método para obter o endereço completo com base na latitude e longitude fornecidas.
  Future<Placemark> getAddress(double latitude, double longitude) async {
    try {
      // Busca os detalhes do endereço a partir das coordenadas.
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks[1];
      }
      throw "Endereço não disponível";
    } catch (e) {
      // Em caso de erro, retorna a mensagem de erro.
      throw "Erro: ${e.toString()}";
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
        latitudeReport.text = latitude.toString();
        longitudeReport.text = longitude.toString();
        Placemark addressPlacemark = await getAddress(latitude, longitude);
        address.text =
            '${addressPlacemark.thoroughfare} - ${addressPlacemark.subLocality}, ${addressPlacemark.subAdministrativeArea} - ${addressPlacemark.administrativeArea}';
        addressNumber.text = '${addressPlacemark.name}';
        cep.text = '${addressPlacemark.postalCode}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---------------------------------------------- ENDEREÇO
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Endereço',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton.icon(
              onPressed: () => fillAddress(),
              icon: const Icon(Icons.location_on, color: Colors.orangeAccent),
              label: Text(
                'Usar localização atual',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        const Gap(5),
        InputTextField(
          controller: address,
          keyBoardType: TextInputType.streetAddress,
          hintText: 'Endereço',
          obscureText: false,
          onValidator: (value) {
            return null;
          },
        ),
        // ---------------------------------------------- NÚMERO
        const Gap(15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Número',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(5),
        InputTextField(
          controller: addressNumber,
          keyBoardType: TextInputType.number,
          hintText: 'Número',
          obscureText: false,
          onValidator: (value) {
            return null;
          },
        ),
        // ---------------------------------------------- CEP
        const Gap(15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CEP',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(5),
        InputTextField(
          controller: cep,
          keyBoardType: TextInputType.number,
          hintText: 'CEP',
          obscureText: false,
          onValidator: (value) {
            return null;
          },
        ),
        // ---------------------------------------------- Ponto de referência
        const Gap(15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ponto de referência',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(5),
        InputTextField(
          controller: referPoint,
          keyBoardType: TextInputType.text,
          hintText: 'Ponto de referência',
          obscureText: false,
          onValidator: (value) {
            return null;
          },
        ),
      ],
    );
  }
}
