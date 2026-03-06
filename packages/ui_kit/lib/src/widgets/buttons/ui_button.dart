import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

enum UiButtonType { accent, secondary, green }

class UiButton extends StatelessWidget {
  const UiButton({
    required this.label,
    this.disabled = false,
    this.type = UiButtonType.accent,
    super.key,
    this.onPressed,
    this.labelOverflow,
    this.expanded = true,
  });

  final VoidCallback? onPressed;

  final String label;

  final bool disabled;

  final UiButtonType type;

  final bool expanded;

  final TextOverflow? labelOverflow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Insets.s),
        gradient: switch (type) {
          UiButtonType.accent => context.colors.orangeWhite,
          UiButtonType.green => null,
          UiButtonType.secondary => null,
        },
      ),
      child: FilledButton(
        style: _getStyle(context),
        onPressed: disabled ? null : onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (expanded)
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  overflow: labelOverflow,
                  style: context.texts.subtitle,
                ),
              )
            else
              Text(label, style: context.texts.subtitle),
          ],
        ),
      ),
    );
  }

  ButtonStyle _getStyle(BuildContext context) {
    return ButtonStyle(
      shape: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.hovered)) {
          return switch (type) {
            UiButtonType.accent => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Insets.s),
            ),
            UiButtonType.green => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Insets.s),
            ),
            UiButtonType.secondary => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Insets.s),
              side: BorderSide(color: context.colors.lightGrey),
            ),
          };
        }

        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Insets.s),
        );
      }),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(vertical: Insets.m, horizontal: Insets.l),
      ),
      backgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return switch (type) {
            UiButtonType.accent => context.colors.lightGrey,
            UiButtonType.green => Colors.green,
            UiButtonType.secondary => context.colors.extraLightGrey,
          };
        }

        if (states.contains(WidgetState.pressed)) {
          return switch (type) {
            UiButtonType.accent => Colors.transparent,
            UiButtonType.green => Colors.green,
            UiButtonType.secondary => context.colors.extraLightGrey,
          };
        }

        return switch (type) {
          UiButtonType.accent => context.colors.mainOrange,
          UiButtonType.green => Colors.green,
          UiButtonType.secondary => context.colors.extraLightGrey,
        };
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return switch (type) {
            UiButtonType.accent => context.colors.white100,
            UiButtonType.green => context.colors.white100,
            UiButtonType.secondary => context.colors.lightGrey,
          };
        }
        return switch (type) {
          UiButtonType.accent => context.colors.white100,
          UiButtonType.green => context.colors.white100,
          UiButtonType.secondary => context.colors.darkGrey,
        };
      }),
    );
  }
}
