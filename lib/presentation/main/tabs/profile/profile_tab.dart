import 'package:alerthub/common_libs.dart';
import 'package:flutter/cupertino.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: null,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Text('Profile', style: satoshi600S24).fadeIn(),
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_active_outlined,
          ),
        ),
        IconButton(
          onPressed: () => context.router.push(const SettingsRoute()),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildAppBar(),
        buildProfile().fadeInAndMoveFromBottom(),
        verticalSpacer16,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(space12),
          margin: const EdgeInsets.only(
            left: space12,
            right: space12,
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(space4),
            border: Border.all(color: neutral200),
          ),
          child: Row(
            children: [
              Text(
                'Your Posted Events',
                style: satoshi600S12,
              ),
              const Spacer(),
              AppBtn.basic(
                onPressed: () {},
                child: const Icon(
                  Icons.open_in_new,
                  color: blackColor,
                ),
              )
            ],
          ),
        ).fadeInAndMoveFromBottom(),
        verticalSpacer12,
        Expanded(child: buildList())
      ],
    );
  }

  buildList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: space12, right: space12),
      child: Column(
        children: [
          eventCard().fadeInAndMoveFromBottom(),
          verticalSpacer12,
          eventCard().fadeInAndMoveFromBottom(),
          verticalSpacer12,
          eventCard().fadeInAndMoveFromBottom(),
          verticalSpacer12,
          eventCard().fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }

  Widget buildProfile() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(space12),
        margin: const EdgeInsets.only(
          left: space12,
          right: space12,
        ),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(space4),
          border: Border.all(color: neutral200),
        ),
        child: GestureDetector(
          onTap: () {
            context.router.push(const EditProfileRoute());
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                    color: blackShade1Color.withOpacity(.1),
                    borderRadius: BorderRadius.circular(space4)),
                child: const Icon(
                  CupertinoIcons.camera_fill,
                  size: 40,
                ),
              ),
              horizontalSpacer12,
              Expanded(
                  child: SizedBox(
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Oti Temitope Emmanuel',
                      style: satoshi600S14,
                    ),
                    verticalSpacer8,
                    Text(
                      'otitemitope6@gmail.com',
                      style: satoshi500S12,
                    ),
                    verticalSpacer8,
                    Text(
                      loremIspidiumLong,
                      style: satoshi500S12,
                      maxLines: 1,
                    ),
                    const Spacer(),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.edit_square,
                        color: blackShade1Color,
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ));
  }

  Container eventCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Row(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: blackShade1Color.withOpacity(.1),
              borderRadius: BorderRadius.circular(space4),
            ),
          ),
          horizontalSpacer12,
          Expanded(
              child: SizedBox(
            height: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loremIspidiumTitle, style: satoshi600S14),
                verticalSpacer8,
                Text(
                  loremIspidiumLong,
                  style: satoshi500S12,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpacer8,
                Expanded(
                  child: Text(
                    'Ojota Axis',
                    style: satoshi500S12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                verticalSpacer8,
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'High Priority',
                    style: satoshi600S12.copyWith(color: destructive600),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
