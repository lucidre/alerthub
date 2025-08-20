// ignore_for_file: avoid_print
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/panic/presentation/controller/panic_controller.dart';

import 'package:bluetooth_classic/models/device.dart';

@RoutePage()
class BluetoothListScreen extends StatefulWidget {
  const BluetoothListScreen({super.key});

  @override
  State<BluetoothListScreen> createState() => _BluetoothListScreenState();
}

class _BluetoothListScreenState extends State<BluetoothListScreen> {
  Widget buildPairedList() {
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
            'Paired Devices',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          GetX<PanicController>(builder: (controller) {
            final devices = controller.devices;
            final pairedDevice = controller.pairedDevice;
            final deviceString = controller.deviceString;
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              itemBuilder: (ctx, index) {
                final device = devices[index];
                return InkWell(
                  onTap: () => controller.onTapDevice(device),
                  child: Container(
                    padding: const EdgeInsets.all(space12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            device.name ?? device.address,
                            style: satoshi500S14,
                          ),
                        ),
                        horizontalSpacer8,
                        if (device == pairedDevice)
                          Text(
                            'Connected',
                            style: satoshi500S12.copyWith(color: primary800),
                          ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, _) => verticalSpacer12,
              itemCount: devices.length,
            );
          })
        ],
      ),
    );
  }

  Widget buildAvailiableList() {
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
            'Discovered Devices',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          GetX<PanicController>(builder: (controller) {
            final discoveredDevices = controller.discoveredDevices;
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              itemBuilder: (ctx, index) {
                final device = discoveredDevices[index];
                return InkWell(
                  onTap: () => context.showInformationSnackBar(
                      'Kindly connect to these device via your phone settings'),
                  child: Container(
                    padding: const EdgeInsets.all(space12),
                    child: Text(
                      device.name ?? device.address,
                      style: satoshi500S14,
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, _) => verticalSpacer12,
              itemCount: discoveredDevices.length,
            );
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: Container(
        padding: const EdgeInsets.all(space12),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: buildBody(),
        ),
      ),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        buildItem1(),
        verticalSpacer12,
        buildButtons(),
        verticalSpacer12,
        buildPairedList(),
        verticalSpacer12,
        buildAvailiableList(),
        // Text("Received data: ${String.fromCharCodes(_data)}"),
      ],
    );
  }

  Obx buildButtons() {
    return Obx(() {
      final controller = Get.find<PanicController>();
      final deviceStatus = controller.deviceStatus;

      if (deviceStatus == Device.connected) {
        return Column(
          children: [
            AppBtn.from(
              onPressed: () => controller.turnOnAlert(),
              text: 'Alert On',
            ),
            verticalSpacer12,
            AppBtn.from(
              onPressed: () => controller.turnOffAlert(),
              text: 'Alert Off',
            ),
            verticalSpacer12,
          ],
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Obx buildItem1() {
    return Obx(() {
      final controller = Get.find<PanicController>();
      final deviceStatus = controller.deviceStatus;
      final device = controller.pairedDevice;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(space12),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(space4),
          border: Border.all(color: neutral200),
        ),
        child: Text(
          deviceStatus == Device.connected
              ? 'Currently connected to ${device?.name ?? device?.address}'
              : 'Kindly select a bluetooth device below',
          style: satoshi600S14,
        ),
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
      title: Text('Bluetooth List', style: satoshi600S24).fadeIn(),
      actions: [
        PopupMenuButton<int>(
          onSelected: (int position) {
            final controller = Get.find<PanicController>();
            if (position == 0) {
              controller.disconnect();
            } else if (position == 1) {
              controller.getDevices();
            } else if (position == 2) {
              controller.scan();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            if (Get.find<PanicController>().deviceStatus == Device.connected)
              PopupMenuItem(
                value: 0,
                child: Text(
                  'Disconnect Device',
                  style: satoshi500S14,
                ),
              ),
            PopupMenuItem(
              value: 1,
              child: Text(
                'Refresh Devices',
                style: satoshi500S14,
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(
                'Scan For Devices',
                style: satoshi500S14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
