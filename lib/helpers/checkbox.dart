import 'package:alerthub/common_libs.dart';

class SimpleCheckbox extends StatelessWidget {
  const SimpleCheckbox(
      {super.key,
      required this.active,
      required this.onToggled,
      this.isExpanded = true,
      this.label});
  final bool active;
  final bool isExpanded;
  final Widget? label;
  final Function(bool? onToggle) onToggled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        AppHaptics.mediumImpact();
        onToggled.call(!active);
      },
      child: IgnorePointer(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(cornersSmall),
                  ),
                ),
                value: active,
                visualDensity:
                    const VisualDensity(horizontal: 0.5, vertical: 0.5),
                activeColor: context.textColor,
                side: const BorderSide(color: neutral300),
                checkColor: context.backgroundColor,
                onChanged: (bool? active) {}),
            isExpanded ? Expanded(child: buildLabel()) : buildLabel()
          ],
        ),
      ),
    );
  }

  Widget buildLabel() {
    return label == null ? const SizedBox() : label!;
  }
}
