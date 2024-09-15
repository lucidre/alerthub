import 'package:alerthub/common_libs.dart';
import 'package:alerthub/helpers/select_country.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Country? selectedCountry;

  bool isLoading = false;

  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final phoneNumberFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();

    phoneNumberFocusNode.dispose();

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
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(space12),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImage().fadeInAndMoveFromBottom(),
                verticalSpacer12,
                ...buildEmail(),
                verticalSpacer12,
                ...buildFullName(),
                verticalSpacer12,
                ...buildPhoneNumber(),
                verticalSpacer12,
                ...buildCountry(),
                verticalSpacer24,
                AppBtn.from(
                    onPressed: saveForm,
                    isLoading: isLoading,
                    isSecondary: context.$isDarkMode,
                    text: 'Update'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center buildImage() {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: blackShade1Color.withOpacity(.1),
          borderRadius: BorderRadius.circular(space4),
          border: Border.all(color: neutral300),
        ),
        child: const Icon(
          CupertinoIcons.camera,
          size: 40,
        ),
      ),
    );
  }

  List<Widget> buildEmail() {
    return [
      Text('Email', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      InkWell(
        splashColor: Colors.transparent,
        onTap: () => context.showErrorSnackBar('This data can not be changed.'),
        child: Opacity(
          opacity: 0.7,
          child: IgnorePointer(
            ignoring: true,
            child: TextFormField(
              textInputAction: TextInputAction.next,
              decoration: context.inputDecoration(hintText: "Enter email"),
              keyboardType: TextInputType.text,
              controller: emailController,
            ),
          ),
        ).fadeInAndMoveFromBottom(),
      ),
    ];
  }

  List<Widget> buildFullName() {
    return [
      Text('Full Name', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(phoneNumberFocusNode);
        },
        decoration: context.inputDecoration(hintText: "Enter full name"),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please provide your full name.";
          }
          return null;
        },
        controller: fullNameController,
      ).fadeInAndMoveFromBottom(),
    ];
  }

  List<Widget> buildPhoneNumber() {
    return [
      Text('Phone Number', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(
        textInputAction: TextInputAction.done,
        focusNode: phoneNumberFocusNode,
        decoration: context.inputDecoration(hintText: "Enter phone number"),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please provide your phone number.";
          }
          return null;
        },
        controller: phoneNumberController,
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
            child: SelectCountryBar(country: selectedCountry),
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
      title: Text('Edit Profile', style: satoshi600S24).fadeIn(),
    );
  }
}
