// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/controller/user_account_setup_controller.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/shared/widgets/select_country.dart';
import 'package:country_picker/country_picker.dart';

@RoutePage()
class UserAccountSetupScreen extends StatefulWidget {
  final String email;
  const UserAccountSetupScreen({
    super.key,
    required this.email,
  });

  @override
  State<UserAccountSetupScreen> createState() => _UserAccountSetupScreenState();
}

class _UserAccountSetupScreenState extends State<UserAccountSetupScreen> {
  final tag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    Get.put(
      UserAccoutSetupController(
        UserService(
          UserRepositoryImpl(
            UserRemoteDataSource(),
          ),
        ),
      ),
      tag: tag,
    );
  }

  @override
  void dispose() {
    Get.delete<UserAccoutSetupController>(tag: tag);
    super.dispose();
  }

  void signUpUser() async {
    FocusScope.of(context).unfocus();

    try {
      final controller = Get.find<UserAccoutSetupController>(tag: tag);
      await controller.signUpUser();
      context.showInformationSnackBar('Account details updated successfully.');
      context.router.replace(const UserSignInRoute());
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: builBody(),
      ),
    );
  }

  builBody() {
    return Obx(() {
      final controller = Get.find<UserAccoutSetupController>(tag: tag);
      final isLoading = controller.isLoading;
      final formKey = controller.formKey;
      return Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(space12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImage(),
                verticalSpacer12,
                buildFullName(),
                verticalSpacer12,
                ...buildPhoneNumber(),
                verticalSpacer12,
                ...buildCountry(),
                verticalSpacer12,
                AppBtn.from(
                    onPressed: () => signUpUser(),
                    isLoading: isLoading,
                    text: context.localization?.continueS ?? ''),
                verticalSpacer16,
                buildTermsAndConditions(),
                verticalSpacer32,
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildImage() {
    return Obx(() {
      final controller = Get.find<UserAccoutSetupController>(tag: tag);
      final profileImage = controller.profileImage;
      return Center(
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () => controller.selectImage(),
          borderRadius: BorderRadius.circular(150),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: space6,
                  right: space6,
                  left: space6,
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 150,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      border: Border.all(color: neutral200),
                      color: whiteBrownBg1Color,
                      borderRadius: BorderRadius.circular(cornersSmall)),
                  child: profileImage == null
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: context.textColor,
                        )
                      : Image.file(
                          profileImage,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(space12),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      border: Border.all(color: neutral200),
                      color: whiteBrownBg1Color,
                      borderRadius: BorderRadius.circular(cornersSmall)),
                  child: Icon(
                    Icons.edit_rounded,
                    color: context.textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).fadeInAndMoveFromBottom();
  }

  Center buildTermsAndConditions() {
    return Center(
      child: AppBtn.basic(
        isSecondary: context.$isDarkMode,
        onPressed: () => $appUtil.onLinkClicked(tAndC),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Terms',
                style: satoshi500S12.copyWith(fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: ' and '),
              TextSpan(
                  text: 'Conditions',
                  style: satoshi500S12.copyWith(fontWeight: FontWeight.w600)),
              const TextSpan(text: ' of use'),
            ],
            style: satoshi500S12.copyWith(fontWeight: FontWeight.w600),
          ),
          textAlign: TextAlign.center,
          textScaler: MediaQuery.of(context).textScaler,
        ),
      ),
    );
  }

  Widget buildFullName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.localization?.fullName ?? '', style: satoshi500S12)
            .fadeInAndMoveFromBottom(),
        verticalSpacer8,
        Obx(() {
          final controller = Get.find<UserAccoutSetupController>(tag: tag);
          final phoneNumberFocusNode = controller.phoneNumberFocusNode;
          final fullNameController = controller.fullNameController;

          return TextFormField(
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(phoneNumberFocusNode),
            decoration: context.inputDecoration(
                hintText: context.localization?.enterFullName ?? ''),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.localization?.provideFullName ?? '';
              }

              return null;
            },
            controller: fullNameController,
          );
        }).fadeInAndMoveFromBottom(),
      ],
    );
  }

  List<Widget> buildPhoneNumber() {
    return [
      Text(context.localization?.phoneNumber ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller = Get.find<UserAccoutSetupController>(tag: tag);
        final phoneNumberController = controller.phoneNumberController;
        final phoneNumberFocusNode = controller.phoneNumberFocusNode;

        return TextFormField(
          textInputAction: TextInputAction.next,
          focusNode: phoneNumberFocusNode,
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
        );
      }).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildCountry() {
    return [
      Text(context.localization?.country ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller = Get.find<UserAccoutSetupController>(tag: tag);
        final selectedCountry = controller.selectedCountry;
        return InkWell(
          splashColor: Colors.transparent,
          onTap: () async {
            final country = await context.showBottomBar(
              child: SelectCountryBar(
                country: selectedCountry,
              ),
            );

            if (country != null && country is Country) {
              controller.selectedCountry = country;
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
        );
      }).fadeInAndMoveFromBottom(),
    ];
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text('Profile setup', style: satoshi600S24).fadeIn(),
    );
  }
}
