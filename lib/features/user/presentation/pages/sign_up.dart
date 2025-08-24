// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/model/account_types.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/controller/user_sign_up_controller.dart';
import 'package:alerthub/common_libs.dart';

@RoutePage()
class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final tag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    Get.put(
      UserSignUpController(
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
    Get.delete<UserSignUpController>(tag: tag);
    super.dispose();
  }

  void signUpUser() async {
    FocusScope.of(context).unfocus();

    try {
      final controller = Get.find<UserSignUpController>(tag: tag);
      await controller.signUpUser();
      context.showSuccessSnackBar(context.localization?.accountCreated ?? '');
      final accountType = controller.accountType;
      final email = controller.emailController.text;
      if (accountType == accountTypes[0]) {
        context.router.push(UserAccountSetupRoute(email: email));
      } else if (accountType == accountTypes[1]) {
        context.router.push(HospitalAccountSetupRoute(email: email));
      } else if (accountType == accountTypes[2]) {
        context.router.push(AmbulanceAccountSetupRoute(email: email));
      }
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
      final controller = Get.find<UserSignUpController>(tag: tag);
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
                ...buildEmail(),
                verticalSpacer12,
                ...buildPassword(),
                verticalSpacer12,
                ...buildConfirmPassword(),
                verticalSpacer12,
                ...buildAccountType(),
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
      final controller = Get.find<UserSignUpController>(tag: tag);
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

  List<Widget> buildEmail() {
    return [
      Text(context.localization?.email ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller = Get.find<UserSignUpController>(tag: tag);

        final passwordFocusNode = controller.passwordFocusNode;
        final emailController = controller.emailController;
        final emailFocusNode = controller.emailFocusNode;

        return TextFormField(
          textInputAction: TextInputAction.next,
          focusNode: emailFocusNode,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
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
        final controller = Get.find<UserSignUpController>(tag: tag);
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
        final controller = Get.find<UserSignUpController>(tag: tag);
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

  List<Widget> buildAccountType() {
    return [
      Text('Account type', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller = Get.find<UserSignUpController>(tag: tag);
        final accountType = controller.accountType;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: neutral200),
              color: whiteBrownBg1Color,
              borderRadius: BorderRadius.circular(cornersSmall)),
          child: DropdownButton<AccountType>(
            value: accountType,
            icon: const Icon(
              Icons.arrow_drop_down_rounded,
              color: neutral400,
            ),
            hint: Text(
              'Select your account type',
              style: satoshi500S14.copyWith(color: neutral400),
            ),
            style: satoshi500S14,
            alignment: Alignment.centerLeft,
            underline: const SizedBox(width: double.infinity),
            isExpanded: true,
            borderRadius: BorderRadius.circular(space4),
            padding: const EdgeInsets.only(left: space12, right: space12),
            items: accountTypes.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value.dropDownName,
                  style: satoshi500S14,
                ),
              );
            }).toList(),
            onChanged: (AccountType? newValue) =>
                controller.accountType = newValue,
          ),
        ).fadeInAndMoveFromBottom();
      }),
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
