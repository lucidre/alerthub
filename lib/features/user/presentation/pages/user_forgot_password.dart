// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/controller/user_forgot_password_controller.dart';
import 'package:alerthub/common_libs.dart';

@RoutePage()
class UserForgotPasswordScreen extends StatefulWidget {
  const UserForgotPasswordScreen({super.key});

  @override
  State<UserForgotPasswordScreen> createState() =>
      _UserForgotPasswordScreenState();
}

class _UserForgotPasswordScreenState extends State<UserForgotPasswordScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(
      UserForgotPasswordController(
        UserService(
          UserRepositoryImpl(
            UserRemoteDataSource(),
          ),
        ),
      ),
    );
    controller.resetFields();
  }

  void resetForgottenPassword() async {
    FocusScope.of(context).unfocus();
    try {
      final controller = Get.find<UserForgotPasswordController>();
      await controller.resetForgottenPassword();
      context.showSuccessSnackBar(
          context.localization?.resetPasswordMailSent ?? '');
      context.router.maybePop();
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
      onPressed: () {},
      child: Text(
        context.localization?.termsAndConditionsOfUse ?? '',
        style: satoshi600S12,
      ).fadeIn(),
    );
  }

  buildBody() {
    return Obx(
      () {
        final controller = Get.find<UserForgotPasswordController>();
        return Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLottie(),
                verticalSpacer16,
                Text(context.localization?.forgotPassword ?? '',
                        style: satoshi600S24)
                    .fadeInAndMoveFromBottom(),
                Text(
                  context.localization?.enterEmailToRecoverAccount ?? '',
                  style: satoshi500S14,
                ).fadeInAndMoveFromBottom(),
                verticalSpacer16,
                ...buildEmail(),
                verticalSpacer16,
                AppBtn.from(
                  onPressed: () => resetForgottenPassword(),
                  isLoading: controller.isLoading,
                  text: context.localization?.continueS ?? '',
                ),
                verticalSpacer32,
              ],
            ),
          ),
        );
      },
    );
  }

  Center buildLottie() {
    return Center(
      child: Transform.scale(
        scale: 1.2,
        child: Lottie.asset(
          lockLottie,
          animate: true,
          repeat: true,
          reverse: true,
          width: 250,
          height: 250,
          fit: BoxFit.contain,
        ),
      ).fadeInAndMoveFromBottom(),
    );
  }

  List<Widget> buildEmail() {
    return [
      Text(context.localization?.email ?? '', style: satoshi500S12)
          .fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller = Get.find<UserForgotPasswordController>();
        final emailController = controller.emailController;
        return TextFormField(
          textInputAction: TextInputAction.done,
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

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
    );
  }
}
