import 'package:chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AnalyticsBotBottomSheet extends StatefulWidget {
  const AnalyticsBotBottomSheet({
    required this.filter,
    required this.bots,
    super.key,
  });

  final DashboardAgentFilter filter;

  final List<BotEntity> bots;

  @override
  State<AnalyticsBotBottomSheet> createState() =>
      AnalyticsBotBottomSheetSheetState();
}

class AnalyticsBotBottomSheetSheetState extends State<AnalyticsBotBottomSheet> {
  late DashboardAgentFilter currentFilter;

  @override
  void initState() {
    currentFilter = widget.filter;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnalyticsBotBottomSheet oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Insets.m,
                      horizontal: Insets.xl,
                    ),
                    width: double.infinity,
                    child: Text(
                      ChatsI18n.agent,
                      style: context.texts.title.copyWith(
                        color: context.colors.semiBlack,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UiCheckBoxCell(
                        label: ChatsI18n.all,
                        value: currentFilter.bots == null,
                        onTap: (value) {
                          if (value) {
                            setState(() {
                              currentFilter = currentFilter.copyWith(
                                bots: null,
                              );
                            });
                          }
                        },
                      ),
                      ...widget.bots.map(
                        (e) => UiCheckBoxCell(
                          label: e.name,
                          value: currentFilter.bots?.contains(e) ?? false,
                          onTap: (value) {
                            if (value) {
                              setState(() {
                                final bots = <BotEntity>[
                                  ...currentFilter.bots ?? [],
                                  e,
                                ];

                                currentFilter = currentFilter.copyWith(
                                  bots: bots,
                                );
                              });
                            } else {
                              setState(() {
                                final bots = <BotEntity>[
                                  ...currentFilter.bots ?? [],
                                ];
                                bots.remove(e);

                                currentFilter = currentFilter.copyWith(
                                  bots: bots.isEmpty ? null : bots,
                                );
                              });
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
                        currentFilter = widget.filter.copyWith(bots: null);
                      });
                    },
                  ),
                ),
                const SizedBox(width: Insets.s),
                Expanded(
                  child: UiButton(
                    label: ChatsI18n.accept,
                    onPressed: () {
                      Navigator.of(context).pop(currentFilter);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
