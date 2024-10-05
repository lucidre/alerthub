// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:country_picker/country_picker.dart';

class SelectCountryBar extends StatefulWidget {
  final Country? country;
  const SelectCountryBar({super.key, this.country});

  @override
  State<SelectCountryBar> createState() => _SelectCountryBarState();
}

class _SelectCountryBarState extends State<SelectCountryBar> {
  Country? selectedCountry;
  final countryList = CountryService().getAll();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      restorePreviousCountry();
      searchController.addListener(() => searchListener());

      setState(() {});
    });
  }

  restorePreviousCountry() {
    if (widget.country != null) {
      countryList.remove(widget.country);
      countryList.insert(0, widget.country!);
      selectedCountry = widget.country;
    }
  }

  searchListener() {
    final text = searchController.text.trim();
    if (text.isEmpty) return;
    final allCountry = CountryService().getAll();

    final searchList = allCountry.where((country) {
      final name = CountryLocalizations.of(context)
              ?.countryName(countryCode: country.countryCode)
              ?.replaceAll(RegExp(r"\s+"), " ") ??
          country.name;
      return name.toLowerCase().contains(text);
    });
    countryList.clear();
    countryList.addAll(searchList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(space12),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 80,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(space4),
              color: context.textColor.withOpacity(.8),
            ),
          ),
        ),
        verticalSpacer12,
        buildSearchField().fadeInAndMoveFromBottom(),
        verticalSpacer12,
        context.divider,
        verticalSpacer12,
        Expanded(
          child: countryList.isEmpty ? buildNoDataItem() : buildList(),
        ),
        verticalSpaceMedium,
        AppBtn.from(
          onPressed: () async {
            if (selectedCountry == null) {
              context.showErrorSnackBar('Kindly select a country.');
              return;
            }
            context.maybePop(selectedCountry);
          },
          isSecondary: context.$isDarkMode,
          expand: true,
          text: 'Continue',
        ),
        verticalSpaceLarge * 1.5,
      ],
    );
  }

  buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const BouncingScrollPhysics(),
      itemCount: countryList.length,
      itemBuilder: (ctx, index) {
        final country = countryList[index];
        final isSelected = country == selectedCountry;
        return _CountryItem(
            isSelected: isSelected,
            country: country,
            onPressed: () {
              setState(() {
                selectedCountry = country;
              });
            });
      },
    );
  }

  buildNoDataItem() {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child:
          context.buildNoDataWidget(body: 'No country matches search criteria'),
    );
  }

  TextFormField buildSearchField() {
    return TextFormField(
      textInputAction: TextInputAction.search,
      decoration: context.inputDecoration(hintText: "Search country"),
      keyboardType: TextInputType.name,
      controller: searchController,
    );
  }
}

class _CountryItem extends StatelessWidget {
  final bool isSelected;
  final Country country;
  final VoidCallback onPressed;
  const _CountryItem(
      {required this.isSelected,
      required this.country,
      required this.onPressed});

  onTap(BuildContext context) {
/*     country.nameLocalized = CountryLocalizations.of(context)
        ?.countryName(countryCode: country.countryCode)
        ?.replaceAll(RegExp(r"\s+"), " "); */
    onPressed.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: space12),
      padding: const EdgeInsets.only(left: space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: InkWell(
        onTap: () => onTap.call(context),
        child: Row(
          children: [
            flagWidget(context),
            horizontalSpacer12,
            Expanded(child: buildText(context)),
            SimpleRadioButton(
              active: isSelected,
              isExpanded: false,
              onToggled: (_) => onTap.call(context),
            )
          ],
        ).fadeInAndMoveFromBottom(),
      ),
    );
  }

  buildText(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: CountryLocalizations.of(context)
                      ?.countryName(countryCode: country.countryCode)
                      ?.replaceAll(RegExp(r"\s+"), " ") ??
                  country.name,
              style: satoshi600S14),
          TextSpan(
            text:
                " (${isRtl ? '' : '+'}${country.phoneCode}${isRtl ? '+' : ''})",
            style: satoshi500S14,
          ),
        ],
      ),
      textAlign: TextAlign.start,
      textScaler: MediaQuery.of(context).textScaler,
    );
  }

  flagWidget(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      width: isRtl ? 50 : null,
      child: Text(countryCodeToEmoji(), style: satoshi500S16),
    );
  }

  countryCodeToEmoji() {
    final int firstLetter = country.countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = country.countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}
