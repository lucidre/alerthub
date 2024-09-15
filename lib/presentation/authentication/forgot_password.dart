// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';

@RoutePage()
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isHidden = true;
  bool isLoading = false;

  final emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
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
          child: Column(
            children: [
              Expanded(child: buildBody()),
              verticalSpacer12,
              AppBtn.basic(
                onPressed: () {
                  // context.router.push(const ForgotPasswordRoute());
                },
                child: Text(
                  'Terms and Conditions of Use',
                  style: satoshi600S12,
                ).fadeIn(),
              ),
              verticalSpacer12,
            ],
          ),
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
            Center(
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
            ),
            verticalSpacer16,
            Text('Forgot Password', style: satoshi600S24)
                .fadeInAndMoveFromBottom(),
            Text(
              'Enter the email associated with your account to recover your account.',
              style: satoshi500S14,
            ).fadeInAndMoveFromBottom(),
            verticalSpacer16,
            ...buildEmail(),
            verticalSpacer16,
            AppBtn.from(
              onPressed: saveForm,
              isLoading: isLoading,
              text: 'Continue',
            ),
            verticalSpacer32,
          ],
        ),
      ),
    );
  }

  List<Widget> buildEmail() {
    return [
      Text('Email', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.done,
        decoration: context.inputDecoration(hintText: "Enter email"),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please provide your email.";
          } else if (!$appUtil.isEmailValid(value.trim())) {
            return 'Please enter a valid email';
          }
          return null;
        },
        controller: emailController,
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
    );
  }
}
