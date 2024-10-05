// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/controller/user_edit_profile_controller.dart';

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/shared/widgets/select_country.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class UserEditProfileScreen extends StatefulWidget {
  const UserEditProfileScreen({super.key});

  @override
  State<UserEditProfileScreen> createState() => _UserEditProfileScreenState();
}

class _UserEditProfileScreenState extends State<UserEditProfileScreen> {
  @override
  void initState() {
    super.initState();

    Get.put(
      UserEditProfileController(
        UserService(
          UserRepositoryImpl(
            UserRemoteDataSource(),
          ),
        ),
      ),
    );
    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  getData() async {
    try {
      final controller = Get.find<UserEditProfileController>();
      await controller.getData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  selectImage() async {
    try {
      final controller = Get.find<UserEditProfileController>();
      controller.selectImage();
    } catch (exception) {
      context.showErrorSnackBar(context.localization?.errorPickingImage ?? '');
    }
  }

  updateUserData() async {
    FocusScope.of(context).unfocus();
    try {
      final controller = Get.find<UserEditProfileController>();
      await controller.updateUserData();
      context.showSuccessSnackBar(context.localization?.profileEdited ?? '');
      context.router.maybePop();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(space12),
        child: GetX<UserEditProfileController>(builder: (controller) {
          final isFetching = controller.isFetching;
          final formKey = controller.formKey;
          final hasError = controller.hasError;

          return Form(
            key: formKey,
            child: isFetching
                ? context.buildLoadingWidget()
                : hasError
                    ? context.buildErrorWidget(onRetry: () => getData())
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: buildBody(controller),
                      ),
          );
        }),
      ),
    );
  }

  Column buildBody(UserEditProfileController controller) {
    final isLoading = controller.isLoading;
    final isImageFromFile = controller.isImageFromFile;
    final imagePath = controller.imagePath;
    final selectedCountry = controller.selectedCountry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildImage(
          imagePath,
          isImageFromFile,
        ).fadeInAndMoveFromBottom(),
        verticalSpacer12,
        ...buildEmail(),
        verticalSpacer12,
        ...buildFullName(),
        verticalSpacer12,
        ...buildPhoneNumber(),
        verticalSpacer12,
        ...buildCountry(selectedCountry),
        verticalSpacer24,
        AppBtn.from(
            onPressed: () => updateUserData(),
            isLoading: isLoading,
            isSecondary: context.$isDarkMode,
            text: context.localization?.update ?? ''),
      ],
    );
  }

  Widget buildImage(String? imagePath, bool isImageFromFile) {
    return Center(
      child: SizedBox(
        height: 230,
        width: 230,
        child: InkWell(
          onTap: () => selectImage(),
          splashColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: blackShade1Color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(space4),
                  border: Border.all(
                    color: neutral300,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: imagePath == null
                    ? const Icon(
                        CupertinoIcons.camera,
                        size: 40,
                      )
                    : isImageFromFile
                        ? Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          )
                        : AppImage(
                            imageUrl: imagePath,
                            fit: BoxFit.cover,
                          ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: neutral300),
                  ),
                  child: const Icon(
                    CupertinoIcons.add,
                    size: 20,
                    color: blackShade1Color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEmail() {
    final controller = Get.find<UserEditProfileController>();
    final emailController = controller.emailController;

    return [
      Text(context.localization?.email ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      InkWell(
        splashColor: Colors.transparent,
        onTap: () => context
            .showErrorSnackBar(context.localization?.dataCannotBeChanged ?? ''),
        child: Opacity(
          opacity: 0.7,
          child: IgnorePointer(
            ignoring: true,
            child: TextFormField(
              textInputAction: TextInputAction.next,
              decoration: context.inputDecoration(
                  hintText: context.localization?.enterEmail ?? ''),
              keyboardType: TextInputType.text,
              controller: emailController,
            ),
          ),
        ).fadeInAndMoveFromBottom(),
      ),
    ];
  }

  List<Widget> buildFullName() {
    final controller = Get.find<UserEditProfileController>();
    final fullNameController = controller.fullNameController;
    final phoneNumberFocusNode = controller.phoneNumberFocusNode;
    return [
      Text(context.localization?.fullName ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(phoneNumberFocusNode);
        },
        decoration: context.inputDecoration(
            hintText: context.localization?.enterFullName ?? ''),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return context.localization?.provideFullName ?? '';
          }
          return null;
        },
        controller: fullNameController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildPhoneNumber() {
    final controller = Get.find<UserEditProfileController>();
    final phoneNumberController = controller.phoneNumberController;
    final phoneNumberFocusNode = controller.phoneNumberFocusNode;
    return [
      Text(context.localization?.phoneNumber ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.done,
        focusNode: phoneNumberFocusNode,
        decoration: context.inputDecoration(
            hintText: context.localization?.enterPhoneNumber ?? ''),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return context.localization?.providePhoneNumber ?? '';
          }
          return null;
        },
        controller: phoneNumberController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildCountry(Country? selectedCountry) {
    return [
      Text(context.localization?.country ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      InkWell(
        splashColor: Colors.transparent,
        onTap: () async {
          final country = await context.showBottomBar(
            child: SelectCountryBar(
              country: selectedCountry,
            ),
          );

          if (country != null && country is Country) {
            Get.find<UserEditProfileController>().selectedCountry = country;
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(space12),
          decoration: BoxDecoration(
              border: Border.all(color: neutral200),
              color: whiteBrownBg1Color,
              borderRadius: BorderRadius.circular(cornersSmall)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedCountry == null
                      ? (context.localization?.selectCountry ?? '')
                      : '${selectedCountry.flagEmoji} ${selectedCountry.displayName}',
                  style: satoshi500S14.copyWith(
                      color: selectedCountry == null ? neutral400 : null),
                ),
              ),
              horizontalSpacer8,
              const Icon(
                Icons.arrow_drop_down_rounded,
                color: neutral400,
              )
            ],
          ),
        ),
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
      title: Text(context.localization?.editProfile ?? '', style: satoshi600S24)
          .fadeIn(),
    );
  }
}
