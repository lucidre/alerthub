import 'package:alerthub/common_libs.dart' hide Marker;
import 'package:alerthub/presentation/event/map_event_item.dart';
import 'package:async/async.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});
  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  CancelableOperation<bool>? cancelableFuture;
  final oneSecond = const Duration(seconds: 1);
  final initialCamera = const CameraPosition(zoom: 0, target: LatLng(-1, -1));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final controller = Get.find<MapController>();
      controller.getLocationUpdate();
    });
  }

  getData() async {
    final controller = Get.find<MapController>();

    if (controller.currentPosition == null) {
      Future.delayed(oneSecond, () => getData());
      return;
    }

    try {
      /*     final data = await $networkUtil.getEventMap(
        radius: radius,
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
      );

      final events = data.data?.events ?? [];

      for (final event in events) {
        final controller = Get.find<MapController>();
        controller.addMapEvent(event);
      } */
    } catch (exception) {
      context.showErrorSnackBar('An error occurred with fetching the events.');
      Future.delayed(
        const Duration(seconds: 2),
        () => getData(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(space12),
      child: Column(
        children: [
          buildAppBar(),
          Expanded(
            child: buildBody().fadeIn(),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return GetX<MapController>(builder: (controller) {
      final homePosition = controller.userPosition;
      final events = controller.event;

      return GoogleMap(
        mapType: MapType.normal,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        onCameraMove: (cameraPosition) =>
            updateCameraPosition(controller, cameraPosition),
        initialCameraPosition: initialCamera,
        onMapCreated: (data) => controller.setMapController(data),
        myLocationEnabled: true,
        markers: {
          if (homePosition != null)
            Marker(
              onTap: () => context
                  .showInformationSnackBar('This is your current location.'),
              markerId: const MarkerId('currentLocation'),
              position: homePosition,
            ),
          ...events.map((event) {
            return Marker(
                markerId: MarkerId(event.toString()),
                position: const LatLng(0, 0),
                onTap: () {
                  context.showBottomBar(
                    child: const MapEventItem(),
                    ignoreBg: true,
                    ignoreHeight: true,
                  );
                });
          }),
        },
      );
    });
  }

  updateCameraPosition(
    MapController controller,
    CameraPosition cameraPosition,
  ) async {
    if (!controller.considerChangingCenterPosition) return;

    try {
      cancelableFuture?.cancel();

      //ensures the method calls the endpoint only when the user has stopped dragging the map.
      cancelableFuture = CancelableOperation.fromFuture(() async {
        await Future.delayed(oneSecond, () => true);
        return true;
      }());

      final fetchUpdatedData = await cancelableFuture?.value ?? false;

      if (fetchUpdatedData) {
        final shouldGetData =
            controller.shouldUpdateCurrentPosition(cameraPosition.target);
        if (shouldGetData) {
          getData();
        }
      }
    } catch (_) {}
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: null,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text('Map View', style: satoshi600S24).fadeIn(),
    );
  }
}
