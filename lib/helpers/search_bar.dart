import 'package:alerthub/common_libs.dart';

class AppSearchBar extends StatelessWidget {
  final Function(String) onDone;
  final bool isClickable;
  final String? initialValue;
  final bool shimmerEnabled;
  final String? hint;
  const AppSearchBar(
      {Key? key,
      required this.onDone,
      this.initialValue,
      this.hint,
      this.isClickable = true,
      this.shimmerEnabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        if (!isClickable && !shimmerEnabled) {
          onDone.call('');
        }
      },
      child: AppShimmer(
        shimmerEnabled: shimmerEnabled,
        child: AbsorbPointer(
          absorbing: !isClickable,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cornersMedium),
              color: neutral100,
            ),
            child: TextFormField(
              textInputAction: TextInputAction.search,
              initialValue: initialValue,
              decoration: context.inputDecoration(
                icon: const Icon(
                  Icons.search_rounded,
                  color: neutral400,
                  size: 24,
                ),
                hintText: hint ?? 'Search',
                padding: const EdgeInsets.all(0),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: context.bodyMedium(),
              onFieldSubmitted: (value) {
                onDone.call(value);
              },
            ),
          ),
        ),
      ),
    ).fadeIn();
  }
}
