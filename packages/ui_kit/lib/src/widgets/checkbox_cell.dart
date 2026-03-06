import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class UiCheckBoxCell extends StatefulWidget {
  const UiCheckBoxCell({
    required this.label,
    required this.value,
    this.disabled = false,
    this.isRadio = true,
    super.key,
    this.onTap,
  });

  final String label;

  final bool disabled;

  final bool value;

  final void Function(bool value)? onTap;

  final bool isRadio;

  @override
  State<UiCheckBoxCell> createState() => _UiCheckBoxCellState();
}

class _UiCheckBoxCellState extends State<UiCheckBoxCell> {
  late bool currentValue;

  @override
  void initState() {
    currentValue = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UiCheckBoxCell oldWidget) {
    setState(() {
      currentValue = widget.value;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap:
          widget.disabled
              ? null
              : () {
                setState(() {
                  currentValue = !currentValue;
                });
                widget.onTap?.call(currentValue);
              },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Insets.m,
          horizontal: Insets.xl,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: context.texts.subtitle.copyWith(
                  color: context.colors.mediumGrey,
                ),
              ),
            ),
            UiCheckBox(
              disabled: widget.disabled,
              value: currentValue,
              onTap: widget.onTap,
            ),
          ],
        ),
      ),
    );
  }
}
