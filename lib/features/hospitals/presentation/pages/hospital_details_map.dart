// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart' hide Marker;
import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/hospitals/presentation/controller/hospital_details_map_controller.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

@RoutePage()
class HospitalDetailsMapScreen extends StatefulWidget {
  final Hospital hospital;
  const HospitalDetailsMapScreen({super.key, required this.hospital});

  @override
  State<HospitalDetailsMapScreen> createState() => _HospitalDetailsMapState();
}

class _HospitalDetailsMapState extends State<HospitalDetailsMapScreen> {
  final tag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    final controller = Get.put(
      HospitalDetailsMapController(),
      tag: tag,
    );

    Future.delayed(Duration.zero, () {
      controller.initData(widget.hospital);
    });
  }

  @override
  void dispose() {
    final controller = Get.find<HospitalDetailsMapController>(tag: tag);

    controller.cancelStream();
    Get.delete<HospitalDetailsMapController>(tag: tag);
    super.dispose();
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text('Healthcenter Location', style: satoshi600S24).fadeIn(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    Color color = blackColor;
    HSVColor hsvColor = HSVColor.fromColor(color);
    double hue = hsvColor.hue;
    return GetX<HospitalDetailsMapController>(builder: (controller) {
      final hospitalPosition = controller.hospitalPosition;
      final homePosition = controller.homePosition;
      return GoogleMap(
        mapType: MapType.normal,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        initialCameraPosition: const CameraPosition(
          zoom: 0,
          target: LatLng(-1, -1),
        ),
        onMapCreated: (data) => controller.controller = data,
        myLocationEnabled: true,
        markers: {
          if (hospitalPosition != null)
            Marker(
              onTap: () => context.showInformationSnackBar(
                  'Healthcenter Location: ${widget.hospital.location ?? ''}'),
              markerId: const MarkerId('_hospitalLocation'),
              icon: BitmapDescriptor.defaultMarkerWithHue(hue),
              position: hospitalPosition,
            ),
          if (homePosition != null)
            Marker(
              onTap: () => context.showInformationSnackBar(
                  context.localization?.currentLocation ?? ''),
              markerId: const MarkerId('_currentLocation'),
              icon: BitmapDescriptor.defaultMarkerWithHue(200),
              position: homePosition,
            ),
        },
      );
    });
  }
}
