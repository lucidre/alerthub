import 'package:alerthub/common_libs.dart';

@RoutePage()
class ViewImageScreen extends StatelessWidget {
  final String imageUrl;
  const ViewImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(context),
      body: Container(
        padding: const EdgeInsets.all(space12),
        child: AppImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(
        color: context.textColor,
        onPressed: () => context.router.maybePop(),
      ),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
    );
  }
}
