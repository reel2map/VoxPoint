import 'package:chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AnalyticsCampaignBottomSheet extends StatefulWidget {
  const AnalyticsCampaignBottomSheet({
    required this.filter,
    required this.campaigns,
    super.key,
  });

  final DashboardCampaignFilter filter;

  final List<CampaignEntity> campaigns;

  @override
  State<AnalyticsCampaignBottomSheet> createState() =>
      AnalyticsCampaignBottomSheetState();
}

class AnalyticsCampaignBottomSheetState
    extends State<AnalyticsCampaignBottomSheet> {
  late DashboardCampaignFilter currentFilter;

  @override
  void initState() {
    currentFilter = widget.filter;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnalyticsCampaignBottomSheet oldWidget) {
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
                      ChatsI18n.campaigns,
                      style: context.texts.title.copyWith(
                        color: context.colors.semiBlack,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...widget.campaigns.map(
                        (e) => UiCheckBoxCell(
                          label: e.name,
                          value: currentFilter.campaign == e,
                          onTap: (value) {
                            if (value) {
                              setState(() {
                                currentFilter = currentFilter.copyWith(
                                  campaign: e,
                                );
                              });
                            } else {
                              setState(() {
                                currentFilter = currentFilter.copyWith(
                                  campaign: null,
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
                        currentFilter = widget.filter.copyWith(campaign: null);
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
