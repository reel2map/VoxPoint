import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class SessionBottomSheet extends StatelessWidget {
  const SessionBottomSheet({
    required this.fields,
    required this.title,
    super.key,
  });

  final String title;

  final Map<String, dynamic> fields;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: context.texts.title.copyWith(
                color: context.colors.semiBlack,
              ),
            ),
            Flexible(
              child: ListView.separated(
                separatorBuilder:
                    (context, index) => Divider(
                      height: 1,
                      color: context.colors.extraLightGrey,
                    ),
                itemCount: fields.entries.length,
                itemBuilder:
                    (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: Insets.l),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            fields.entries.toList()[index].key,
                            style: context.texts.subtitle.copyWith(
                              color: context.colors.semiBlack,
                            ),
                          ),
                          const SizedBox(height: Insets.xs),
                          Text(
                            fields.entries.toList()[index].value?.toString() ??
                                '—',
                            style: context.texts.subtitle.copyWith(
                              color: context.colors.mediumGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
