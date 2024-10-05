// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:alerthub/features/event/presentation/controller/event_address_picker_controller.dart';
import 'package:alerthub/common_libs.dart';
import 'package:map_location_picker/map_location_picker.dart';

class EventsMoreAddressPickerBar extends StatefulWidget {
  const EventsMoreAddressPickerBar({super.key});

  @override
  State<EventsMoreAddressPickerBar> createState() =>
      _EventsMoreAddressPickerBarState();
}

class _EventsMoreAddressPickerBarState
    extends State<EventsMoreAddressPickerBar> {
  GeocodingResult? selected;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final controller = Get.find<EventAddressPickerController>();
      selected = controller.geocodingResult;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(space12),
          topRight: Radius.circular(space12),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(space12),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(space4),
              border: Border.all(color: neutral200),
            ),
            child: Text(
              context.localization?.selectAddress ?? '',
              style: satoshi600S14,
            ).fadeInAndMoveFromBottom(),
          ),
          verticalSpacer12,
          Expanded(
            child:
                GetBuilder<EventAddressPickerController>(builder: (controller) {
              final geocodingResultList = controller.geocodingResultList;
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemCount: geocodingResultList.length,
                itemBuilder: (ctx, index) {
                  final element = geocodingResultList[index];
                  return buildItem(element);
                },
              );
            }),
          ),
          verticalSpacer12,
          AppBtn.from(
            onPressed: () {
              if (selected == null) {
                context.showErrorSnackBar(
                    context.localization?.kindlySelectAddress ?? '');
              } else {
                final controller = Get.find<EventAddressPickerController>();
                controller.geocodingResult = selected;
                controller.selectedAddress = selected?.formattedAddress;
                Navigator.pop(context);
              }
            },
            text: context.localization?.continueS ?? '',
          )
        ],
      ),
    );
  }

  InkWell buildItem(GeocodingResult element) {
    return InkWell(
      onTap: () {
        setState(() {
          selected = element;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(space4),
          border: Border.all(color: neutral200),
        ),
        margin: const EdgeInsets.only(
          bottom: space6,
          top: space6,
        ),
        padding: const EdgeInsets.only(left: space12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                element.formattedAddress ?? "",
                style: satoshi500S14,
              ),
            ),
            horizontalSpacer8,
            IgnorePointer(
              ignoring: true,
              child: SimpleCheckbox(
                isExpanded: false,
                active: selected == element,
                onToggled: (_) {},
              ),
            )
          ],
        ).fadeInAndMoveFromBottom(),
      ),
    );
  }
}
