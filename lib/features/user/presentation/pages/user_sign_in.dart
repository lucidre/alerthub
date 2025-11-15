// ignore_for_file: use_build_context_synchronously
import 'package:alerthub/app_preferences.dart';
import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/controller/user_sign_in_controller.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/model/account_types.dart';

@RoutePage()
class UserSignInScreen extends StatefulWidget {
  const UserSignInScreen({super.key});

  @override
  State<UserSignInScreen> createState() => _UserSignInScreenState();
}

class _UserSignInScreenState extends State<UserSignInScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(
      UserSignInController(
        UserService(
          UserRepositoryImpl(
            UserRemoteDataSource(),
          ),
        ),
      ),
    );
    controller.resetFields();
  }

  void signInUser() async {
    FocusScope.of(context).unfocus();

    try {
      final controller = Get.find<UserSignInController>();
      final type = controller.accountType!;
      await controller.signInUser();
          
 

      await AppPreferences.setUserType(type: type.dropDownName);

      if (type == AccountType.healthcare) {
        Get.find<HealthCareBottomBarController>().goToHome();
        context.router.push(const HealthCareMainRoute());
      } else if (type == AccountType.user) {
        Get.find<UserBottomBarController>().goToHome();
        context.router.push(const UserMainRoute());
      }
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: true,
      appBar: buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(space12),
          child: Column(
            children: [
              Expanded(child: buildBody()),
              verticalSpacer12,
              buildTAndC(),
              verticalSpacer12,
            ],
          ),
        ),
      ),
    );
  }

  AppBtn buildTAndC() {
    return AppBtn.basic(
      onPressed: () => $appUtil.onLinkClicked(tAndC),
      child: Text(
        context.localization?.termsAndConditionsOfUse ?? '',
        style: satoshi600S12,
      ).fadeInAndMoveFromBottom(),
    );
  }

  buildBody() {
    return Obx(() {
      final controller = Get.find<UserSignInController>();
      final formKey = controller.formKey;
      final isLoading = controller.isLoading;
      return Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...buildEmail(),
              verticalSpacer12,
              ...buildPassword(),
              verticalSpacer12,
              ...buildAccountType(),
              verticalSpacer16,
              Align(
                alignment: Alignment.centerRight,
                child: AppBtn.basic(
                  onPressed: () {
                    context.router.push(const UserForgotPasswordRoute());
                  },
                  isSecondary: context.$isDarkMode,
                  child: Text(
                    context.localization?.forgotPassword ?? '',
                    style: satoshi600S12,
                  ).fadeInAndMoveFromBottom(),
                ),
              ),
              verticalSpacer16,
              AppBtn.from(
                onPressed: () => signInUser(),
                isLoading: isLoading,
                text: context.localization?.continueS ?? '',
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> buildAccountType() {
    return [
      Text('Account type', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller = Get.find<UserSignInController>();
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

  List<Widget> buildEmail() {
    return [
      Text(context.localization?.email ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller = Get.find<UserSignInController>();
        final passwordFocusNode = controller.passwordFocusNode;
        final emailController = controller.emailController;

        return TextFormField(
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
          decoration: context.inputDecoration(
              hintText: context.localization?.enterEmail ?? ''),
          keyboardType: TextInputType.text,
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
        final controller = Get.find<UserSignInController>();
        final passwordFocusNode = controller.passwordFocusNode;
        final passwordController = controller.passwordController;
        final isHidden = controller.isHidden;
        return TextFormField(
          textInputAction: TextInputAction.done,
          obscureText: isHidden,
          enableSuggestions: !isHidden,
          autocorrect: !isHidden,
          focusNode: passwordFocusNode,
          keyboardType: TextInputType.visiblePassword,
          decoration: context.inputDecoration(
            hintText: context.localization?.enterPassword ?? '',
            suffixIcon: IconButton(
              icon: Icon(
                isHidden ? Icons.visibility : Icons.visibility_off,
                color: neutral300,
              ),
              onPressed: () {
                Get.find<UserSignInController>().isHidden = !isHidden;
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.localization?.providePassword ?? '';
            } else if (value.length < 6) {
              return context.localization?.passwordLength ?? '';
            }
            return null;
          },
          controller: passwordController,
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
      title: Text(context.localization?.login ?? '', style: satoshi600S24)
          .fadeIn(),
    );
  }
}
