import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:unreal_whatsapp/l10n/l10n.dart';
import 'package:unreal_whatsapp/layouts/views/mobile.dart';
import 'package:unreal_whatsapp/login/cubit/firebase_login_cubit.dart';
import 'package:unreal_whatsapp/login/data/providers/firebase_login.dart';
import 'package:unreal_whatsapp/login/data/repositeries/firebase_login.dart';
import 'package:unreal_whatsapp/login/views/landing.dart';
import 'package:unreal_whatsapp/router.dart';
import 'package:unreal_whatsapp/select_contact/cubit/select_contact_cubit.dart';
import 'package:unreal_whatsapp/select_contact/data/repositories/select_contact.dart';
import 'package:unreal_whatsapp/var/colors.dart';
import 'package:unreal_whatsapp/widgets/loader.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    final firebaseLoginRepository = LoginRepository(
      firebaseLoginProvider: LoginProvider(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
        firebaseStorage: FirebaseStorage.instance,
      ),
    );
    final selectContactRepository =
        SelectContactRepository(firebaseStorage: FirebaseStorage.instance);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FirebaseLoginCubit(
            firebaseLoginRepository: firebaseLoginRepository,
          ),
        ),
        BlocProvider(
          create: (context) => SelectContactCubit(
            selectContactRepository: selectContactRepository,
          ),
        ),
      ],
      child: MaterialApp(
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
      ),
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
          await BlocProvider.of<FirebaseLoginCubit>(context).getCurrentUser();
      if (user != null && mounted) {
        await Navigator.pushReplacementNamed(context, MobileView.routeName);
      } else if (user == null && mounted) {
        log('user is null');
        await Navigator.pushReplacementNamed(context, LandingView.routeName);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: CustomLoadingIndicator(),
    );
  }
}
