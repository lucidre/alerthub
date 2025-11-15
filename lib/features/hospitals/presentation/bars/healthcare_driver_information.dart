// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart'; 
import 'package:alerthub/features/hospitals/data/model/hospital/driver.dart';

class HealthCareDriverInformationBar extends StatefulWidget {
  final Driver user;
  const HealthCareDriverInformationBar({
    super.key,
    required this.user,
  });

  @override
  State<HealthCareDriverInformationBar> createState() =>
      _HealthCareDriverInformationBarState();
}

class _HealthCareDriverInformationBarState
    extends State<HealthCareDriverInformationBar> {
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

  buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildUserInfo(),
          verticalSpacer12,
          buildUserLocation(),
          verticalSpacer12,
          buildAttachedUser(),
          verticalSpacer16,
          AppBtn.from(
            onPressed: () => context.router.maybePop(1),
            text: 'Edit Driver',
          ), 
          verticalSpacer32,
        ],
      ),
    );
  }

  Widget buildUserInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Driver information',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: blackShade1Color.withValues(alpha: .1),
                  border: Border.all(
                    color: neutral200,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  borderRadius: BorderRadius.circular(space4),
                ),
                child: AppImage(imageUrl: widget.user.images ?? ''),
              ).fadeInAndMoveFromBottom(),
              horizontalSpacer12,
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.fullName ?? '',
                    style: satoshi600S14,
                  ).fadeInAndMoveFromBottom(),
                  verticalSpacer8,
                  Text(
                    'Email: ${widget.user.email ?? 'Unknown'}',
                    style: satoshi500S12,
                    softWrap: true,
                  ).fadeInAndMoveFromBottom(),
                  verticalSpacer8,
                  Text(
                    'Phone: ${widget.user.contact ?? 'Unknown'}',
                    style: satoshi500S12,
                    softWrap: true,
                  ).fadeInAndMoveFromBottom(),
                  verticalSpacer4,
                  Text(
                    'Password: ${widget.user.password ?? 'Unknown'}',
                    style: satoshi500S12,
                    softWrap: true,
                  ).fadeInAndMoveFromBottom(),
                ],
              )),
            ],
          )
        ],
      ),
    ).fadeInAndMoveFromBottom();
  }

  Widget buildUserLocation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Driver location',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            widget.user.location ?? '',
            style: satoshi500S12,
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    ).fadeInAndMoveFromBottom();
  }

  Widget buildAttachedUser() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attached user',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            'NO ATTACHED USER',
            style: satoshi500S12,
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    ).fadeInAndMoveFromBottom();
  }
}
