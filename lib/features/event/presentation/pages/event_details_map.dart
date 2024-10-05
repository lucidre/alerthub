// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/event/presentation/controller/event_details_map_controller.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/common_libs.dart' hide Marker;

import 'package:google_maps_flutter/google_maps_flutter.dart';

@RoutePage()
class EventDetailsMapScreen extends StatefulWidget {
  final Event event;
  const EventDetailsMapScreen({super.key, required this.event});

  @override
  State<EventDetailsMapScreen> createState() => _EventDetailsMapState();
}

class _EventDetailsMapState extends State<EventDetailsMapScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(EventDetailsMapController());

    Future.delayed(Duration.zero, () {
      controller.initData(widget.event);
    });
  }

  @override
  void dispose() {
    final controller = Get.put(EventDetailsMapController());
    controller.cancelStream();
    super.dispose();
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title:
          Text(context.localization?.eventLocation ?? '', style: satoshi600S24)
              .fadeIn(),
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
    Color color = widget.event.priority?.textColor ?? blackColor;
    HSVColor hsvColor = HSVColor.fromColor(color);
    double hue = hsvColor.hue;
    return GetX<EventDetailsMapController>(builder: (controller) {
      final eventPosition = controller.eventPosition;
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
          if (eventPosition != null)
            Marker(
              onTap: () => context.showInformationSnackBar(
                  '${context.localization?.eventLocation ?? ''}: ${widget.event.location ?? ''}'),
              markerId: const MarkerId('_eventLocation'),
              icon: BitmapDescriptor.defaultMarkerWithHue(hue),
              position: eventPosition,
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
