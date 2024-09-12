/* // ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/presentation/authentication/tabs/forgot_password_tab_1.dart';
import 'package:alerthub/presentation/authentication/tabs/forgot_password_tab_2.dart';
import 'package:alerthub/presentation/authentication/tabs/forgot_password_tab_3.dart';

@RoutePage()
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int index = 0;
  String? emailOrPhone;
  String? token;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: false,
      appBar: buildAppBar(),
      backgroundColor: neutral50,
      body: buildBody(),
    );
  }

  Padding buildBody() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buildHeaderCircle(1),
              horizontalSpacer8,
              buildHeaderSpacer(2),
              horizontalSpacer8,
              buildHeaderCircle(2),
              horizontalSpacer8,
              buildHeaderSpacer(3),
              horizontalSpacer8,
              buildHeaderCircle(3),
            ],
          ),
          verticalSpacer16,
          Expanded(
              child: AnimatedSwitcher(
            duration: medDuration,
            child: index == 0
                ? ForgotPasswordTab1(onNext: (emailOrPhone) {
                    setState(() {
                      this.emailOrPhone = emailOrPhone;
                      index = 1;
                    });
                  })
                : index == 1
                    ? ForgotPasswordTab2(
                        text: emailOrPhone ?? '',
                        onNext: (token) {
                          setState(() {
                            this.token = token;
                            index = 2;
                          });
                        })
                    : index == 2
                        ? ForgotPasswordTab3(text: emailOrPhone ?? '')
                        : const SizedBox(),
          ))
        ],
      ),
    );
  }

  Widget buildHeaderCircle(int number) {
    bool isCurrent = index == (number - 1);
    bool isPast = index > (number - 1);
    return AnimatedContainer(
      duration: fastDuration,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPast ? neutral900 : Colors.transparent,
        border: Border.all(
          width: isCurrent || isPast ? 2 : 1,
          color: isCurrent || isPast ? neutral900 : neutral300,
        ),
      ),
      child: Text(
        number.toString(),
        style: satoshi500S12.copyWith(
          color: isPast
              ? shadeWhite
              : isCurrent
                  ? neutral800
                  : neutral500,
        ),
      ),
    );
  }

  Widget buildHeaderSpacer(int number) {
    bool isPast = index >= (number - 1);
    return Expanded(
      child: AnimatedContainer(
        duration: fastDuration,
        height: space4,
        padding: const EdgeInsets.all(space12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isPast ? neutral900 : neutral200,
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: false,
      forceMaterialTransparency: true,
      title: Text('Forgot password?', style: satoshi500S24).fadeIn(),
      leading: const BackButton(color: neutral800),
      elevation: 0,
      backgroundColor: neutral50,
    );
  }
}
 */