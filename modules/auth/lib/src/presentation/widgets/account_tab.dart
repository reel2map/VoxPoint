import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({required this.user, super.key});

  final AuthenticatedUser user;

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  int taps = 0;

  @override
  void didUpdateWidget(covariant AccountTab oldWidget) {
    if (widget.user != oldWidget.user) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
        child: Column(
          children: [
            const SizedBox(height: 48),
            GestureDetector(
              onTap: () {
                taps++;

                if (taps % 5 == 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => TalkerScreen(talker: sl()),
                    ),
                  );
                }
              },
              child: CircleAvatar(
                backgroundColor: context.colors.lightGrey,
                radius: Insets.xxl,
              ),
            ),
            const SizedBox(height: Insets.s),
            Text(
              AuthI18n.personalInformation,
              style: context.texts.title.copyWith(
                color: context.colors.darkGreyText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: Insets.l),
            Container(
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
                  InputCell(title: AuthI18n.email, text: widget.user.email),
                  Divider(height: 1, color: context.colors.extraLightGrey),
                  InputCell(
                    title: AuthI18n.fullname,
                    text: widget.user.fullName,
                  ),
                  Divider(height: 1, color: context.colors.extraLightGrey),
                  InputCell(title: AuthI18n.jobTitle, text: ''),
                  Divider(height: 1, color: context.colors.extraLightGrey),
                  InputCell(
                    title: AuthI18n.phoneNumber,
                    text: widget.user.phone ?? '',
                  ),
                ],
              ),
            ),
            const SizedBox(height: Insets.l),
            Container(
              width: Insets.xxxl,
              height: Insets.xxxl,
              // decoration: BoxDecoration(
              //   shape: BoxShape.circle,
              //   color: context.colors.white100,
              // ),
              padding: const EdgeInsets.all(Insets.s),
              child: UiIcon(Assets.images.logoGradient.path),
            ),
            const SizedBox(height: Insets.s),
            Container(
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
                  InputCell(
                    title: AuthI18n.organizationName,
                    text: widget.user.tenant?.name ?? '',
                  ),
                  Divider(height: 1, color: context.colors.extraLightGrey),
                  InputCell(
                    title: AuthI18n.descriptionOrg,
                    text: widget.user.tenant?.description ?? '',
                  ),
                  Divider(height: 1, color: context.colors.extraLightGrey),
                  InputCell(
                    title: AuthI18n.phone,
                    text: widget.user.tenant?.phone ?? '',
                  ),
                  Divider(height: 1, color: context.colors.extraLightGrey),
                  InputCell(
                    title: AuthI18n.billingEmail,
                    text: widget.user.tenant?.billingEmail ?? '',
                  ),
                  Divider(height: 1, color: context.colors.extraLightGrey),
                  InputCell(
                    title: AuthI18n.country,
                    text: widget.user.tenant?.country ?? '',
                  ),
                  Divider(height: 1, color: context.colors.extraLightGrey),
                  InputCell(
                    title: AuthI18n.street,
                    text: widget.user.tenant?.street ?? '',
                  ),
                  Divider(height: 1, color: context.colors.extraLightGrey),
                  InputCell(
                    title: AuthI18n.zipCode,
                    text: widget.user.tenant?.zipCode ?? '',
                  ),
                  Divider(height: 1, color: context.colors.extraLightGrey),
                  InputCell(
                    title: AuthI18n.website,
                    text: widget.user.tenant?.website ?? '',
                  ),
                ],
              ),
            ),
            const SizedBox(height: Insets.xl),

            Row(
              children: [
                InputCell(
                  title: AuthI18n.deleteAccount,
                  titleColor: context.theme.colorScheme.error,
                  text: 'https://portal.flametree.ai',
                  onPressed: () async {
                    if (await canLaunchUrl(
                      Uri.parse('https://portal.flametree.ai'),
                    )) {
                      await launchUrl(Uri.parse('https://portal.flametree.ai'));
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: Insets.xl),
          ],
        ),
      ),
    );
  }
}
