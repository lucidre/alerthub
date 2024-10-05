// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:alerthub/features/event/presentation/bars/events_more_address_picker_bar.dart';
import 'package:alerthub/features/event/presentation/controller/event_address_picker_controller.dart';
import 'package:alerthub/common_libs.dart' hide Marker;
import 'package:map_location_picker/map_location_picker.dart';

@RoutePage()
class EventAddressPickerScreen extends StatefulWidget {
  const EventAddressPickerScreen({super.key});

  @override
  State<EventAddressPickerScreen> createState() =>
      _EventAddressPickerScreenState();
}

class _EventAddressPickerScreenState extends State<EventAddressPickerScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(EventAddressPickerController());
    Future.delayed(Duration.zero, () {
      controller.getLocationUpdate();
    });
  }

  @override
  void dispose() {
    final controller = Get.put(EventAddressPickerController());
    controller.cancelStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          buildBody(),
          buildDateStateWidget(),
        ],
      ),
    );
  }

  buildDateStateWidget() {
    return GetX<EventAddressPickerController>(builder: (controller) {
      final isLoading = controller.isLoading;
      final hasError = controller.hasError;
      final error = controller.error;
      if (isLoading) {
        return Container(
          color: context.backgroundColor,
          alignment: Alignment.center,
          child: context.buildLoadingWidget(),
        );
      } else if (hasError) {
        return Container(
          color: context.backgroundColor,
          alignment: Alignment.center,
          child: context.buildErrorWidget(
            body: error,
            onRetry: () => controller.getLocationUpdate(),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: buildMap()),
        buildBottom(),
      ],
    );
  }

  Widget buildBottom() {
    return Container(
      padding: const EdgeInsets.only(left: space12, bottom: space12),
      decoration: BoxDecoration(
        border: Border.all(color: neutral300),
        color: context.backgroundColor,
      ),
      child: GetX<EventAddressPickerController>(builder: (controller) {
        final selectedAddress = controller.selectedAddress;
        final geocodingResult = controller.geocodingResult;
        final geocodingResultList = controller.geocodingResultList;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedAddress ??
                        (context.localization?.tapOnMapToGetAddress ?? ""),
                    style: satoshi600S14,
                  ).fadeInAndMoveFromBottom(),
                ),
                IconButton(
                  onPressed: () {
                    context.router.maybePop({
                      'address': geocodingResult?.formattedAddress,
                      'lat': geocodingResult?.geometry.location.lat,
                      'lng': geocodingResult?.geometry.location.lng,
                    });
                  },
                  icon: Icon(Icons.send_rounded),
                ),
              ],
            ),
            if (geocodingResultList.isNotEmpty) ...[
              verticalSpacer12,
              GestureDetector(
                onTap: () {
                  context.showBottomBar(
                    ignoreBg: true,
                    height: context.height * .6,
                    child: EventsMoreAddressPickerBar(),
                  );
                },
                child: Chip(
                  backgroundColor: whiteColor,
                  label: Text(
                    "${context.localization?.tapToShow ?? ''} ${(geocodingResultList.length - 1)} ${context.localization?.moreResultOptions ?? ''}",
                    style: satoshi600S12,
                  ),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  decodeAddress(LatLng position) async {
    try {
      final controller = Get.find<EventAddressPickerController>();
      controller.displayPosition = position;
      final cameraUpdate = CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: controller.zoomLevel));
      controller.mapController?.animateCamera(cameraUpdate);
      await controller.decodeAddress(position.latitude, position.longitude);
    } catch (exception) {
      context.showErrorSnackBar(context.localization?.addressNotFound ?? '');
    }
  }

  buildMap() {
    return GetX<EventAddressPickerController>(builder: (controller) {
      final homePosition = controller.homePosition;
      final displayPosition = controller.displayPosition;
      return GoogleMap(
        onCameraMove: (position) => controller.zoomLevel = position.zoom,
        initialCameraPosition:
            const CameraPosition(zoom: 0, target: LatLng(-1, -1)),
        mapType: MapType.normal,
        rotateGesturesEnabled: false,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        buildingsEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,
        fortyFiveDegreeImageryEnabled: false,
        myLocationEnabled: true,
        trafficEnabled: true,
        onTap: (position) => decodeAddress(position),
        onMapCreated: (mapController) =>
            controller.mapController = mapController,
        markers: {
          if (controller.homePosition != null)
            Marker(
              markerId: const MarkerId('_currentLocation'),
              icon: BitmapDescriptor.defaultMarkerWithHue(200),
              position: homePosition!,
            ),
          if (displayPosition != null)
            Marker(
              markerId: const MarkerId('_displayPosition'),
              position: displayPosition,
            ),
        },
      );
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(
        color: context.textColor,
        onPressed: () => context.router.maybePop(),
      ),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text(context.localization?.pickAddress ?? '', style: satoshi600S24)
          .fadeIn(),
    );
  }
}
