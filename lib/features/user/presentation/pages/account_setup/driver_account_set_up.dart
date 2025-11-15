// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/hospitals/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/driver.dart';
import 'package:alerthub/features/hospitals/data/repositorites/hospitals_repository_impl.dart';
import 'package:alerthub/features/hospitals/domain/usecases/hospital_service.dart';
import 'package:alerthub/features/user/presentation/controller/driver_account_controller.dart';
import 'package:alerthub/common_libs.dart';

@RoutePage()
class DriverAccountSetupScreen extends StatefulWidget {
  final Driver? driver;
  const DriverAccountSetupScreen({
    super.key,
    this.driver,
  });

  @override
  State<DriverAccountSetupScreen> createState() =>
      _DriverAccountSetupScreenState();
}

class _DriverAccountSetupScreenState extends State<DriverAccountSetupScreen> {
  final tag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    final controller = Get.put(
      DriverAccountSetupController(
        HospitalService(
          HospitalRepositoryImpl(
            HospitalRemoteDataSource(),
          ),
        ),
      ),
      tag: tag,
    );
    if (widget.driver != null) {
      controller.setUpDriver(widget.driver!);
    }
  }

  @override
  void dispose() {
    Get.delete<DriverAccountSetupController>(tag: tag);
    super.dispose();
  }

  void signUpUser() async {
    FocusScope.of(context).unfocus();

    try {
      final controller = Get.find<DriverAccountSetupController>(tag: tag);
      await controller.updateDriver(widget.driver);
      context.showInformationSnackBar('Driver details updated successfully.');
      context.router.maybePop();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  void deleteDriver() async {
    FocusScope.of(context).unfocus();

    try {
      final controller = Get.find<DriverAccountSetupController>(tag: tag);
      await controller.deleteDriver(widget.driver!);
      context.showInformationSnackBar('Driver deleted successfully.');
      context.router.maybePop();
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
      final controller = Get.find<DriverAccountSetupController>(tag: tag);
      final isLoading = controller.isLoading;
      final isDeleting = controller.isDeleting;
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
                buildHospitalName(),
                verticalSpacer12,
                ...buildEmail(),
                verticalSpacer12,
                ...buildHelpLine(),
                verticalSpacer12,
                ...buildPassword(),
                verticalSpacer16,
                AppBtn.from(
                    onPressed: () => signUpUser(),
                    isLoading: isLoading,
                    text: context.localization?.continueS ?? ''),
                if (widget.driver != null) ...[
                  verticalSpacer12,
                  AppBtn.from(
                      onPressed: () => deleteDriver(),
                      isLoading: isDeleting,
                      text: 'Delete Driver'),
                ],
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
      final controller = Get.find<DriverAccountSetupController>(tag: tag);
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

  Widget buildHospitalName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name', style: satoshi500S12).fadeInAndMoveFromBottom(),
        verticalSpacer8,
        Obx(() {
          final controllerD = Get.find<DriverAccountSetupController>(tag: tag);
          final controller = controllerD.nameController;

          return TextFormField(
            textInputAction: TextInputAction.next,
            decoration: context.inputDecoration(
                hintText: context.localization?.enterFullName ?? ''),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Kindly provide the name.';
              }

              return null;
            },
            controller: controller,
          );
        }).fadeInAndMoveFromBottom(),
      ],
    );
  }

  List<Widget> buildHelpLine() {
    return [
      Text('Contact', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      Obx(() {
        final controller = Get.find<DriverAccountSetupController>(tag: tag);
        final helplineController = controller.contactController;

        return TextFormField(
          textInputAction: TextInputAction.next,
          decoration: context.inputDecoration(hintText: 'Enter contact'),
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
          controller: helplineController,
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
        final controller = Get.find<DriverAccountSetupController>(tag: tag);

        final emailController = controller.emailController;

        return TextFormField(
          textInputAction: TextInputAction.next,
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
        final controller = Get.find<DriverAccountSetupController>(tag: tag);
        final passwordController = controller.passwordController;

        return TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          decoration: context.inputDecoration(
              hintText: context.localization?.enterPassword ?? ''),
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
      title: Text('Profile setup', style: satoshi600S24).fadeIn(),
    );
  }
}
