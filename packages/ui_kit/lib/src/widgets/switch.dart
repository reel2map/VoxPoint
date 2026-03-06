import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class UiSwitch extends StatelessWidget {
  const UiSwitch({
    required this.value,
    this.disabled = false,
    super.key,
    this.onTap,
  });

  final void Function(bool value)? onTap;

  final bool value;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : () => onTap?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: Insets.xl,
        height: Insets.l,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Insets.l),
          color: value ? context.colors.mainOrange : const Color(0xFFE6E6E6),
        ),
        child: AnimatedAlign(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: const EdgeInsets.only(left: Insets.xxs, right: Insets.xxs),
            width: Insets.m,
            height: Insets.m,
            decoration: BoxDecoration(
              color: value ? context.colors.white100 : const Color(0xFF787878),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  offset: const Offset(0, 3),
                  blurRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(0, 3),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
