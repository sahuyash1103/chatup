import 'package:chatup/login/data/models/app_user.dart';

class SettingsState {}

class InitialSettingState extends SettingsState {}

class SetTheme extends SettingsState {}

class SettingsUserDataLoaded extends SettingsState {
  SettingsUserDataLoaded({required this.user});
  final AppUser user;
}

class SttingsLoading extends SettingsState {}

class SettingsUserDataError extends SettingsState {}
