import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class FlametreeSearchBar extends StatefulWidget {
  const FlametreeSearchBar({
    this.control,
    this.onPressedSort,
    this.onPressedFilter,
    super.key,
    this.showSearchBar = false,
    this.searchBarItem,
    this.isFilterNotEmpty = false,
  });

  final FormControl<String>? control;

  final VoidCallback? onPressedSort;

  final VoidCallback? onPressedFilter;

  final bool showSearchBar;

  final Widget? searchBarItem;

  final bool isFilterNotEmpty;

  @override
  State<FlametreeSearchBar> createState() => _FlametreeSearchBarState();
}

class _FlametreeSearchBarState extends State<FlametreeSearchBar>
    with SingleTickerProviderStateMixin {
  bool isFocused = false;

  @override
  void didUpdateWidget(covariant FlametreeSearchBar oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.xl,
        vertical: Insets.xs,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: Insets.l,
              children: [
                if (widget.showSearchBar)
                  AnimatedContainer(
                    duration: Durations.medium1,
                    curve: Curves.fastOutSlowIn,
                    width:
                        constraints.maxWidth -
                        16 -
                        (widget.onPressedSort != null ? 86 : 0) -
                        (widget.onPressedFilter != null ? 86 : 0) -
                        4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        isFocused ? Insets.s : 40,
                      ),
                      border: Border.all(color: const Color(0xFFDBDBDB)),
                    ),
                    child: widget.searchBarItem ?? const SizedBox.shrink(),
                  )
                else if (widget.control != null)
                  AnimatedContainer(
                    duration: Durations.medium1,
                    curve: Curves.fastOutSlowIn,
                    width:
                        isFocused
                            ? constraints.maxWidth
                            : constraints.maxWidth -
                                16 -
                                (widget.onPressedSort != null ? 86 : 0) -
                                (widget.onPressedFilter != null ? 86 : 0) -
                                4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        isFocused ? Insets.s : 40,
                      ),
                      border: Border.all(color: const Color(0xFFDBDBDB)),
                    ),
                    child: Row(
                      children: [
                        if (!isFocused) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: Insets.l),
                            child: UiIcon(
                              Assets.icons.search.path,
                              useColor: false,
                            ),
                          ),
                        ],
                        Expanded(
                          child: Focus(
                            onFocusChange: (focused) {
                              setState(() {
                                isFocused = focused;
                              });
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: ReactiveTextField<String>(
                                    formControl: widget.control,
                                    style: context.texts.subtitle.copyWith(
                                      color: context.colors.darkGreyText,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        left: isFocused ? Insets.l : Insets.s,
                                        right: Insets.l,
                                        top: Insets.l,
                                        bottom: Insets.l,
                                      ),
                                      hintText: ChatsI18n.search,
                                      hintStyle: context.texts.subtitle
                                          .copyWith(
                                            color: context.colors.darkGreyText,
                                          ),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                ReactiveValueListenableBuilder<String>(
                                  formControl: widget.control,
                                  builder: (context, control, _) {
                                    if (!isFocused) {
                                      return const SizedBox.shrink();
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        control
                                          ..patchValue(null)
                                          ..unfocus();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: Insets.l,
                                        ),
                                        child: UiIcon(
                                          Assets.icons.cross.path,
                                          useColor: false,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width:
                        constraints.maxWidth -
                        16 -
                        (widget.onPressedSort != null ? 86 : 0) -
                        (widget.onPressedFilter != null ? 86 : 0) -
                        4,
                  ),
                if (widget.onPressedSort != null)
                  InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: widget.onPressedSort,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: Insets.l,
                        horizontal: Insets.xl,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: const Color(0xFFDBDBDB)),
                      ),
                      child: UiIcon(Assets.icons.sort.path),
                    ),
                  ),
                if (widget.onPressedFilter != null)
                  InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: widget.onPressedFilter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: Insets.m,
                        horizontal: Insets.l,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: const Color(0xFFDBDBDB)),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(Insets.xs),
                            child: UiIcon(Assets.icons.filter.path),
                          ),
                          if (widget.isFilterNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: Insets.s,
                                height: Insets.s,
                                decoration: BoxDecoration(
                                  color: context.colors.mainOrange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
