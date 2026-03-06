import 'package:auth/auth.dart';
import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class DashboardTabBar extends StatefulWidget {
  const DashboardTabBar({super.key});

  @override
  State<DashboardTabBar> createState() => _DashboardTabBarState();
}

class _DashboardTabBarState extends State<DashboardTabBar>
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
        TabController(length: 2, vsync: this);

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
                onTap: () {
                  context.read<DashboardCubit>().setTab(0);
                },
                child: ProfileChip(
                  width: 112,
                  title: ChatsI18n.agents,
                  selected: controller?.index == 0,
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  context.read<DashboardCubit>().setTab(1);
                },
                radius: Insets.xl,
                child: ProfileChip(
                  width: 112,
                  title: ChatsI18n.campaigns,
                  selected: controller?.index == 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
