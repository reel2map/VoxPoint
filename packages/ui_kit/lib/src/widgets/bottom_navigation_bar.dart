import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class UiBottomNavigationBar extends StatelessWidget {
  const UiBottomNavigationBar({super.key, this.items = const []});

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: Insets.bottomNavBar + MediaQuery.viewPaddingOf(context).bottom,
      // margin: const EdgeInsets.only(top: Insets.m),
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewPaddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: context.colors.white100,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A292830),
            offset: Offset(0, -8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.l,
          vertical: Insets.s,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Insets.s,
          children: [...items.map((e) => e)],
        ),
      ),
    );
  }
}

class UiNavigationBarItem extends StatelessWidget {
  const UiNavigationBarItem({
    required this.selected,
    required this.onPressed,
    required this.label,
    required this.icon,
    super.key,
  });

  final bool selected;

  final VoidCallback onPressed;

  final String label;

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: selected ? 2 : 1,
      child: InkWell(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: Durations.medium3,
          height: 76,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: Insets.m),
          decoration: BoxDecoration(
            color: selected ? context.colors.mainOrange10 : Colors.transparent,
            borderRadius: BorderRadius.circular(Insets.xxl),
          ),
          child: Column(
            spacing: Insets.xs,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Visibility(
                visible: selected,
                maintainAnimation: true,
                maintainState: true,
                child: AnimatedOpacity(
                  duration: Durations.medium3,
                  opacity: selected ? 1 : 0,
                  child: Text(
                    label.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.description.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colors.mainOrange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
