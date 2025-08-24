import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/model/contacts/contact.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/bars/add_contact_bar.dart';
import 'package:alerthub/features/user/presentation/controller/user_emergency_contact.dart';

@RoutePage()
class UserEmergencyContactScreen extends StatefulWidget {
  const UserEmergencyContactScreen({super.key});

  @override
  State<UserEmergencyContactScreen> createState() =>
      _UserEmergencyContactScreenState();
}

class _UserEmergencyContactScreenState
    extends State<UserEmergencyContactScreen> {
  final tag = UniqueKey().toString();

  @override
  initState() {
    super.initState();
    Get.put(
      UserEmergencyContactsController(
        UserService(
          UserRepositoryImpl(
            UserRemoteDataSource(),
          ),
        ),
      ),
      tag: tag,
    );

    Future.delayed(Duration.zero, () => getData());
  }

  getData() {
    try {
      final controller = Get.find<UserEmergencyContactsController>(tag: tag);
      controller.getEmergencyContacts();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      floatingActionButton: buildFloatingActionButton(),
      body: Padding(
        padding: const EdgeInsets.all(space12),
        child: GetX<UserEmergencyContactsController>(
            tag: tag,
            builder: (controller) {
              final isLoading = controller.isLoading;
              final hasError = controller.hasError;
              final contacts = controller.contacts;

              if (isLoading) {
                return context.buildLoadingWidget();
              } else if (hasError) {
                return context.buildErrorWidget(
                  onRetry: () => getData(),
                );
              } else {
                return buildBody(contacts);
              }
            }),
      ),
    );
  }

  buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        final result =
            await context.showBottomBar(child: const AddContactBar());
        if (result is bool && result) {
          getData();
        }
      },
      backgroundColor: blackShade1Color,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(space4)),
      child: const Icon(Icons.add_rounded),
    );
  }

  Column buildBody(List<Contact> contacts) {
    return Column(
      children: [
        Text(
          'Emergency contacts are displayed to community users as a form of contact in the case of an emergency.',
          style: satoshi500S14,
        ),
        verticalSpacer12,
        context.divider,
        verticalSpacer12,
        Expanded(
          child: contacts.isEmpty
              ? context.buildNoDataWidget()
              : buildContactList(contacts),
        ),
        verticalSpacer12,
      ],
    );
  }

  Widget buildContactList(List<Contact> contacts) {
    return ListView.builder(
      itemCount: contacts.length,
      padding: const EdgeInsets.all(0),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return buildContactTile(
          contact,
          () => onContactPressed(contact),
        );
      },
    );
  }

  onContactPressed(Contact contact) async {
    final result =
        await context.showBottomBar(child: AddContactBar(contact: contact));
    if (result is bool && result) {
      getData();
    }
  }

  Widget buildContactTile(Contact contact, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: space12),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () => onPressed.call(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(space12),
          decoration: BoxDecoration(
            border: Border.all(color: neutral200),
            color: shadeWhite,
            borderRadius: BorderRadius.circular(cornersSmall),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.fullName ?? '',
                style: satoshi600S14,
              ),
              verticalSpacer8,
              Text(
                'Contact: ${contact.phoneNumber}',
                style: satoshi500S12,
              ),
              verticalSpacer8,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Country: ${contact.country}',
                      style: satoshi500S12,
                    ),
                  ),
                  horizontalSpacer8,
                  const Icon(
                    Icons.edit_rounded,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
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
      title: Text('Emergency contact', style: satoshi600S24).fadeIn(),
    );
  }
}
