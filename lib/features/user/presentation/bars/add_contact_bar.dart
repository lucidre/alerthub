// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/model/contacts/contact.dart';
import 'package:alerthub/features/user/presentation/controller/user_emergency_contact.dart';

class AddContactBar extends StatefulWidget {
  final Contact? contact;
  final String tag;
  const AddContactBar({
    super.key,
    this.contact,
    required this.tag,
  });

  @override
  State<AddContactBar> createState() => _AddContactBarState();
}

class _AddContactBarState extends State<AddContactBar> {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final countryController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.contact?.fullName ?? '';
    phoneNumberController.text = widget.contact?.phoneNumber ?? '';
    countryController.text = widget.contact?.country ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(space12),
          topRight: Radius.circular(space12),
        ),
      ),
      child: buildBody(),
    );
  }

  saveForm() {
    FocusScope.of(context).unfocus();
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      context
          .showErrorSnackBar(context.localization?.kindlyFillAllFields ?? '');
      return;
    }

    if (isLoading || isDeleting) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final contact = Contact(
        id: widget.contact?.id,
        fullName: nameController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        country: countryController.text.trim(),
      );
      // TODO: do the work of updating here.

      final controller =
          Get.find<UserEmergencyContactsController>(tag: widget.tag);
      controller.insertOrUpdateContact(contact);
      context.router.maybePop();
    } catch (exception) {
      context.showErrorSnackBar('An error occurred');
    }

    setState(() {
      isLoading = false;
    });
  }

  deleteContact() {
    FocusScope.of(context).unfocus();

    if (isLoading || isDeleting) {
      return;
    }

    setState(() {
      isDeleting = true;
    });

    try {
      final controller =
          Get.find<UserEmergencyContactsController>(tag: widget.tag);
      controller.deleteContact(widget.contact);
      context.router.maybePop();
    } catch (exception) {
      context.showErrorSnackBar('An error occurred');
    }
    setState(() {
      isDeleting = false;
    });
  }

  List<Widget> buildFullName() {
    return [
      Text('Name', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.next,
        decoration: context.inputDecoration(
            hintText: context.localization?.enterFullName ?? ''),
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Kindly provide the contact fullname.';
          }

          return null;
        },
        controller: nameController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildCountry() {
    return [
      Text('Country', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.done,
        decoration: context.inputDecoration(
            hintText: context.localization?.country ?? ''),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Kindly select the country.";
          }

          return null;
        },
        controller: countryController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildPhoneNumber() {
    return [
      Text('Phone number', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.next,
        decoration: context.inputDecoration(
            hintText: context.localization?.enterPhoneNumber ?? ''),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return context.localization?.providePhoneNumber ?? '';
          } else if (int.tryParse(value) == null) {
            return context.localization?.enterValidPhoneNumber ?? '';
          } else if (!$appUtil.isPhoneValid(value.trim())) {
            return context.localization?.enterValidPhoneNumber ?? '';
          }
          return null;
        },
        controller: phoneNumberController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  buildBody() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.contact == null ? 'Add contact' : 'Edit contact',
            style: satoshi600S14,
          ),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          ...buildFullName(),
          verticalSpacer12,
          ...buildPhoneNumber(),
          verticalSpacer12,
          ...buildCountry(),
          verticalSpacer16,
          AppBtn.from(
            onPressed: () => saveForm(),
            text: widget.contact != null ? 'Update' : 'Continue',
            isLoading: isLoading,
          ),
          verticalSpacer12,
          if (widget.contact != null)
            AppBtn.from(
              onPressed: () => deleteContact(),
              text: 'Delete',
              isLoading: isDeleting,
              bgColor: destructive600,
            ),
          verticalSpacer32,
        ],
      ),
    );
  }
}
