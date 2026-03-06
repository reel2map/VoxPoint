import 'package:chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AnalyticsPeriodBottomSheet extends StatefulWidget {
  const AnalyticsPeriodBottomSheet({required this.period, super.key});

  final PeriodType period;

  @override
  State<AnalyticsPeriodBottomSheet> createState() =>
      AnalyticsPeriodBottomSheetState();
}

class AnalyticsPeriodBottomSheetState
    extends State<AnalyticsPeriodBottomSheet> {
  late PeriodType currentPeriod;

  @override
  void initState() {
    currentPeriod = widget.period;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnalyticsPeriodBottomSheet oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Insets.m,
                      horizontal: Insets.xl,
                    ),
                    child: Text(
                      ChatsI18n.period,
                      style: context.texts.title.copyWith(
                        color: context.colors.semiBlack,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    ...PeriodType.values.map(
                      (e) => UiCheckBoxCell(
                        label: ChatsI18n.periodType(e),
                        value: currentPeriod == e,
                        onTap: (value) {
                          if (value) {
                            setState(() {
                              currentPeriod = e;
                            });
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Insets.xl),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: Insets.m,
            horizontal: Insets.xl,
          ),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: context.colors.lightGrey)),
          ),
          child: Row(
            children: [
              Expanded(
                child: UiButton(
                  type: UiButtonType.secondary,
                  label: ChatsI18n.clear,
                  onPressed: () {
                    setState(() {
                      currentPeriod = PeriodType.week;
                    });
                  },
                ),
              ),
              const SizedBox(width: Insets.s),
              Expanded(
                child: UiButton(
                  label: ChatsI18n.accept,
                  onPressed: () {
                    Navigator.of(context).pop(currentPeriod);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
