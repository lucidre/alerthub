// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/controller/emergency_info_controller.dart';

class EmergencyInformationBar extends StatefulWidget {
  const EmergencyInformationBar({super.key});

  @override
  State<EmergencyInformationBar> createState() =>
      _EmergencyInformationBarState();
}

class _EmergencyInformationBarState extends State<EmergencyInformationBar> {
  final tag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    Get.put(
      EmergencyInfoController(
        UserService(
          UserRepositoryImpl(
            UserRemoteDataSource(),
          ),
        ),
      ),
      tag: tag,
    );

    Future.delayed(Duration.zero, () => getData());
  }

 


  getData() async {
    try {
      final controller = Get.find<EmergencyInfoController>(tag: tag);

      await controller.fetchEmergencyInfo();
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: space12,
        left: space12,
        right: space12,
        bottom: space12 + context.bottom,
      ),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(space12),
          topRight: Radius.circular(space12),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: buildBody(),
      ),
    );
  }

  saveForm() async {
    FocusScope.of(context).unfocus();

    try {
      final controller = Get.find<EmergencyInfoController>(tag: tag);

      await controller.updateDescription();

      context.router.maybePop();
    } catch (exception) {
      context.showErrorSnackBar('An error occurred');
    }
  }

  List<Widget> buildDescription() {
    final controller = Get.find<EmergencyInfoController>(tag: tag);
    final descriptionController = controller.descriptionController;
    return [
      Text('Description', style: satoshi500S12).fadeInAndMoveFromBottom(),
      verticalSpacer8,
      TextFormField(

          textInputAction: TextInputAction.next,
          decoration: context.inputDecoration(
              hintText: context.localization?.description ?? ''),
          keyboardType: TextInputType.text,
          minLines: 9,
          maxLines: null,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Kindly provide the description.';
            }

            return null;
          },
          controller: descriptionController,
      ).fadeInAndMoveFromBottom(), 
    ];
  }

  buildBody() {
    return Obx(() {
      final controller = Get.find<EmergencyInfoController>(tag: tag);
      final formKey = controller.formKey;
      final isFetchingData = controller.isFetchingData;
      final hasError = controller.hasError;

      return isFetchingData
          ? context.buildLoadingWidget()
          : hasError
              ? context.buildErrorWidget(onRetry: () => getData())
              : buildBodyItem(formKey);
    });
  }

  Form buildBodyItem(GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Emergency information',
            style: satoshi600S14,
          ),
          verticalSpacer12,
          Text(
            'Emergency information are displayed to community users in the case of an emergency. This would be useful to help display vital information you might want them to know in the case of an emergency.',
            style: satoshi500S14,
          ),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          ...buildDescription(),
          verticalSpacer12,
          Obx(() {
            final controller = Get.find<EmergencyInfoController>(tag: tag);
            final isLoading = controller.isLoading;
            return AppBtn.from(
              onPressed: () => saveForm(),
              text: 'Update',
              isLoading: isLoading,
            );
          }),
          verticalSpacer12,
        ],
      ),
    );
  }
}
