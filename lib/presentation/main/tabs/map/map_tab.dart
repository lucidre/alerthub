// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart' hide Marker;
import 'package:alerthub/models/event/event.dart';
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
    Future.delayed(Duration.zero, () => getData());
  }

  getData() async {
    try {
      final controller = Get.find<MapController>();
      await controller.getData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
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
      final isLoading = controller.isLoading;
      final hasError = controller.hasError;

      return Stack(
        children: [
          buildMap(controller),
          isLoading
              ? Container(
                  alignment: Alignment.center,
                  color: context.backgroundColor,
                  child: context.buildLoadingWidget(),
                )
              : hasError
                  ? Container(
                      alignment: Alignment.center,
                      color: context.backgroundColor,
                      child: context.buildErrorWidget(
                        onRetry: () => getData(),
                      ),
                    )
                  : const SizedBox() // the stack is needed because mapcontroller can only be gotten when the map widget has been rendered.
        ],
      );
    });
  }

  GoogleMap buildMap(MapController controller) {
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
          final id = event.id ?? '';
          Color color = event.priority?.textColor ?? blackColor;
          HSVColor hsvColor = HSVColor.fromColor(color);
          double hue = hsvColor.hue;
          final lat = event.lat ?? -1;
          final lng = event.lng ?? -1;
          return Marker(
              markerId: MarkerId(id),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(hue),
              onTap: () {
                context.showBottomBar(
                  child: MapEventItem(event: event),
                  ignoreBg: true,
                  ignoreHeight: true,
                );
              });
        }),
      },
    );
  }

  updateCameraPosition(
      MapController controller, CameraPosition cameraPosition) async {
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
