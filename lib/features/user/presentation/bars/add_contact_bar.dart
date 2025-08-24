// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/model/contacts/contact.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/controller/add_edit_emergency_contact.dart';

class AddContactBar extends StatefulWidget {
  final Contact? contact;

  const AddContactBar({
    super.key,
    this.contact,
  });

  @override
  State<AddContactBar> createState() => _AddContactBarState();
}

class _AddContactBarState extends State<AddContactBar> {
  final tag = UniqueKey().toString();
  @override
  void initState() {
    super.initState();

    final controller = Get.put(
      AddEditEmergencyContactsController(
        UserService(
          UserRepositoryImpl(
            UserRemoteDataSource(),
          ),
        ),
      ),
      tag: tag,
    );

    if (widget.contact != null) {
      controller.restoreOldContact(widget.contact!);
    }
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

    try {
      final controller = Get.find<AddEditEmergencyContactsController>(tag: tag);
      controller.saveContact();
      context.router.maybePop(true);
    } catch (exception) {
      context.showErrorSnackBar('An error occurred');
    }
  }

  deleteContact() {
    FocusScope.of(context).unfocus();

    try {
      final controller = Get.find<AddEditEmergencyContactsController>(tag: tag);
      controller.deleteContact();
      context.router.maybePop(true);
    } catch (exception) {
      context.showErrorSnackBar('An error occurred');
    }
  }

  List<Widget> buildFullName() {
    return [
      Text('Name', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller =
            Get.find<AddEditEmergencyContactsController>(tag: tag);
        final nameController = controller.nameController;
        return TextFormField(
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
        ).fadeInAndMoveFromBottom();
      }),
    ];
  }

  List<Widget> buildCountry() {
    return [
      Text('Country', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller =
            Get.find<AddEditEmergencyContactsController>(tag: tag);
        final countryController = controller.countryController;
        return TextFormField(
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
        ).fadeInAndMoveFromBottom();
      }),
    ];
  }

  List<Widget> buildPhoneNumber() {
    return [
      Text('Phone number', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller =
            Get.find<AddEditEmergencyContactsController>(tag: tag);
        final phoneNumberController = controller.phoneNumberController;

        return TextFormField(
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
        ).fadeInAndMoveFromBottom();
      }),
    ];
  }

  buildBody() {
    return GetX<AddEditEmergencyContactsController>(
        tag: tag,
        builder: (controller) {
          final formKey = controller.formKey;
          final isLoading = controller.isLoading;
          final isDeleting = controller.isDeleting;
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
        });
  }
}
