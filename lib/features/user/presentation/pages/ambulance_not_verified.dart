import 'package:alerthub/common_libs.dart';

@RoutePage()
class AmbulanceNotVerifiedScreen extends StatelessWidget {
  final String email;
  const AmbulanceNotVerifiedScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(space12),
        child: Column(children: [
          Text('Account Verication.', style: satoshi600S14),
          verticalSpacer8,
          Text(
            'Kindly notifiy your hosptital to verfiy your itendity in the upcoming program.',
            style: satoshi500S12,
          ),
          verticalSpacer16,
          AppBtn.from(
              onPressed: () {
                context.router
                    .replace(AmbulanceAccountSetupRoute(email: email));
              },
              text: 'Edit profile')
        ]),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text(context.localization?.signUp ?? '', style: satoshi600S24)
          .fadeIn(),
    );
  }
}
