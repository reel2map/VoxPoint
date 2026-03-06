import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class SessionUserFilterBottomSheet extends StatefulWidget {
  const SessionUserFilterBottomSheet({
    required this.filter,
    required this.users,
    super.key,
  });

  final SessionFilter filter;

  final List<SessionUserEntity> users;

  @override
  State<SessionUserFilterBottomSheet> createState() =>
      SessionUserFilterBottomSheetState();
}

class SessionUserFilterBottomSheetState
    extends State<SessionUserFilterBottomSheet> {
  late SessionFilter currentFilter;

  final FormControl<String> searchControl = FormControl();

  @override
  void initState() {
    currentFilter = widget.filter;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SessionUserFilterBottomSheet oldWidget) {
    setState(() {});

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReactiveValueListenableBuilder(
                  formControl: searchControl,
                  builder: (context, control, _) {
                    if (control.value != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Insets.xl,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Insets.s),
                            border: Border.all(color: const Color(0xFFDBDBDB)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ReactiveTextField<String>(
                                  autofocus: true,
                                  formControl: searchControl,
                                  style: context.texts.subtitle.copyWith(
                                    color: context.colors.darkGreyText,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                      left: Insets.l,
                                      right: Insets.l,
                                      top: Insets.l,
                                      bottom: Insets.l,
                                    ),
                                    hintText: ChatsI18n.search,
                                    hintStyle: context.texts.subtitle.copyWith(
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
                              Padding(
                                padding: const EdgeInsets.all(Insets.l),
                                child: GestureDetector(
                                  onTap: () {
                                    control.patchValue(null);
                                  },
                                  child: UiIcon(Assets.icons.iconCross.path),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Insets.m,
                            horizontal: Insets.xl,
                          ),
                          child: Text(
                            ChatsI18n.user,
                            style: context.texts.title.copyWith(
                              color: context.colors.semiBlack,
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            searchControl.patchValue('');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Insets.xl,
                            ),
                            child: UiIcon(Assets.icons.search.path),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UiCheckBoxCell(
                        label: ChatsI18n.all,
                        value: currentFilter.sessionUserEntity == null,
                        onTap: (value) {
                          if (value) {
                            setState(() {
                              currentFilter = currentFilter.copyWith(
                                sessionUserEntity: null,
                              );
                            });
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                      Expanded(
                        child: ReactiveValueListenableBuilder(
                          formControl: searchControl,
                          builder: (context, control, _) {
                            final filteredUsers =
                                (control.value?.isEmpty ?? true)
                                    ? widget.users
                                    : widget.users
                                        .where(
                                          (e) =>
                                              e.name?.toLowerCase().contains(
                                                control.value?.toLowerCase() ??
                                                    '',
                                              ) ??
                                              false,
                                        )
                                        .toList();
                            return ListView.builder(
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                return UiCheckBoxCell(
                                  label: filteredUsers[index].name ?? '',
                                  value:
                                      currentFilter.sessionUserEntity ==
                                      filteredUsers[index],
                                  onTap: (value) {
                                    if (value) {
                                      setState(() {
                                        currentFilter = currentFilter.copyWith(
                                          sessionUserEntity:
                                              filteredUsers[index],
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        currentFilter = currentFilter.copyWith(
                                          bot: null,
                                        );
                                      });
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                        currentFilter = widget.filter.copyWith(
                          sessionUserEntity: null,
                        );
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
