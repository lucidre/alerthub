import 'package:alerthub/common_libs.dart';

class AppFetchingProgressBar extends StatefulWidget {
  final Stream<bool> stream;

  const AppFetchingProgressBar({super.key, required this.stream});

  @override
  State<AppFetchingProgressBar> createState() => _AppFetchingProgressBarState();
}

class _AppFetchingProgressBarState extends State<AppFetchingProgressBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.stream,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return (snapshot.data ?? false) ? buildBody() : const SizedBox();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Container buildBody() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      margin: const EdgeInsets.all(space4),
      child: const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(blackShade1Color),
        ),
      ).fadeIn(),
    );
  }
}
