// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:alerthub/api/firebase_util.dart';
import 'package:alerthub/api/network_utils.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/event/event.dart';
import 'package:alerthub/presentation/event/event_priority_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  bool isHidden = true;
  bool isLoading = false;
  EventPriority? selectedPriority;
  String? selectedAvailiablity = '24 hours';
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  final imagePicker = ImagePicker();
  final List<String> images = [];

  final formKey = GlobalKey<FormState>();

  final eventRange = [
    '24 hours',
    '2 days',
    '3 days',
    'Indeterminate',
  ];

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();

    super.dispose();
  }

  void saveForm() {
    FocusScope.of(context).unfocus();
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid || isLoading) {
      return;
    }

    if (selectedPriority == null) {
      context.showErrorSnackBar('Kindly select the event priority');
      return;
    }

    if (selectedAvailiablity == null) {
      context.showErrorSnackBar(
          'Kindly select the availibility range of the event');
      return;
    }

    formKey.currentState?.save();
    showLoginStatus();
  }

  Future showLoginStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      final eventId = $firebaseUtil.generateDataId();
      final name = nameController.text.trim();
      final description = descriptionController.text.trim();
      final location = locationController.text.trim();

      List<String> imageUrls = [];

      if (images.isNotEmpty) {
        imageUrls = await $firebaseUtil.uploadEventImages(
          eventId,
          images,
        );
      }

      await $networkUtil.createEvent(
        name: name,
        description: description,
        location: location,
        priority: selectedPriority?.name ?? '',
        lat: -1,
        lng: -1,
        availablity: selectedAvailiablity!,
        images: imageUrls,
      );
      context.showSuccessSnackBar('Your event has been successfully created');
      context.router.maybePop();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }

    setState(() {
      isLoading = false;
    });
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
          child: buildBody(),
        ),
      ),
    );
  }

  Form buildBody() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(space12),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(space4),
                border: Border.all(color: neutral200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please make sure the information you provide is accurate. Once your event is uploaded, it will be verified by other users. If it is found to be false, it will be removed.',
                    style: satoshi600S12,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            verticalSpacer16,
            AppBtn.from(
              onPressed: () => saveForm(),
              isLoading: isLoading,
              text: 'Upload',
            ),
            verticalSpacer32,
          ],
        ),
      ),
    );
  }

  selectImages() async {
    try {
      final files = await imagePicker.pickMultiImage();
      if (files.isNotEmpty) {
        for (final file in files) {
          images.add(file.path);
        }
        setState(() {});
      }
    } catch (exception) {
      context.showErrorSnackBar('An error occured while picking the image.');
    }
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
            Text('Image(s)', style: satoshi600S14),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            images.isNotEmpty
                ? buildSelectedImageChild()
                : buildNoSelectedImageChild(),
          ],
        )).fadeInAndMoveFromBottom();
  }

  buildSelectedImageChild() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(0),
        physics: const BouncingScrollPhysics(),
        itemCount: images.length + 1,
        itemBuilder: (cx, index) {
          return Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.only(right: space4),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              border: Border.all(
                color: neutral200,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              color: blackShade1Color,
              borderRadius: BorderRadius.circular(space4),
            ),
            child: index == 0
                ? InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      selectImages();
                    },
                    child: const Icon(CupertinoIcons.add, color: whiteColor))
                : InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      images.removeAt(index - 1);
                      setState(() {});
                    },
                    child: Stack(
                      children: [
                        Image.file(
                          File(images[index - 1]),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                        Positioned(
                          right: space4,
                          top: space4,
                          child: Container(
                            padding: const EdgeInsets.all(space4),
                            decoration: BoxDecoration(
                              color: blackShade1Color,
                              borderRadius: BorderRadius.circular(space4),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: whiteColor,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
              'Click to select image(s)',
              style: satoshi500S12,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildPriority() {
    return [
      Text('Priority', style: satoshi500S12).fadeInAndMoveFromBottom(),
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
          onTap: () async {
            FocusScope.of(context).unfocus();

            final result = await context.showBottomBar(
              child: EventPriorityPicker(
                priority: selectedPriority,
              ),
            );
            if (result != null && result is EventPriority) {
              setState(() {
                selectedPriority = result;
              });
            }
          },
          splashColor: Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedPriority == null
                      ? 'Select the priority'
                      : '${selectedPriority!.displayName} Priority',
                  style: satoshi500S14.copyWith(
                      color: selectedPriority == null ? neutral400 : null),
                ),
              ),
              const Icon(Icons.arrow_drop_down_rounded),
            ],
          ),
        ),
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildEventRange() {
    return [
      Text('Availiablity Range', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: neutral200),
            color: shadeWhite,
            borderRadius: BorderRadius.circular(cornersSmall)),
        child: DropdownButton<String>(
          value: selectedAvailiablity,
          icon: const Icon(Icons.arrow_drop_down_rounded),
          style: satoshi500S14,
          alignment: Alignment.centerLeft,
          underline: const SizedBox(width: double.infinity),
          isExpanded: true,
          padding: const EdgeInsets.only(
            left: space12,
            right: space12,
          ),
          hint: Text(
            'Select the availiability',
            style: satoshi500S14.copyWith(color: neutral400),
          ),
          items: eventRange.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: satoshi500S14),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedAvailiablity = newValue;
            });
          },
        ),
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildName() {
    return [
      Text('Name', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.next,
        decoration: context.inputDecoration(hintText: "Enter event name"),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please provide the name.";
          }
          return null;
        },
        controller: nameController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildLocation() {
    return [
      Row(
        children: [
          Text('Location', style: satoshi500S12),
          const Spacer(),
          AppBtn.basic(
            onPressed: () {},
            child: Text(
              'Select from map',
              style: satoshi600S12,
            ),
          )
        ],
      ).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.next,
        decoration: context.inputDecoration(hintText: "Enter event location"),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please provide the location.";
          }
          return null;
        },
        controller: locationController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildDescription() {
    return [
      Text('Description', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.next,
        decoration: context.inputDecoration(hintText: "Enter event descriptin"),
        keyboardType: TextInputType.text,
        maxLines: null,
        minLines: 3,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please provide a description.";
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
      title: Text('Create Event', style: satoshi600S24).fadeIn(),
    );
  }
}
