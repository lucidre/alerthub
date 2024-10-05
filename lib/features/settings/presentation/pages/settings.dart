import 'package:alerthub/features/settings/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/settings/data/repositorites/settings_repository_impl.dart';
import 'package:alerthub/features/settings/domain/usecases/setting_service.dart';
import 'package:alerthub/features/settings/presentation/controller/setting_controller.dart';
import 'package:alerthub/features/settings/presentation/widget/settings_item.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/settings/presentation/bars/account_delete_bar.dart';
import 'package:alerthub/features/settings/presentation/bars/change_password_bar.dart';
import 'package:alerthub/features/settings/presentation/bars/contact_us_bar.dart';
import 'package:alerthub/features/settings/presentation/bars/logout_bar.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(SettingController(
      SettingService(
        SettingRepositoryImpl(
          SettingRemoteDataSource(),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: false,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
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
            buildLanguage(),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            buildNotification(),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            buildContactUs(),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            buildChangePassword(),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            buildTermsAndConditions(),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            buildLogout(),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            buildDeleteAccount(),
          ],
        ),
      ),
    );
  }

  SettingsItem buildDeleteAccount() {
    return SettingsItem(
      title: context.localization?.deleteAccount ?? '',
      icon: Icons.delete_outline_rounded,
      color: destructive600,
      onPressed: () {
        context.$showGeneralDialog(
          barrierLabel: context.localization?.deleteBar ?? '',
          child: const AccountDeleteBar(),
        );
      },
    );
  }

  SettingsItem buildLogout() {
    return SettingsItem(
      title: context.localization?.logout ?? '',
      icon: Icons.logout_rounded,
      color: destructive600,
      onPressed: () => context.$showGeneralDialog(
        child: const LogoutBar(),
        barrierLabel: context.localization?.logoutBar ?? '',
        dismissible: false,
      ),
    );
  }

  SettingsItem buildTermsAndConditions() {
    return SettingsItem(
      title: context.localization?.termsAndConditions ?? '',
      icon: Icons.book_rounded,
      onPressed: () {
        $appUtil.onLinkClicked(tAndC);
      },
    );
  }

  SettingsItem buildChangePassword() {
    return SettingsItem(
      title: context.localization?.changePassword ?? '',
      icon: Icons.password_rounded,
      onPressed: () {
        context.$showGeneralDialog(
          barrierLabel: context.localization?.deleteBar ?? '',
          child: const ChangePasswordBar(),
        );
      },
    );
  }

  SettingsItem buildContactUs() {
    return SettingsItem(
      title: context.localization?.contactUs ?? '',
      icon: Icons.contact_mail_outlined,
      onPressed: () => context.showBottomBar(child: const ContactUsBar()),
    );
  }

  SettingsItem buildNotification() {
    return SettingsItem(
      title: context.localization?.notifications ?? '',
      icon: CupertinoIcons.bell,
      onPressed: () => context.router.push(const NotificationsRoute()),
    );
  }

  SettingsItem buildLanguage() {
    return SettingsItem(
      title: context.localization?.language ?? '',
      icon: CupertinoIcons.textformat_abc_dottedunderline,
      onPressed: () {
        context.router.push(const SettingLaunguageRoute());
      },
    );
  }

  buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text(context.localization?.settings ?? '', style: satoshi600S24)
          .fadeIn(),
    );
  }
}
