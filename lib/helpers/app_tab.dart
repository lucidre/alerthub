import 'package:alerthub/common_libs.dart';

class AppTabWidget extends StatelessWidget {
  final int index;
  final List<String> titles;
  final Function(int) onUpdate;
  const AppTabWidget(
      {super.key,
      required this.index,
      required this.titles,
      required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: const EdgeInsets.all(space4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: neutral200),
                color: neutral100),
            child: Row(
                children: titles
                    .map((title) => Expanded(
                        child: buildTabItem(title, titles.indexOf(title))))
                    .toList()))
        .fadeInAndMoveFromBottom();
  }

  Widget buildTabItem(String text, int index) {
    bool isSelected = this.index == index;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        onUpdate.call(index);
      },
      child: AnimatedContainer(
        duration: fastDuration,
        padding: EdgeInsets.only(
          right: space12 + (titles.length - 1 == index ? 0 : space4),
          left: space12,
          top: space6,
          bottom: space6,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: isSelected ? primary600 : neutral100),
        child: Text(text,
            style: satoshi500S12.copyWith(
                color: isSelected ? shadeWhite : neutral500)),
      ),
    );
  }
}
