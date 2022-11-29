import 'package:chatup/select_contact/cubit/select_contact_cubit.dart';
import 'package:chatup/select_contact/cubit/select_contact_state.dart';
import 'package:chatup/select_contact/data/models/app_contact.dart';
import 'package:chatup/widgets/custom_center_text.dart';
import 'package:chatup/widgets/custom_circle_avatar.dart';
import 'package:chatup/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectContactsView extends StatelessWidget {
  const SelectContactsView({super.key});
  static const String routeName = '/select-contact';

  void selectContact(AppContact contact, BuildContext context) {
    BlocProvider.of<SelectContactCubit>(context)
        .selectContact(contact: contact)
        .then((user) {
      Navigator.pop(context, user);
    });
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
            Future.delayed(
              const Duration(seconds: 5),
              () => BlocProvider.of<SelectContactCubit>(context).reset(),
            );
            return Center(
              child: Text(
                'Error ${state.message}',
              ),
            );
          }

          if (state is SelectContactLoaded) {
            final contactList = state.contacts;

            if (contactList.isEmpty) {
              return const CustomCenteredText(
                text: 'Your friends are not using chatup',
              );
            }

            return ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () => selectContact(contact, context),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                    child: ListTile(
                      title: Text(
                        contact.name,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        contact.phoneNumber,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      leading:
                          CustomCircleAvatar(profilePicURL: contact.profilePic),
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
