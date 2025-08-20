import 'package:alerthub/common_libs.dart';
import 'package:map_location_picker/map_location_picker.dart';

class AddressPickerMoreBar extends StatelessWidget {
  final List<GeocodingResult> geocodingResultList;
  const AddressPickerMoreBar({super.key, required this.geocodingResultList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(space12),
      child: Column(
        children: [
          const SizedBox(width: double.infinity),
          Container(
            width: 70,
            height: 4,
            decoration: BoxDecoration(
              color: context.textColor.withValues(alpha: .4),
              borderRadius: BorderRadius.circular(space12),
            ),
          ),
          verticalSpacer12,
          Text(
            "Select Address",
            style: satoshi600S14,
          ),
          verticalSpacer12,
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0),
              children: geocodingResultList.map((element) {
                return InkWell(
                  onTap: () => Navigator.pop(context, element),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: neutral200),
                        color: whiteBrownBg1Color,
                        borderRadius: BorderRadius.circular(cornersSmall)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.only(bottom: space12),
                    padding: const EdgeInsets.all(space12),
                    child: Text(
                      element.formattedAddress ?? "",
                      style:
                          satoshi500S12.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
