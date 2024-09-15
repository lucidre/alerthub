// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  bool isHidden = true;
  bool isLoading = false;
  String? selectedPriority;
  String? selectedRange = '24 hours';
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final priorities = ['High', 'Medium', 'Low'];
  final eventRange = ['24 hours', '2 days', '3 days', 'Indeterminate'];
  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();

    super.dispose();
  }

  void saveForm() {
    FocusScope.of(context).unfocus();
    final isValid = formKey.currentState?.validate();

    if ((isValid ?? false) == false || isLoading) {
      return;
    }

    formKey.currentState?.save();
    showLoginStatus();
  }

  Future showLoginStatus() async {
    // final email = emailController.text.trim();
    // final password = passwordController.text.trim();

    setState(() {
      isLoading = true;
    });

    try {
      //
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
            verticalSpacer16,
            Center(
              child: Text(
                'Kindly ensure the details you entered are accurate as you can only change optional data in edit mode. ',
                style: satoshi600S12,
                textAlign: TextAlign.center,
              ),
            ),
            verticalSpacer16,
            AppBtn.from(
              onPressed: saveForm,
              isLoading: isLoading,
              text: 'Upload',
            ),
            verticalSpacer32,
          ],
        ),
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
            Text('Image(s)', style: satoshi600S14),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
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
        )).fadeInAndMoveFromBottom();
  }

  List<Widget> buildPriority() {
    return [
      Text('Priority', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: neutral200),
            color: shadeWhite,
            borderRadius: BorderRadius.circular(cornersSmall)),
        child: DropdownButton<String>(
          value: selectedPriority,
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
            'Select the priority',
            style: satoshi500S14.copyWith(color: neutral400),
          ),
          items: priorities.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: satoshi500S14),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedPriority = newValue;
            });
          },
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
          value: selectedRange,
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
            'Select the priority',
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
              selectedRange = newValue;
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
        controller: nameController,
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
        controller: nameController,
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
