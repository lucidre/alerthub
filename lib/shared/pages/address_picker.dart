import 'package:alerthub/common_libs.dart' hide Marker;
import 'package:alerthub/shared/bars/address_picker_more_bar.dart';
import 'package:alerthub/shared/controllers/address_picker_controller.dart';
import 'package:map_location_picker/map_location_picker.dart';

@RoutePage()
class AddressPickerScreen extends StatefulWidget {
  const AddressPickerScreen({super.key});

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  final tag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    Get.put(AddressPickerController(), tag: tag);
  }

  @override
  void dispose() {
    Get.delete<AddressPickerController>(tag: tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: GetX<AddressPickerController>(
          tag: tag,
          builder: (controller) {
            final isLoading = controller.isLoading;
            final hasError = controller.hasError;
            final error = controller.error;
            if (isLoading) {
              return Center(
                child: context.buildLoadingWidget(),
              );
            } else if (hasError) {
              return Center(
                child: context.buildErrorWidget(
                  body: error,
                  onRetry: () => controller.getLocationUpdate(),
                ),
              );
            } else {
              return buildBody();
            }
          }),
    );
  }

  buildBody() {
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
    return Padding(
      padding: const EdgeInsets.all(space12),
      child: GetX<AddressPickerController>(
          tag: tag,
          builder: (controller) {
            final selectedAddress = controller.selectedAddress;
            final geocodingResult = controller.geocodingResult;
            final geocodingResultList = controller.geocodingResultList;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 50),
                        decoration: BoxDecoration(
                          border: Border.all(color: neutral200),
                          color: whiteBrownBg1Color,
                          borderRadius: BorderRadius.circular(cornersSmall),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(space4),
                        child: Text(
                          selectedAddress ?? "Tap on the map to get address",
                          style:
                              satoshi500S14.copyWith(color: context.textColor),
                        ).fadeInAndMoveFromBottom(),
                      ),
                    ),
                    horizontalSpacer4,
                    GestureDetector(
                      onTap: () {
                        context.router.maybePop({
                          'address': geocodingResult?.formattedAddress,
                          'lat': geocodingResult?.geometry.location.lat,
                          'lng': geocodingResult?.geometry.location.lng,
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: neutral200),
                            color: whiteBrownBg1Color,
                            borderRadius: BorderRadius.circular(cornersSmall)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        padding: const EdgeInsets.all(space4),
                        child: Icon(
                          Icons.send_rounded,
                          color: context.textColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                if (geocodingResultList.isNotEmpty)
                  GestureDetector(
                    onTap: () async {
                      final element = await context.showBottomBar(
                        height: context.height * .6,
                        child: AddressPickerMoreBar(
                          geocodingResultList: geocodingResultList,
                        ),
                      );
                      if (element is GeocodingResult) {
                        controller.selectedAddress =
                            element.formattedAddress ?? "";
                        controller.geocodingResult = element;
                      }
                    },
                    child: Chip(
                      elevation: 2,
                      shadowColor: context.textColor.withValues(alpha: .2),
                      label: Text(
                        "Tap to show ${(geocodingResultList.length - 1)} more result options",
                        style: satoshi500S12,
                      ),
                    ),
                  ),
              ],
            );
          }),
    );
  }

  Widget buildMap() {
    return GetX<AddressPickerController>(
        tag: tag,
        builder: (controller) {
          return GoogleMap(
            // style: mapTheme,
            onCameraMove: (position) => controller.zoomLevel = position.zoom,
            initialCameraPosition: const CameraPosition(
              zoom: 0,
              target: LatLng(-1, -1),
            ),
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
            onTap: (position) async {
              controller.displayPosition = position;
              try {
                await controller.decodeAddress(
                    position.latitude, position.longitude);
              } catch (exception) {
                if (mounted) {
                  context.showErrorSnackBar(exception.toString());
                }
              }
            },
            onMapCreated: (mapController) =>
                controller.onMapCreated(mapController),
            markers: controller.markers,
          );
        });
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: Text(
        "Pick address",
        style: satoshi600S20,
      ).fadeInAndMoveFromBottom(),
      leading: BackButton(
        color: context.textColor,
        onPressed: () => context.router.maybePop(),
      ).fadeInAndMoveFromBottom(),
    );
  }
}
