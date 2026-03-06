import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/src/_src.dart';
import 'package:ui_kit/ui_kit.dart';

class BiometrySwitcher extends StatelessWidget {
  const BiometrySwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        print(state.useLocalAuth);
        print(state.useBiometric);
        if (!state.useLocalAuth || state.useBiometric == null) {
          return const SizedBox();
        }

        return ListTile(
          title: Text(SettingsI18n.useBiometrics, style: context.texts.body),
          trailing: Switch(
            value: state.useBiometric ?? false,
            onChanged:
                state.useBiometric == null
                    ? null
                    : (value) {
                      context.read<SettingsCubit>().setBiometry(value: value);
                    },
          ),
        );
      },
    );
  }
}
