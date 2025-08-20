// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/model/user_data/user.dart';

class HealthCareUserInformationBar extends StatefulWidget {
  final User user;
  const HealthCareUserInformationBar({
    super.key,
    required this.user,
  });

  @override
  State<HealthCareUserInformationBar> createState() =>
      _HealthCareUserInformationBarState();
}

class _HealthCareUserInformationBarState
    extends State<HealthCareUserInformationBar> {
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
          if (true) ...[
            verticalSpacer12,
            AppBtn.from(
              onPressed: () {},
              text: 'Accept Request',
            ),
            verticalSpacer12,
            AppBtn.from(
              bgColor: destructive700,
              onPressed: () {},
              text: 'Decline Request',
            )
          ],
          if (true) ...[
            verticalSpacer12,
            AppBtn.from(
              onPressed: () {},
              text: 'Assign Driver',
            ),
          ],
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
            'User information',
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
                child: AppImage(imageUrl: widget.user.imageUrl ?? ''),
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
                    'Phone: ${widget.user.phoneNumber ?? 'Unknown'}',
                    style: satoshi500S12,
                    softWrap: true,
                  ).fadeInAndMoveFromBottom(),
                  verticalSpacer4,
                  Text(
                    'Country: ${widget.user.country ?? 'Unknown'}',
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
            'User location',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            'Information unavailiable. Location details are only provided in the  case of an ongoing emergency. ',
            style: satoshi500S12,
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    ).fadeInAndMoveFromBottom();
  }
}
