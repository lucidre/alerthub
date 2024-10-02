import 'package:alerthub/common_libs.dart';
import 'package:alerthub/presentation/settings/account_delete_bar.dart';
import 'package:alerthub/presentation/settings/change_password_bar.dart';
import 'package:alerthub/presentation/settings/logout_bar.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: false,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(space12),
          margin: const EdgeInsets.all(space12),
          decoration: BoxDecoration(
            border: Border.all(color: neutral200),
            color: shadeWhite,
            borderRadius: BorderRadius.circular(cornersSmall),
          ),
          child: Column(
            children: [
              const SettingsItem(
                title: 'Font preferences',
                icon: CupertinoIcons.textformat_abc_dottedunderline,
              ),
              verticalSpacer12,
              context.divider,
              verticalSpacer12,
              const SettingsItem(
                title: 'Notifications',
                icon: CupertinoIcons.bell,
              ),
              verticalSpacer12,
              context.divider,
              verticalSpacer12,
              const SettingsItem(
                title: 'Contact Us',
                icon: Icons.contact_mail_outlined,
              ),
              verticalSpacer12,
              context.divider,
              verticalSpacer12,
              SettingsItem(
                title: 'Change Password',
                icon: Icons.password_rounded,
                onPressed: () {
                  context.$showGeneralDialog(
                    barrierLabel: "Delete Bar",
                    child: const ChangePasswordBar(),
                  );
                },
              ),
              verticalSpacer12,
              context.divider,
              verticalSpacer12,
              const SettingsItem(
                title: 'Legal',
                icon: Icons.book_rounded,
              ),
              verticalSpacer12,
              context.divider,
              verticalSpacer12,
              SettingsItem(
                title: 'Logout',
                icon: Icons.logout_rounded,
                color: destructive600,
                onPressed: () => context.$showGeneralDialog(
                  child: const LogoutBar(),
                  barrierLabel: "Logout Bar",
                  dismissible: false,
                ),
              ),
              verticalSpacer12,
              context.divider,
              verticalSpacer12,
              SettingsItem(
                title: 'Delete Account',
                icon: Icons.delete_outline_rounded,
                color: destructive600,
                onPressed: () {
                  context.$showGeneralDialog(
                    barrierLabel: "Delete Bar",
                    child: const AccountDeleteBar(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text('Settings', style: satoshi600S24).fadeIn(),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  final VoidCallback? onPressed;

  const SettingsItem({
    super.key,
    required this.title,
    required this.icon,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onPressed?.call(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(space12),
        child: Row(
          children: [
            Icon(
              icon,
              color: color ?? context.textColor,
            ),
            horizontalSpacer12,
            Expanded(
              child: Text(
                title,
                style: satoshi500S14.copyWith(color: color),
              ),
            ),
            horizontalSpacer12,
            Icon(
              Icons.arrow_right_rounded,
              color: color ?? context.textColor,
            ),
          ],
        ),
      ),
    ).fadeInAndMoveFromBottom();
  }
}
