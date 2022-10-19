import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:unreal_whatsapp/select_contact/bloc/select_contact_cubit.dart';
import 'package:unreal_whatsapp/select_contact/bloc/select_contact_state.dart';
import 'package:unreal_whatsapp/var/strings.dart';
import 'package:unreal_whatsapp/widgets/loader.dart';

class SelectContactsView extends StatefulWidget {
  const SelectContactsView({super.key});
  static const String routeName = '/select-contact';

  @override
  State<SelectContactsView> createState() => _SelectContactsViewState();
}

class _SelectContactsViewState extends State<SelectContactsView> {
  Future<void> selectContact(Contact contact) async {
    final user = await BlocProvider.of<SelectContactCubit>(context)
        .selectContact(contact: contact);

    if (user != null && mounted) {
      Navigator.pop(context, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: BlocConsumer<SelectContactCubit, SelectContactState>(
        listener: (context, state) {
          if (state is SelectContactInitial) {
            BlocProvider.of<SelectContactCubit>(context).getContact();
          }
        },
        builder: (context, state) {
          if (state is SelectContactInitial) {
            BlocProvider.of<SelectContactCubit>(context).getContact();
          }

          if (state is SelectContactError) {
            return Center(
              child: Text(
                'Error ${state.message}',
              ),
            );
          }

          if (state is SelectContactLoaded) {
            final contactList = state.contacts;
            const networkImage = NetworkImage(defaultProfileURL);

            return ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () => selectContact(contact),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        contact.phones.isNotEmpty
                            ? contact.phones.first.number
                            : '',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      leading: contact.photo == null
                          ? const CircleAvatar(
                              backgroundImage: networkImage,
                              radius: 30,
                            )
                          : CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!),
                              radius: 30,
                            ),
                    ),
                  ),
                );
              },
            );
          }
          return const CustomLoadingIndicator();
        },
      ),
    );
  }
}
