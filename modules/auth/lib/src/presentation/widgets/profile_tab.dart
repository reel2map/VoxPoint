import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller ??=
        DefaultTabController.maybeOf(context) ??
        TabController(length: 3, vsync: this);

    return ListenableBuilder(
      listenable: controller!,
      builder: (context, _) {
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: Insets.s,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                radius: Insets.xl,
                onTap: () => controller?.animateTo(0),
                child: ProfileChip(
                  width: 88,
                  title: AuthI18n.account,
                  selected: controller?.index == 0,
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => controller?.animateTo(1),
                radius: Insets.xl,
                child: ProfileChip(
                  width: 88,
                  title: AuthI18n.billing,
                  selected: controller?.index == 1,
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => controller?.animateTo(2),
                radius: Insets.xl,
                child: ProfileChip(
                  width: 88,
                  title: AuthI18n.settings,
                  selected: controller?.index == 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
