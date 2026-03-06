import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class UiCheckBox extends StatefulWidget {
  const UiCheckBox({
    required this.value,
    this.disabled = false,
    super.key,
    this.onTap,
  });

  final bool disabled;

  final bool value;

  final void Function(bool value)? onTap;

  @override
  State<UiCheckBox> createState() => _UiCheckBoxState();
}

class _UiCheckBoxState extends State<UiCheckBox> {
  late bool currentValue;

  @override
  void initState() {
    currentValue = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UiCheckBox oldWidget) {
    setState(() {
      currentValue = widget.value;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          widget.disabled
              ? null
              : () {
                setState(() {
                  currentValue = !currentValue;
                });
                widget.onTap?.call(currentValue);
              },
      child:
          currentValue
              ? UiIcon(
                Assets.icons.checkboxChecked.path,
                color: context.colors.mainOrange,
              )
              : UiIcon(Assets.icons.checkbox.path, useColor: false),
    );
  }
}
