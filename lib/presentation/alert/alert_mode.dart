import 'package:alerthub/common_libs.dart';

@RoutePage()
class AlertModeScreen extends StatefulWidget {
  const AlertModeScreen({super.key});

  @override
  State<AlertModeScreen> createState() => _AlertModeScreenState();
}

class _AlertModeScreenState extends State<AlertModeScreen> {
  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text('Alert Mode', style: satoshi600S24).fadeIn(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: false,
      appBar: buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(space12),
          child: buildBody(),
        ),
      ),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAlertButton(),
          verticalSpacer16,
          buildCurrentLocation(),
          verticalSpacer16,
          aboutAlertMode(),
        ],
      ),
    );
  }

  buildAlertButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
          border: Border.all(color: neutral200),
          color: shadeWhite,
          borderRadius: BorderRadius.circular(cornersSmall),
          boxShadow: [
            BoxShadow(
              color: context.textColor.withOpacity(.1),
              blurRadius: 2,
              offset: const Offset(-2, 2),
            )
          ]),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              'assets/images/alert.png',
              height: 250,
              width: 250,
            ),
          ),
          Text(
            'HOLD DOWN TO ACTIVATE ALERT MODE',
            style: satoshi600S12.copyWith(color: destructive600),
          ),
          verticalSpacer12,
          context.divider,
          // verticalSpacer12,
          Row(
            children: [
              Text(
                'Broadcast to contacts',
                style: satoshi500S14,
              ),
              const Spacer(),
              Switch.adaptive(
                value: false,
                onChanged: (_) {},
                activeColor: blackShade1Color,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Broadcast to community',
                style: satoshi500S14,
              ),
              const Spacer(),
              Switch.adaptive(
                value: true,
                onChanged: (_) {},
                activeColor: blackShade1Color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildCurrentLocation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        border: Border.all(color: neutral200),
        color: shadeWhite,
        borderRadius: BorderRadius.circular(cornersSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your current location', style: satoshi600S14),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(loremIspidiumLong, style: satoshi500S12),
        ],
      ).fadeInAndMoveFromBottom(),
    );
  }

  aboutAlertMode() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        border: Border.all(color: neutral200),
        color: shadeWhite,
        borderRadius: BorderRadius.circular(cornersSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About alert mode? ', style: satoshi600S14),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
              'Alert mode is a security feature set to broadcast your current location to members around you or family in case there was an emergency. Kindly note that this is a sensitive feature and should only be used in the case of actual emergency.',
              style: satoshi500S12),
        ],
      ).fadeInAndMoveFromBottom(),
    );
  }
}
