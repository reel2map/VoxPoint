import 'package:flutter/material.dart';
import 'package:settings/src/_src.dart';
import 'package:ui_kit/ui_kit.dart';

class PinCodeTitle extends StatelessWidget {
  const PinCodeTitle({
    required this.hasPinCode,
    required this.hasTemporaryCode,
    this.isChanging = false,
    super.key,
  });

  final bool hasPinCode;
  final bool hasTemporaryCode;
  final bool isChanging;

  @override
  Widget build(BuildContext context) {
    final style = context.texts.body.copyWith(color: context.colors.black80);

    if (hasPinCode) {
      return Text(SettingsI18n.enterPinCode, style: style);
    }

    if (hasTemporaryCode) {
      return Text(SettingsI18n.repeatPinCode, style: style);
    }

    return Text(SettingsI18n.settingPinCode, style: style);
  }
}
