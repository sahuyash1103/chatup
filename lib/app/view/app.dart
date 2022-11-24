import 'package:chatup/chating/cubit/chat_cubit.dart';
import 'package:chatup/chating/data/providers/chat_provider.dart';
import 'package:chatup/chating/data/repositories/chat_repository.dart';
import 'package:chatup/common/utils/utils.dart';
import 'package:chatup/l10n/l10n.dart';
import 'package:chatup/layouts/views/mobile_layout.dart';
import 'package:chatup/login/cubit/firebase_login_cubit.dart';
import 'package:chatup/login/cubit/firestore_cubit.dart';
import 'package:chatup/login/data/providers/firebase_login.dart';
import 'package:chatup/login/data/providers/firestore_provider.dart';
import 'package:chatup/login/data/repositeries/firebase_login.dart';
import 'package:chatup/login/data/repositeries/firestore_repository.dart';
import 'package:chatup/login/views/landing.dart';
import 'package:chatup/login/views/user_information.dart';
import 'package:chatup/router.dart';
import 'package:chatup/select_contact/cubit/select_contact_cubit.dart';
import 'package:chatup/select_contact/data/providers/select_contact_provider.dart';
import 'package:chatup/select_contact/data/repositories/select_contact_repository.dart';
import 'package:chatup/var/colors.dart';
import 'package:chatup/widgets/custom_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  Widget materialApp(AppRouter appRouter) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: tabColor,
          secondary: backgroundColor,
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: appRouter.generateRoute,
      home: const LoadingView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    final firebaseLoginRepository = FirebaseAuthRepository(
      firebaseLoginProvider: FirebaseAuthProvider(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
        firebaseStorage: FirebaseStorage.instance,
      ),
    );
    final selectContactRepository = SelectContactRepository(
      selectContactProvider:
          SelectContactProvider(firestore: FirebaseFirestore.instance),
    );

    final chatRepository = ChatRepository(
      chatProvider: ChatProvider(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    );

    final firestoreRepository = FirestoreRepository(
      firestoreProvider: FirestoreProvider(
        firestore: FirebaseFirestore.instance,
        firebaseStorage: FirebaseStorage.instance,
        firebaseAuth: FirebaseAuth.instance,
      ),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FirebaseAuthCubit(
            firebaseLoginRepository: firebaseLoginRepository,
          ),
        ),
        BlocProvider(
          create: (context) => SelectContactCubit(
            selectContactRepository: selectContactRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ChatCubit(
            chatRepository: chatRepository,
          ),
        ),
        BlocProvider(
          create: (context) =>
              FirestoreCubit(firestoreRepository: firestoreRepository),
        )
      ],
      child: materialApp(appRouter),
    );
  }
}

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  void initState() {
    autoLogin();
    super.initState();
  }

  Future<void> autoLogin() async {
    try {
      final user =
          await BlocProvider.of<FirebaseAuthCubit>(context).getCurrentUser();
      if (user != null && mounted) {
        if (user.name.isEmpty) {
          await Navigator.pushReplacementNamed(
            context,
            UserInformationView.routeName,
          );
        } else {
          await Navigator.pushReplacementNamed(context, MobileView.routeName);
        }
      } else if (user == null && mounted) {
        await Navigator.pushReplacementNamed(
          context,
          LandingView.routeName,
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: 'somthing went wrong, make sure your data is on'
            ' and restart the app.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: CustomLoadingIndicator(),
    );
  }
}
