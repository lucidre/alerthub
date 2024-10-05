// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';

class ContactUsBar extends StatefulWidget {
  const ContactUsBar({super.key});

  @override
  State<ContactUsBar> createState() => _ContactUsBarState();
}

class _ContactUsBarState extends State<ContactUsBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: space12,
          right: space12,
          left: space12,
          bottom: space12 + context.bottom),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildTitle().fadeInAndMoveFromBottom(),
        verticalSpacer16,
        buildEmail(),
        verticalSpacer12,
        buildPhone(),
        verticalSpacer12,
        buildX(),
        verticalSpacer32,
      ],
    );
  }

  Container buildX() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          context.router.maybePop();
          $appUtil.onLinkClicked(twitter);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.web),
                horizontalSpacer8,
                Text(context.localization?.xTwitter ?? '',
                    style: satoshi600S14),
              ],
            ),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            Text(twitterUsername, style: satoshi500S14),
          ],
        ),
      ).fadeInAndMoveFromBottom(),
    );
  }

  Container buildPhone() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          context.router.maybePop();
          $appUtil.onPhoneClicked(phoneNumber);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.phone),
                horizontalSpacer8,
                Text(context.localization?.phone ?? '', style: satoshi600S14),
              ],
            ),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            Text(phoneNumber, style: satoshi500S14),
          ],
        ),
      ).fadeInAndMoveFromBottom(),
    );
  }

  Container buildEmail() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          context.router.maybePop();
          $appUtil.onEmailClicked(email);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.mail),
                horizontalSpacer8,
                Text(context.localization?.email ?? '', style: satoshi600S14),
              ],
            ),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            Text(email, style: satoshi500S14),
          ],
        ),
      ).fadeInAndMoveFromBottom(),
    );
  }

  Container buildTitle() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(space12),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(space4),
          border: Border.all(color: neutral200),
        ),
        child:
            Text(context.localization?.contactUs ?? '', style: satoshi600S14));
  }
}
