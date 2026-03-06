import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class StatusDistributionItem extends StatelessWidget {
  const StatusDistributionItem({
    required this.color,
    required this.text,
    super.key,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: Insets.xs),
            width: Insets.s,
            height: Insets.s,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: Insets.xs),
          Flexible(
            child: Text(
              text,
              style: context.texts.body.copyWith(
                color: context.colors.semiBlack,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
