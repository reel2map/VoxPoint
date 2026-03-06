import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class BillingTab extends StatelessWidget {
  const BillingTab({required this.subscriptions, super.key});

  final List<SubscriptionEntity> subscriptions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
        child: Column(
          children: [
            const SizedBox(height: 48),
            Text(
              AuthI18n.subscriptionInfo,
              style: context.texts.title.copyWith(
                color: context.colors.darkGreyText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: Insets.l),
            ...subscriptions.map(
              (e) => Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: Insets.m),
                decoration: BoxDecoration(
                  color: context.colors.white100,
                  borderRadius: BorderRadius.circular(Insets.s),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Insets.m,
                  children: [
                    InputCell(title: AuthI18n.name, text: e.description),
                    Divider(height: 1, color: context.colors.extraLightGrey),
                    InputCell(
                      title: AuthI18n.sessionLimit,
                      text:
                          e.sessionsLimit == -1
                              ? AuthI18n.unlimited
                              : e.sessionsLimit.toString(),
                    ),
                    Divider(height: 1, color: context.colors.extraLightGrey),
                    InputCell(
                      title: AuthI18n.sessionCount,
                      text: e.sessionsCount.toString(),
                    ),
                    Divider(height: 1, color: context.colors.extraLightGrey),
                    InputCell(
                      title: AuthI18n.subscriptionStatus,
                      text: e.status,
                    ),
                    Divider(height: 1, color: context.colors.extraLightGrey),
                    InputCell(
                      title: AuthI18n.nextBillingDate,
                      text: DateFormat(
                        DateFormats.ddMMyyyy,
                      ).format(e.nextInvoiceDate),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Insets.l,
                        vertical: Insets.m,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              AuthI18n.extraSessionSubscription,
                              style: context.texts.subtitle.copyWith(
                                color: context.colors.semiBlack,
                              ),
                            ),
                          ),
                          const SizedBox(width: Insets.s),
                          Text(
                            !e.extraAvailable ? AuthI18n.on : AuthI18n.off,
                            style: context.texts.subtitle.copyWith(
                              color:
                                  !e.extraAvailable
                                      ? const Color(0xFF18D603)
                                      : context.colors.mainOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Insets.xl),
          ],
        ),
      ),
    );
  }
}
