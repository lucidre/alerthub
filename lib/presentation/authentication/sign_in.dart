// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/api/firebase_util.dart';
import 'package:alerthub/common_libs.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isHidden = true;
  bool isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void saveForm() {
    FocusScope.of(context).unfocus();

    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid || isLoading) {
      return;
    }

    formKey.currentState?.save();
    showLoginStatus();
  }

  Future showLoginStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      await $firebaseUtil.logIn(email, password);

      context.router.push(const MainRoute());
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(space12),
          child: Column(
            children: [
              Expanded(
                child: buildBody(),
              ),
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
        'Terms and Conditions of Use',
        style: satoshi600S12,
      ).fadeInAndMoveFromBottom(),
    );
  }

  Form buildBody() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...buildEmail(),
            verticalSpacer12,
            ...buildPassword(),
            verticalSpacer16,
            Align(
              alignment: Alignment.centerRight,
              child: AppBtn.basic(
                onPressed: () {
                  context.router.push(const ForgotPasswordRoute());
                },
                isSecondary: context.$isDarkMode,
                child: Text(
                  'Forgot password?',
                  style: satoshi600S12,
                ).fadeInAndMoveFromBottom(),
              ),
            ),
            verticalSpacer16,
            AppBtn.from(
              onPressed: () => saveForm(),
              isLoading: isLoading,
              text: 'Continue',
            ),
            verticalSpacer16,
            Row(
              children: [
                Expanded(child: context.divider),
                horizontalSpacer12,
                Text(
                  'OR',
                  style: satoshi500S14,
                ),
                horizontalSpacer12,
                Expanded(child: context.divider),
              ],
            ).fadeInAndMoveFromBottom(),
            verticalSpacer16,
            AppBtn.from(
              onPressed: () {},
              isOutlined: true,
              text: 'Sign in with Google',
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
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(passwordFocusNode);
        },
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

  List<Widget> buildPassword() {
    return [
      Text('Password', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.done,
        obscureText: isHidden,
        enableSuggestions: !isHidden,
        autocorrect: !isHidden,
        focusNode: passwordFocusNode,
        keyboardType: TextInputType.visiblePassword,
        decoration: context.inputDecoration(
          hintText: "Enter password",
          suffixIcon: IconButton(
            icon: Icon(
              isHidden ? Icons.visibility : Icons.visibility_off,
              color: neutral300,
            ),
            onPressed: () {
              setState(() {
                isHidden = !isHidden;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please provide your password";
          } else if (value.length < 6) {
            return "Password must be more than 6 letters";
          }
          return null;
        },
        controller: passwordController,
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
      title: Text('Login', style: satoshi600S24).fadeIn(),
    );
  }
}
