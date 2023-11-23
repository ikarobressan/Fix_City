import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../Constants/colors.dart';
import '../../../Controller/theme_controller.dart';
import '../Category/provider/firestore_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng initialPosition = const LatLng(-22.5549017, -47.3577133);
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    loadMarkers();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();

    try {
      LocationData currentLocation = await location.getLocation();
      setState(() {
        initialPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });
    } catch (e) {
      log('Erro ao obter a localização atual: $e');
    }
  }

  Future<void> loadMarkers() async {
    // Substitua "chamados" pelo nome da sua coleção no Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Chamados').get();

    setState(
      () {
        markers = snapshot.docs.map(
          (DocumentSnapshot<Map<String, dynamic>> doc) {
            Map<String, dynamic> data = doc.data()!;
            GeoPoint geoPoint = data["location_report"];
            double latitude = geoPoint.latitude;
            double longitude = geoPoint.longitude;

            return Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: 'Chamado #${doc.id}',
                onTap: () {
                  Future<Map<String, dynamic>> chamado =
                      FirestoreProvider.getDocumentById(
                    "Chamados",
                    doc.id,
                  );

                  chamado.then(
                    (dadosDoChamado) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            '#${doc.id}',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[50],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Status: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    Text(
                                      '${dadosDoChamado['Status do chamado']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(5),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[50],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Categoria: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${dadosDoChamado['Categoria']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(5),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[50],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Descrição: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[50],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Expanded(
                                  child: Text(
                                    '${dadosDoChamado['Descricao']}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                              },
                              child: const Text('Fechar'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mapa dos chamados',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              loadMarkers();
            },
            icon: Icon(
              Icons.replay_outlined,
              color: isDark ? whiteColor : blackColor,
            ),
            iconSize: 30,
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 15.0,
        ),
        markers: Set<Marker>.from(markers),
      ),
    );
  }
}
