import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/src/_src.dart';
import 'package:ui_kit/ui_kit.dart';

class LocalAuthSwitcher extends StatelessWidget {
  const LocalAuthSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return ListTile(
          title: Text(SettingsI18n.useLocalAuth, style: context.texts.body),
          trailing: Switch(
            value: state.useLocalAuth,
            onChanged: (value) {
              context.read<SettingsCubit>().setUseLocalAuth(value: value);
            },
          ),
        );
      },
    );
  }
}
