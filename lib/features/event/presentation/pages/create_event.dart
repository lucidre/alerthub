// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/event/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/event/data/repositorites/event_repository_impl.dart';
import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/presentation/bars/events_priority_picker_bar.dart';
import 'package:alerthub/features/event/presentation/controller/event_create_controller.dart';
import 'package:alerthub/features/event/presentation/widget/address_textfield.dart';
import 'package:alerthub/features/event/presentation/widget/create_event_image_item.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/common_libs.dart';

import 'package:flutter/cupertino.dart';

@RoutePage()
class CreateEventScreen extends StatefulWidget {
  final Event? event;
  const CreateEventScreen({super.key, this.event});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  @override
  void initState() {
    super.initState();

    final controller = Get.put(
      EventCreateController(
        EventService(
          EventRepositoryImpl(
            EventRemoteDataSource(),
          ),
        ),
      ),
    );

    final event = widget.event;

    controller.setUpData(event);
  }

  Future<void> selectDate(bool isStart) async {
    final current = DateTime.now();
    final lastDate = DateTime(2100);
    final firstDate = DateTime(2001);

    final DateTime? time = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: blackShade1Color, // Primary color
            colorScheme: const ColorScheme.light(primary: blackShade1Color),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: neutral300),
                borderRadius: BorderRadius.circular(space4), // Border radius
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      final controller = Get.find<EventCreateController>();
      if (isStart) {
        controller.startDate = time;
      } else {
        controller.endDate = time;
      }
      setState(() {});
    }
  }

  selectImages() async {
    try {
      final controller = Get.find<EventCreateController>();
      await controller.selectImages();
    } catch (exception) {
      context.showErrorSnackBar(context.localization?.errorPickingImage ?? '');
    }
  }

  uploadEventToServer() async {
    FocusScope.of(context).unfocus();
    try {
      final controller = Get.find<EventCreateController>();
      await controller.uploadEventToServer(widget.event?.id);
      context.showSuccessSnackBar(
          '${context.localization?.eventHasBeen ?? ''} ${widget.event != null ? (context.localization?.updated ?? '') : (context.localization?.created ?? '')}.');
      context.router.maybePop(true);
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: true,
      appBar: buildAppBar(),
      backgroundColor: context.backgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(space12),
          child: GetBuilder<EventCreateController>(builder: (controller) {
            final formKey = controller.formKey;
            return Form(
              key: formKey,
              child: buildBody(),
            );
          }),
        ),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...buildName(),
          verticalSpacer12,
          ...buildDescription(),
          verticalSpacer12,
          ...buildLocation(),
          verticalSpacer12,
          ...buildPriority(),
          verticalSpacer16,
          buildImages(),
          verticalSpacer12,
          ...buildEventRange(),
          verticalSpacer16 * 2,
          buildInfo(),
          verticalSpacer16,
          buildUploadButton(),
          verticalSpacer32,
        ],
      ),
    );
  }

  GetX<EventCreateController> buildUploadButton() {
    return GetX<EventCreateController>(builder: (controller) {
      final isLoading = controller.isLoading;
      return AppBtn.from(
        onPressed: () => uploadEventToServer(),
        isLoading: isLoading,
        text: context.localization?.upload ?? '',
      );
    });
  }

  Container buildInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Text(
        context.localization?.informationAccuracy ?? '',
        style: satoshi600S12,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildImages() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
          border: Border.all(color: neutral200),
          color: shadeWhite,
          borderRadius: BorderRadius.circular(cornersSmall)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.localization?.images ?? '', style: satoshi600S14),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          GetX<EventCreateController>(builder: (controller) {
            final images = controller.images;
            return images.isNotEmpty
                ? buildSelectedImageChild(images)
                : buildNoSelectedImageChild();
          }),
        ],
      ),
    ).fadeInAndMoveFromBottom();
  }

  buildSelectedImageChild(List<dynamic> images) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(0),
        physics: const BouncingScrollPhysics(),
        itemCount: images.length + 1,
        itemBuilder: (cx, index) {
          return CreateEventImageItem(
            onPressed: () {
              if (index == 0) {
                selectImages();
              } else {
                Get.find<EventCreateController>().removeImage(index - 1);
              }
            },
            image: index == 0 ? null : images[index - 1],
          );
        },
      ),
    );
  }

  buildNoSelectedImageChild() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => selectImages(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              CupertinoIcons.camera_on_rectangle,
              size: 70,
              color: context.textColor.withOpacity(.8),
            ),
          ),
          verticalSpacer8,
          Center(
            child: Text(
              context.localization?.clickToSelectImages ?? '',
              style: satoshi500S12,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildPriority() {
    return [
      Text(context.localization?.priority ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: space8,
          bottom: space8,
          left: space12,
          right: space12,
        ),
        decoration: BoxDecoration(
            border: Border.all(color: neutral200),
            color: shadeWhite,
            borderRadius: BorderRadius.circular(cornersSmall)),
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            context.showBottomBar(child: const EventsPriorityPickerBar());
          },
          splashColor: Colors.transparent,
          child: GetX<EventCreateController>(builder: (controller) {
            final selectedPriority = controller.selectedPriority;
            return Row(
              children: [
                Expanded(
                  child: Text(
                    selectedPriority == null
                        ? (context.localization?.selectPriority ?? '')
                        : '${selectedPriority.displayName} ${context.localization?.priority ?? ''}',
                    style: satoshi500S14.copyWith(
                        color: selectedPriority == null ? neutral400 : null),
                  ),
                ),
                const Icon(Icons.arrow_drop_down_rounded),
              ],
            );
          }),
        ),
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildEventRange() {
    return [
      Row(
        children: [
          Expanded(child: buildStartDate()),
          horizontalSpacer12,
          Expanded(child: buildEndDate()),
        ],
      ),
    ];
  }

  Column buildEndDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.localization?.endDate ?? '', style: satoshi500S12)
            .fadeInAndMoveFromBottom(),
        verticalSpacer8,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: space8,
            bottom: space8,
            left: space12,
            right: space12,
          ),
          decoration: BoxDecoration(
              border: Border.all(color: neutral200),
              color: shadeWhite,
              borderRadius: BorderRadius.circular(cornersSmall)),
          child: InkWell(
            onTap: () {
              final controller = Get.find<EventCreateController>();
              final userDoesNotKnowEndDate = controller.userDoesNotKnowEndDate;
              if (!userDoesNotKnowEndDate) {
                selectDate(false);
              } else {
                context.showErrorSnackBar(
                    context.localization?.disableCheckboxEndDate ?? '');
              }
            },
            splashColor: Colors.transparent,
            child: GetX<EventCreateController>(builder: (controller) {
              final userDoesNotKnowEndDate = controller.userDoesNotKnowEndDate;
              final endDate = controller.endDate;
              return Opacity(
                opacity: userDoesNotKnowEndDate ? 0.2 : 1,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        endDate == null
                            ? context.localization?.selectEndDate ?? ''
                            : $appUtil
                                .formattedDate(endDate.millisecondsSinceEpoch),
                        style: satoshi500S14.copyWith(
                          color: endDate == null ? neutral400 : null,
                        ),
                      ),
                    ),
                    const Icon(Icons.date_range_rounded),
                  ],
                ),
              );
            }),
          ),
        ).fadeInAndMoveFromBottom(),
        GetX<EventCreateController>(builder: (controller) {
          final userDoesNotKnowEndDate = controller.userDoesNotKnowEndDate;
          return Transform.translate(
            offset: const Offset(-10, 0),
            child: SimpleCheckbox(
              active: userDoesNotKnowEndDate,
              onToggled: (value) =>
                  controller.userDoesNotKnowEndDate = value ?? false,
              label: Text(
                context.localization?.unknownEndDate ?? '',
                style: satoshi500S12,
              ),
            ),
          );
        }),
      ],
    );
  }

  Column buildStartDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.localization?.startDate ?? '', style: satoshi500S12)
            .fadeInAndMoveFromBottom(),
        verticalSpacer8,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: space8,
            bottom: space8,
            left: space12,
            right: space12,
          ),
          decoration: BoxDecoration(
              border: Border.all(color: neutral200),
              color: shadeWhite,
              borderRadius: BorderRadius.circular(cornersSmall)),
          child: InkWell(
            onTap: () {
              final controller = Get.find<EventCreateController>();
              final userDoesNotKnowStartDate =
                  controller.userDoesNotKnowStartDate;
              if (!userDoesNotKnowStartDate) {
                selectDate(true);
              } else {
                context.showErrorSnackBar(
                    context.localization?.disableCheckboxStartDate ?? '');
              }
            },
            splashColor: Colors.transparent,
            child: GetX<EventCreateController>(builder: (controller) {
              final userDoesNotKnowStartDate =
                  controller.userDoesNotKnowStartDate;
              final startDate = controller.startDate;
              return Opacity(
                opacity: userDoesNotKnowStartDate ? 0.2 : 1,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        startDate == null
                            ? context.localization?.selectStartDate ?? ''
                            : $appUtil.formattedDate(
                                startDate.millisecondsSinceEpoch),
                        style: satoshi500S14.copyWith(
                          color: startDate == null ? neutral400 : null,
                        ),
                      ),
                    ),
                    const Icon(Icons.date_range_rounded),
                  ],
                ),
              );
            }),
          ),
        ).fadeInAndMoveFromBottom(),
        GetX<EventCreateController>(builder: (controller) {
          final userDoesNotKnowStartDate = controller.userDoesNotKnowStartDate;
          return Transform.translate(
            offset: const Offset(-10, 0),
            child: SimpleCheckbox(
              active: userDoesNotKnowStartDate,
              onToggled: (value) =>
                  controller.userDoesNotKnowStartDate = value ?? false,
              label: Text(
                context.localization?.unknownStartDate ?? '',
                style: satoshi500S12,
              ),
            ),
          );
        }),
      ],
    );
  }

  List<Widget> buildName() {
    final controller = Get.find<EventCreateController>();
    final nameController = controller.nameController;
    return [
      Text(context.localization?.name ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.next,
        decoration: context.inputDecoration(
            hintText: context.localization?.enterEventName ?? ""),
        maxLength: 20,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return context.localization?.provideEventName ?? "";
          } else if (value.length > 20) {
            return context.localization?.shorterTitle ?? "";
          }
          return null;
        },
        controller: nameController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildLocation() {
    final controller = Get.find<EventCreateController>();
    final locationController = controller.locationController;
    return [
      Row(
        children: [
          Text(context.localization?.location ?? '', style: satoshi500S12),
          const Spacer(),
          AppBtn.basic(
            onPressed: () async {
              final result =
                  await context.router.push(const EventAddressPickerRoute());
              if (result is Map<String, dynamic>) {
                locationController.text = result['address']?.toString() ?? '';
                controller.selectedLat = result['lat'];
                controller.selectedLng = result['lng'];

                setState(() {});
              }
            },
            child: Text(
              context.localization?.selectFromMap ?? '',
              style: satoshi600S12,
            ),
          )
        ],
      ).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      AddressTextField(
        textInputAction: TextInputAction.next,
        hintText: context.localization?.enterEventLocation ?? '',
        locationUpdate: (lat, lng) => controller.decodeAddress(),
        ignoreMaxLine: true,
        keyboardType: TextInputType.streetAddress,
        controller: locationController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildDescription() {
    final controller = Get.find<EventCreateController>();
    final descriptionController = controller.descriptionController;
    return [
      Text(context.localization?.description ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.next,
        decoration: context.inputDecoration(
            hintText: context.localization?.enterEventDescription ?? ""),
        keyboardType: TextInputType.text,
        maxLines: null,
        minLines: 3,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return context.localization?.provideDescription ?? "";
          }
          return null;
        },
        controller: descriptionController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text(
              widget.event != null
                  ? (context.localization?.editEvent ?? '')
                  : (context.localization?.createEvent ?? ''),
              style: satoshi600S24)
          .fadeIn(),
    );
  }
}
