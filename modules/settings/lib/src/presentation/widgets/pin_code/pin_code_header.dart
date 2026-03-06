import 'package:flutter/material.dart';
import 'package:settings/src/_src.dart';
import 'package:ui_kit/ui_kit.dart';

class PinCodeHeader extends StatelessWidget {
  const PinCodeHeader({
    required this.hasPinCode,
    required this.hasTemporaryCode,
    required this.hasError,
    required this.pinCodeLength,
    required this.pinFilledCodeLength,
    required this.isLoading,
    this.isChanging = false,
    super.key,
    this.avatar,
    this.name,
  });

  final int pinCodeLength;
  final int pinFilledCodeLength;

  final bool isChanging;
  final bool hasPinCode;
  final bool hasTemporaryCode;
  final bool hasError;
  final bool isLoading;
  final String? avatar;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (name != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.l),
            child: Text(name!, style: context.texts.body),
          ),
        if (name == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.xl),
            child: PinCodeTitle(
              hasPinCode: hasPinCode,
              hasTemporaryCode: hasTemporaryCode,
              isChanging: isChanging,
            ),
          ),
        PinCodePoints(
          hasError: hasError,
          pinCodeLength: pinCodeLength,
          pinFilledCodeLength: pinFilledCodeLength,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
