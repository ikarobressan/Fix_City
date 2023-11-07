import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'MapsController/maps_controller.dart';

final appKey = GlobalKey();

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapsController());

    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: controller.position,
            zoom: 20,
          ),
          myLocationEnabled: true,
          onMapCreated: controller.onMapCreated,
        ),
      ),
    );
  }
}
