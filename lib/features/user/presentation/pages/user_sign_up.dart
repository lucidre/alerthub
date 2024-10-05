// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/controller/user_sign_up_controller.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/shared/widgets/select_country.dart';
import 'package:country_picker/country_picker.dart';

@RoutePage()
class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(
      UserSignUpController(
        UserService(
          UserRepositoryImpl(
            UserRemoteDataSource(),
          ),
        ),
      ),
    );
    controller.resetFields();
  }

  void signUpUser() async {
    FocusScope.of(context).unfocus();

    try {
      final controller = Get.find<UserSignUpController>();
      await controller.signUpUser();
      context.showSuccessSnackBar(context.localization?.accountCreated ?? '');
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
      final controller = Get.find<UserSignUpController>();
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
                buildFullName(),
                verticalSpacer12,
                ...buildEmail(),
                verticalSpacer12,
                ...buildPhoneNumber(),
                verticalSpacer12,
                ...buildCountry(),
                verticalSpacer12,
                ...buildPassword(),
                verticalSpacer12,
                ...buildConfirmPassword(),
                verticalSpacer12,
                buildTandCCheckbox(),
                verticalSpacer12,
                AppBtn.from(
                    onPressed: () => signUpUser(),
                    isLoading: isLoading,
                    text: context.localization?.continueS ?? ''),
                verticalSpacer32,
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildTandCCheckbox() {
    return Obx(() {
      final controller = Get.find<UserSignUpController>();
      final hasUserAgreed = controller.hasUserAgreed;
      return Row(
        children: [
          SimpleCheckbox(
            active: hasUserAgreed,
            isExpanded: false,
            onToggled: (value) {
              setState(() {
                if (value != null) {
                  controller.hasUserAgreed = value;
                }
              });
            },
          ),
          horizontalSpacer4,
          InkWell(
              splashColor: Colors.transparent,
              onTap: () => $appUtil.onLinkClicked(tAndC),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: '${context.localization?.agreeToTerms ?? ''} ',
                        style: satoshi600S12),
                    TextSpan(
                        text: context.localization?.termsAndConditions ?? '',
                        style: satoshi600S12.copyWith(
                          decoration: TextDecoration.underline,
                        )),
                    TextSpan(
                        text: ' ${context.localization?.ofUse ?? ''}',
                        style: satoshi600S12),
                  ],
                ),
                textAlign: TextAlign.start,
                textScaler: MediaQuery.of(context).textScaler,
              )),
          const Spacer(),
        ],
      );
    }).fadeInAndMoveFromBottom();
  }

  Widget buildFullName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.localization?.fullName ?? '', style: satoshi500S12)
            .fadeInAndMoveFromBottom(),
        verticalSpacer8,
        Obx(() {
          final controller = Get.find<UserSignUpController>();
          final emailFocusNode = controller.emailFocusNode;
          final fullNameController = controller.fullNameController;

          return TextFormField(
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(emailFocusNode),
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
        final controller = Get.find<UserSignUpController>();
        final passwordFocusNode = controller.passwordFocusNode;
        final phoneNumberController = controller.phoneNumberController;
        final phoneNumberFocusNode = controller.phoneNumberFocusNode;

        return TextFormField(
          textInputAction: TextInputAction.next,
          focusNode: phoneNumberFocusNode,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
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

  List<Widget> buildEmail() {
    return [
      Text(context.localization?.email ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller = Get.find<UserSignUpController>();

        final phoneNumberFocusNode = controller.phoneNumberFocusNode;
        final emailController = controller.emailController;
        final emailFocusNode = controller.emailFocusNode;

        return TextFormField(
          textInputAction: TextInputAction.next,
          focusNode: emailFocusNode,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(phoneNumberFocusNode);
          },
          decoration: context.inputDecoration(
              hintText: context.localization?.enterEmailAddress ?? ''),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.localization?.provideEmail ?? '';
            } else if (!$appUtil.isEmailValid(value.trim())) {
              return context.localization?.enterValidEmail ?? '';
            }
            return null;
          },
          controller: emailController,
        );
      }).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildPassword() {
    return [
      Text(context.localization?.password ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller = Get.find<UserSignUpController>();
        final retypePasswordController = controller.retypePasswordController;
        final isHidden = controller.isHidden;
        final retypePasswordFocusNode = controller.retypePasswordFocusNode;
        final passwordFocusNode = controller.passwordFocusNode;
        final passwordController = controller.passwordController;

        return TextFormField(
          textInputAction: TextInputAction.next,
          obscureText: isHidden,
          enableSuggestions: !isHidden,
          autocorrect: !isHidden,
          focusNode: passwordFocusNode,
          keyboardType: TextInputType.visiblePassword,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(retypePasswordFocusNode);
          },
          decoration: context.inputDecoration(
            hintText: context.localization?.enterPassword ?? '',
            suffixIcon: IconButton(
              icon: Icon(isHidden ? Icons.visibility : Icons.visibility_off,
                  color: neutral300),
              onPressed: () {
                setState(() {
                  controller.isHidden = !isHidden;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.localization?.providePassword ?? '';
            } else if (value.length < 6) {
              return context.localization?.passwordLength ?? '';
            } else if (value != retypePasswordController.text.trim()) {
              return context.localization?.passwordsMustMatch ?? '';
            }
            return null;
          },
          controller: passwordController,
        );
      }).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildConfirmPassword() {
    return [
      Text(context.localization?.confirmPassword ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller = Get.find<UserSignUpController>();
        final retypePasswordController = controller.retypePasswordController;
        final isHidden = controller.isHidden;
        final retypePasswordFocusNode = controller.retypePasswordFocusNode;
        final passwordController = controller.passwordController;

        return TextFormField(
          textInputAction: TextInputAction.done,
          obscureText: isHidden,
          enableSuggestions: !isHidden,
          autocorrect: !isHidden,
          focusNode: retypePasswordFocusNode,
          decoration: context.inputDecoration(
            hintText: context.localization?.reenterPassword ?? '',
            suffixIcon: IconButton(
              icon: Icon(
                isHidden ? Icons.visibility : Icons.visibility_off,
                color: neutral300,
              ),
              onPressed: () {
                setState(() {
                  controller.isHidden = !isHidden;
                });
              },
            ),
          ),
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.localization?.providePassword ?? '';
            } else if (value.length < 6) {
              return context.localization?.passwordLength ?? '';
            } else if (value != passwordController.text.trim()) {
              return context.localization?.passwordsMustMatch ?? '';
            }
            return null;
          },
          controller: retypePasswordController,
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
        final controller = Get.find<UserSignUpController>();
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
      title: Text(context.localization?.signUp ?? '', style: satoshi600S24)
          .fadeIn(),
    );
  }
}
