import 'package:alerthub/common_libs.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: false,
      body: buildBody(),
    );
  }

  buildBody() {
    return Stack(
      children: [
        buildBackgroundColor(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.top),
            buildHeader().fadeInAndMoveFromBottom(),
            verticalSpacer12,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(space4),
                    topRight: Radius.circular(space4),
                  ),
                ),
                padding: const EdgeInsets.all(space12),
                child: buildList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(space4),
              border: Border.all(color: neutral200),
            ),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(space4),
              border: Border.all(color: neutral200),
            ),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(space4),
              border: Border.all(color: neutral200),
            ),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(space4),
              border: Border.all(color: neutral200),
            ),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
        ],
      ),
    );
  }

  Padding buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: space12, right: space12),
      child: Row(
        children: [
          buildBackButton().fadeInAndMoveFromBottom(),
          horizontalSpacer12,
          Expanded(child: buildSearchField().fadeInAndMoveFromBottom()),
          horizontalSpacer12,
          buildFilterButton().fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }

  Container buildFilterButton() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(color: neutral300),
        borderRadius: BorderRadius.circular(space4),
      ),
      child: const Icon(
        CupertinoIcons.slider_horizontal_3,
        color: blackColor,
      ),
    );
  }

  GestureDetector buildBackButton() {
    return GestureDetector(
      onTap: () => context.router.maybePop(),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: whiteColor,
          border: Border.all(
            color: neutral300,
          ),
          borderRadius: BorderRadius.circular(space4),
        ),
        child: const Icon(
          CupertinoIcons.chevron_back,
          color: blackColor,
        ),
      ),
    );
  }

  TextFormField buildSearchField() {
    return TextFormField(
      textInputAction: TextInputAction.search,
      decoration: context.inputDecoration(
          hintText: "Search event or location",
          fillColor: whiteColor,
          borderSide: const BorderSide(color: neutral300)),
      keyboardType: TextInputType.name,
      // controller: searchController,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: null,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
    );
  }

  Container buildBackgroundColor() {
    return Container(
      width: double.infinity,
      height: context.screenHeight * .6,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF333333),
            Color(0xFF2C2929),
          ],
        ),
      ),
    );
  }
}
