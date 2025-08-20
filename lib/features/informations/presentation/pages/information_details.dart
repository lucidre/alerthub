// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/informations/data/model/informations/information.dart';
import 'package:alerthub/common_libs.dart';

@RoutePage()
class InformationDetailsScreen extends StatefulWidget {
  final Information information;
  const InformationDetailsScreen({super.key, required this.information});

  @override
  State<InformationDetailsScreen> createState() =>
      _InformationDetailsScreenState();
}

class _InformationDetailsScreenState extends State<InformationDetailsScreen> {
  @override
  void initState() {
    super.initState();
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

  ListView buildBody() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      children: [
        buildVideo(),
        verticalSpacer16,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(space12),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(space4),
            border: Border.all(color: neutral200),
          ),
          child: Text(
            context.localization?.description ?? '',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
        ),
        verticalSpacer12,
        ...(widget.information.description ?? []).map(
          (e) => buildDescription(e),
        ),
      ],
    );
  }

  Container buildVideo() {
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
            'Video Explainer',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Container(
            width: double.infinity,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: blackShade1Color,
              borderRadius: BorderRadius.circular(space4),
            ),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: AppImage(
                imageUrl:
                    $appUtil.getYoutubeImage(widget.information.url ?? ''),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          verticalSpacer12,
          AppBtn.from(
            onPressed: () => $appUtil.openYoutube(widget.information.url ?? ''),
            text: 'Watch Video',
          ),
        ],
      ),
    );
  }

  Widget buildDescription(String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      margin: const EdgeInsets.only(bottom: space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Text(
        description,
        style: satoshi500S12,
      ).fadeInAndMoveFromBottom(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title:
          Text(widget.information.title ?? '', style: satoshi600S24).fadeIn(),
    );
  }
}
