// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/event/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/event/data/repositorites/event_repository_impl.dart';
import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/presentation/bars/events_map_bar.dart';
import 'package:alerthub/features/event/presentation/controller/events_map_tab_controller.dart';
import 'package:alerthub/common_libs.dart' hide Marker;
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:async/async.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventsMapTab extends StatefulWidget {
  const EventsMapTab({super.key});
  @override
  State<EventsMapTab> createState() => _EventsMapTabState();
}

class _EventsMapTabState extends State<EventsMapTab> {
  CancelableOperation<bool>? cancelableFuture;
  final oneSecond = const Duration(seconds: 1);
  final initialCamera = const CameraPosition(zoom: 0, target: LatLng(-1, -1));

  @override
  void initState() {
    super.initState();
    Get.put(EventsMapTabController(
      EventService(
        EventRepositoryImpl(
          EventRemoteDataSource(),
        ),
      ),
    ));
    Future.delayed(Duration.zero, () => getData());
  }

  getData() async {
    try {
      final controller = Get.find<EventsMapTabController>();
      await controller.getData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  void dispose() {
    final controller = Get.find<EventsMapTabController>();
    controller.cancelStream();
    super.dispose();
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
    return GetX<EventsMapTabController>(builder: (controller) {
      final homePosition = controller.userPosition;
      final events = controller.events;

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
              onTap: () => context.showInformationSnackBar(
                  context.localization?.currentLocation ?? ''),
              markerId: const MarkerId('currentLocation'),
              icon: BitmapDescriptor.defaultMarkerWithHue(200),
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
                    child: EventsMapBar(event: event),
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
      EventsMapTabController controller, CameraPosition cameraPosition) async {
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
      title: Text(context.localization?.mapView ?? '', style: satoshi600S24)
          .fadeIn(),
      actions: [
        GetX<EventsMapTabController>(
          builder: (controller) {
            final isLoading = controller.isLoading;
            return isLoading
                ? const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(blackShade1Color),
                    ),
                  )
                : const SizedBox();
          },
        ),
        horizontalSpacer12,
      ],
    );
  }
}
