// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/panic/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/panic/data/repositorites/panic_repository_impl.dart';
import 'package:alerthub/features/panic/domain/usecases/panic_service.dart';
import 'package:alerthub/features/panic/presentation/controller/panic_controller.dart';
import 'package:alerthub/common_libs.dart';

@RoutePage()
class PanicScreen extends StatefulWidget {
  const PanicScreen({super.key});

  @override
  State<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends State<PanicScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(PanicController(
      PanicService(
        PanicRepositoryImpl(
          PanicRemoteDataSource(),
        ),
      ),
    ));

    final controller = Get.find<LocationController>();
    controller.initLocationUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: Container(
        padding: const EdgeInsets.all(space12),
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            buildPanicItem1(),
            verticalSpacer12,
            buildInfo(),
            verticalSpacer12,
            /*     buildAlertSettings(),
            verticalSpacer12, */ 
            buildLocation(),
            verticalSpacer12,
            AppBtn.from(
              onPressed: () => context.router.push(const BluetoothListRoute()),
              text: 'Hardware Management',
            ),
          ],
        ));
  }

  Widget buildAlertSettings() {
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
            'Broadcast Settings',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Row(children: [
            Expanded(
              child: Text(
                'Broadcast to community.',
                style: satoshi500S14,
              ),
            ),
            Obx(() {
              final controller = Get.find<PanicController>();
              final isInAlert = controller.isInAlert;

              return Switch.adaptive(
                value: controller.broadcastToCommunity,
                activeColor: Colors.white,
                activeTrackColor: isInAlert ? destructive700 : kGoldDark,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: (isInAlert ? destructive700 : kGoldDark)
                    .withValues(alpha: 0.5),
                onChanged: (value) => controller.broadcastToCommunity = value,
              );
            }),
          ]).fadeInAndMoveFromBottom(),
          Row(children: [
            Expanded(
              child: Text(
                'Broadcast to healthcare providers.',
                style: satoshi500S14,
              ),
            ),
            Obx(() {
              final controller = Get.find<PanicController>();
              final isInAlert = controller.isInAlert;
              return Switch.adaptive(
                value: controller.broadcastToProviders,
                activeColor: Colors.white,
                activeTrackColor: isInAlert ? destructive700 : kGoldDark,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: (isInAlert ? destructive700 : kGoldDark)
                    .withValues(alpha: 0.5),
                onChanged: (value) => controller.broadcastToProviders = value,
              );
            }),
          ]).fadeInAndMoveFromBottom(),
          Row(children: [
            Expanded(
              child: Text(
                'Broadcast to saved contacts.',
                style: satoshi500S14,
              ),
            ),
            Obx(() {
              final controller = Get.find<PanicController>();
              final isInAlert = controller.isInAlert;
              return Switch.adaptive(
                value: controller.broadcastToContacts,
                activeColor: Colors.white,
                activeTrackColor: isInAlert ? destructive700 : kGoldDark,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: (isInAlert ? destructive700 : kGoldDark)
                    .withValues(alpha: 0.5),
                onChanged: (value) => controller.broadcastToContacts = value,
              );
            }),
          ]).fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }

  Widget buildLocation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Obx(() {
        final controller = Get.find<LocationController>();

        final position = controller.userPosition;
        final latitude = position?.latitude ?? -1;
        final longitude = position?.longitude ?? -1;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Currrent Location',
              style: satoshi600S14,
            ).fadeInAndMoveFromBottom(),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            Row(children: [
              Expanded(
                child: Text(
                  'Latitude:',
                  style: satoshi500S14,
                ),
              ),
              Text(
                latitude.toString(),
                style: satoshi500S14,
              ),
            ]).fadeInAndMoveFromBottom(),
            verticalSpacer12,
            Row(children: [
              Expanded(
                child: Text(
                  'Longitude:',
                  style: satoshi500S14,
                ),
              ),
              Text(
                longitude.toString(),
                style: satoshi500S14,
              ),
            ]).fadeInAndMoveFromBottom(),
          ],
        );
      }),
    );
  }

  Widget buildInfo() {
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
            'About Alert Mode',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            'Tap the alert button above to immediately send your current location to your selected contacts, nearby responders, and local hospitals. You can also provide information about common emergencies relevant to you, helping responders deliver quick and effective first aid. For added convenience, connect this system to compatible Bluetooth hardware for faster alerts and assistance.',
            style: satoshi500S14,
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }

  buildPanicItem1() {
    return GetX<PanicController>(builder: (controller) {
      final isInAlert = controller.isInAlert;

      return AnimatedBuilder(
        animation: controller.pulseAnimation,
        builder: (context, child) {
          final pulseOpacity =
              isInAlert ? 0.3 + (0.7 * controller.pulseAnimation.value) : 1.0;

          return AnimatedContainer(
            duration: medDuration,
            width: double.infinity,
            padding: const EdgeInsets.all(space12),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(space4),
              border: Border.all(
                width: isInAlert ? 2 + (pulseOpacity.clamp(0, 1) * 2) : 2,
                color: isInAlert
                    ? destructive700.withValues(alpha: pulseOpacity)
                    : neutral700,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: InkWell(
              onTap: () => controller.toggleAlert(), // Better to use a method
              child: Column(children: [
                Image.asset(
                  'assets/images/alert.png',
                  height: 150,
                ),
                verticalSpacer12,
                Text(
                  isInAlert
                      ? 'TAP TO TURN OFF ALERT MODE!'
                      : 'TAP TO TURN ON ALERT MODE!',
                  style: satoshi600S14.copyWith(
                    color: isInAlert
                        ? destructive700.withValues(alpha: pulseOpacity)
                        : null,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ]),
            ),
          );
        },
      );
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text('Alert Mode', style: satoshi600S24).fadeIn(),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_bluetooth_rounded),
          onPressed: () => context.router.push(const BluetoothListRoute()),
        ),
      ],
    );
  }
}
