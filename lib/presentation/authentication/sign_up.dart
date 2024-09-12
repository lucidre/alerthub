// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/helpers/select_country.dart';
import 'package:country_picker/country_picker.dart';

//TODO make t and c clickable
@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Country? selectedCountry;
  bool hasUserAgreed = false;
  bool isHidden = true;
  bool isLoading = false;

  List<String> accountTypes = ['Angola', 'Nigeria'];

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();

  final phoneNumberFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final retypePasswordFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();

    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    retypePasswordFocusNode.dispose();

    super.dispose();
  }

  void saveForm() {
    FocusScope.of(context).unfocus();
    final isValid = formKey.currentState?.validate();

    if ((isValid ?? false) == false || isLoading) {
      if ((isValid ?? false) == false) {
        context.showErrorSnackBar("Kindly fill all fields to proceed.");
      }

      return;
    }

    if (selectedCountry == null) {
      context.showErrorSnackBar('Kindly select an account type to proceed.');
      return;
    }

    formKey.currentState?.save();
    pushData();
  }

  Future pushData() async {
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
      enableInternetCheck: false,
      appBar: buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
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
                      onPressed: saveForm,
                      isLoading: isLoading,
                      isSecondary: context.$isDarkMode,
                      text: 'Contine'),
                  verticalSpacer32,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SimpleCheckbox buildTandCCheckbox() {
    return SimpleCheckbox(
      active: hasUserAgreed,
      isExpanded: true,
      onToggled: (value) {
        setState(() {
          if (value != null) {
            hasUserAgreed = value;
          }
        });
      },
      label: Text(
        'I agree to the Terms and Conditions of Use',
        style: satoshi500S12,
      ),
    );
  }

  Widget buildFullName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Full name', style: satoshi500S12).fadeInAndMoveFromBottom(),
        verticalSpacer8,
        TextFormField(
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(phoneNumberFocusNode);
          },
          decoration:
              context.inputDecoration(hintText: "Enter your full name."),
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please provide your first name.";
            } else if (!$appUtil.isNameValid(value.trim())) {
              return 'Please enter a valid name';
            }

            return null;
          },
          controller: fullNameController,
        ).fadeInAndMoveFromBottom(),
      ],
    );
  }

  List<Widget> buildPhoneNumber() {
    return [
      Text('Phone number', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: phoneNumberFocusNode,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(passwordFocusNode);
        },
        decoration:
            context.inputDecoration(hintText: "Enter your phone number"),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please provide a phone number.";
          } else if (int.tryParse(value) == null) {
            return 'Please enter a valid phone number.';
          } else if (!$appUtil.isPhoneValid(value.trim())) {
            return 'Please enter a valid phone number.';
          }
          return null;
        },
        controller: phoneNumberController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildEmail() {
    return [
      Text('Email', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: emailFocusNode,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(phoneNumberFocusNode);
        },
        decoration:
            context.inputDecoration(hintText: "Enter your email address"),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please provide your email.";
          } else if (!$appUtil.isEmailValid(value.trim())) {
            return 'Please enter a valid email.';
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
          hintText: "Enter your password",
          suffixIcon: IconButton(
            icon: Icon(isHidden ? Icons.visibility : Icons.visibility_off,
                color: neutral300),
            onPressed: () {
              setState(() {
                isHidden = !isHidden;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please provide your password.";
          } else if (value.length < 6) {
            return "Password must be more than 6 letters.";
          } else if (value != retypePasswordController.text.trim()) {
            return "Passwords must be the same.";
          }
          return null;
        },
        controller: passwordController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildConfirmPassword() {
    return [
      Text('Confirm password', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.done,
        obscureText: isHidden,
        enableSuggestions: !isHidden,
        autocorrect: !isHidden,
        focusNode: retypePasswordFocusNode,
        decoration: context.inputDecoration(
          hintText: "Re-enter your password",
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
        keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please provide your password.";
          } else if (value.length < 6) {
            return "Password must be more than 6 letters.";
          } else if (value != passwordController.text.trim()) {
            return "Passwords must be the same.";
          }
          return null;
        },
        controller: retypePasswordController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildCountry() {
    return [
      Text('Country', style: satoshi500S12).fadeInAndMoveFromBottom(),
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
            setState(() {
              selectedCountry = country;
            });
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
                      ? 'Select your country'
                      : '${selectedCountry?.flagEmoji} ${selectedCountry?.displayName ?? 'Country'}',
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
      title: Text('Sign up', style: satoshi600S24).fadeIn(),
    );
  }
}
