// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';

class EmergencyInformationBar extends StatefulWidget {
  const EmergencyInformationBar({super.key});

  @override
  State<EmergencyInformationBar> createState() =>
      _EmergencyInformationBarState();
}

class _EmergencyInformationBarState extends State<EmergencyInformationBar> {
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(space12),
          topRight: Radius.circular(space12),
        ),
      ),
      child: buildBody(),
    );
  }

  saveForm() {
    FocusScope.of(context).unfocus();
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      context
          .showErrorSnackBar(context.localization?.kindlyFillAllFields ?? '');
      return;
    }

    if (isLoading || isDeleting) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // TODO: do the work of updating here.

      context.router.maybePop();
    } catch (exception) {
      context.showErrorSnackBar('An error occurred');
    }

    setState(() {
      isLoading = false;
    });
  }

  List<Widget> buildDescription() {
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
          AppBtn.from(
            onPressed: () => saveForm(),
            text: 'Update',
            isLoading: isLoading,
          ),
          verticalSpacer12,
        ],
      ),
    );
  }
}
