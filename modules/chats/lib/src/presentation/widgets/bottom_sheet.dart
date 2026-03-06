import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class UiBottomSheet extends StatelessWidget {
  const UiBottomSheet({required this.child, super.key, this.heightFactor});

  final Widget child;

  final double? heightFactor;

  @override
  Widget build(BuildContext context) {
    if (heightFactor == null) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [header(context), Flexible(child: child)],
        ),
      );
    }

    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: heightFactor ?? 0.92,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [header(context), child],
        ),
      ),
    );
  }

  static Widget header(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: const EdgeInsets.all(Insets.l),
        width: 72,
        height: 4,
        decoration: BoxDecoration(
          color: context.colors.lightGrey,
          borderRadius: BorderRadius.circular(Insets.l),
        ),
      ),
    ],
  );
}
