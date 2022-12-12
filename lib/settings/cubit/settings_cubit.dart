import 'package:chatup/settings/cubit/settings_state.dart';
import 'package:chatup/settings/data/repository/setting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.settingsRepository,
  }) : super(InitialSettingState());

  final SettingsRepository settingsRepository;

}
