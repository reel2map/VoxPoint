import 'package:auto_route/auto_route.dart';
import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class SessionPage extends StatefulWidget {
  const SessionPage({@pathParam required this.id, super.key});

  final String id;

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends LoadingState<SessionPage> {
  bool showConfirmTakeOver = false;

  bool showConfirmReplay = false;

  late SessionCubit cubit;

  late final AppLifecycleListener _listener;

  @override
  void initState() {
    cubit =
        sl<SessionCubit>()
          ..init(widget.id, context.read<BotsCubit>().state.items);

    _listener = AppLifecycleListener(
      onShow: () async {
        cubit.init(widget.id, context.read<BotsCubit>().state.items);
      },
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SessionPage oldWidget) {
    if (oldWidget.id != widget.id) {
      cubit.init(widget.id, context.read<BotsCubit>().state.items);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _listener.dispose();
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocListener<BotsCubit, BotsState>(
        listener: (context, state) {
          sl<SessionCubit>().setBots(state.items);
        },
        child: BlocConsumer<SessionCubit, SessionState>(
          listener: (context, state) {
            if (state.status.isFetchingInProgress) {
              loadingOverlay.show(context);
            } else {
              loadingOverlay.hide();
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                leading: InkWell(
                  onTap: () => context.maybePop(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Insets.l),
                    child: Row(
                      children: [
                        SizedBox(
                          width: Insets.xl,
                          height: Insets.xl,
                          child: UiIcon(Assets.icons.iconArrowDown.path),
                        ),
                      ],
                    ),
                  ),
                ),
                title:
                    state.session != null
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: context.colors.white100,
                                    useRootNavigator: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(Insets.xl),
                                      ),
                                    ),
                                    builder: (context) {
                                      return UiBottomSheet(
                                        child: SessionUserBottomSheet(
                                          user: state.session!.user,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  state.session?.user.name ?? '',
                                  style: context.texts.title.copyWith(
                                    color: context.colors.semiBlack,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        : null,
                actions: [
                  if ((state.session?.sessionType == SessionType.operator ||
                          state.session?.sessionType == SessionType.copilot) &&
                      state.session?.operatorId == state.user?.id &&
                      state.session?.finishTime == null &&
                      (state.user?.role.isTenantAdmin ?? false))
                    Padding(
                      padding: const EdgeInsets.only(right: Insets.xs),
                      child: UiButton(
                        expanded: false,
                        type: UiButtonType.green,
                        label: ChatsI18n.resolve,
                        onPressed: context.read<SessionCubit>().resolve,
                      ),
                    ),
                  if (state.session != null)
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: context.read<SessionCubit>().share,
                      child: Padding(
                        padding: const EdgeInsets.only(right: Insets.l),
                        child: UiIcon(Assets.icons.share.path),
                      ),
                    ),
                ],
              ),
              body: Column(
                children: [
                  if (state.status.isFirstFetchingInProgress)
                    const Padding(
                      padding: EdgeInsets.only(top: Insets.xxxl),
                      child: Center(child: UiProgressIndicator()),
                    ),
                  if (state.session != null)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colors.white100,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(Insets.xxl),
                            topRight: Radius.circular(Insets.xxl),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Insets.l,
                                horizontal: Insets.xl,
                              ),
                              child: Row(
                                children: [
                                  IntegrationIcon(
                                    type: state.session!.user.type.name,
                                  ),
                                  const SizedBox(width: Insets.xs),
                                  Expanded(
                                    child: Text(
                                      state.session?.bot?.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: context.texts.subtitle.copyWith(
                                        color: context.colors.mediumGrey,
                                      ),
                                    ),
                                  ),
                                  if (state
                                          .session
                                          ?.userInfo?['country_code'] !=
                                      null)
                                    Flag.fromString(
                                      state.session?.userInfo?['country_code']
                                              ?.toString()
                                              .toLowerCase() ??
                                          '',
                                      width: Insets.xl,
                                      height: Insets.l,
                                    ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Color(0xFFE9E9F8)),
                            if (state.sortedLogs != null)
                              Expanded(
                                child: SessionChat(
                                  logs: state.sortedLogs ?? [],
                                  scrollController: state.scrollController,
                                  onCopilotTap: (text) {
                                    state.messageControl?.updateValue(text);
                                  },
                                ),
                              )
                            else
                              Expanded(
                                child: Shimmer.fromColors(
                                  baseColor: context.colors.white100,
                                  highlightColor: context.colors.background,
                                  child: UiCard(
                                    borderRadius: BorderRadius.circular(
                                      Insets.xl,
                                    ),
                                  ),
                                ),
                              ),

                            if ((state.session?.sessionType ==
                                        SessionType.operator ||
                                    state.session?.sessionType ==
                                        SessionType.copilot) &&
                                state.session?.operatorId == state.user?.id &&
                                state.session?.finishTime == null &&
                                (state.user?.role.isTenantAdmin ?? false))
                              Container(
                                padding: const EdgeInsets.only(
                                  top: Insets.s,
                                  left: Insets.l,
                                  right: Insets.l,
                                  bottom: Insets.xl,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: context.colors.lightGrey,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  spacing: Insets.s,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        spacing: Insets.s,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            spacing: Insets.s,
                                            children: [
                                              Text(
                                                ChatsI18n.copilot,
                                                style: context.texts.body
                                                    .copyWith(
                                                      color:
                                                          context
                                                              .colors
                                                              .darkGreyText,
                                                    ),
                                              ),
                                              UiSwitch(
                                                onTap: (value) {
                                                  context
                                                      .read<SessionCubit>()
                                                      .changeMode(
                                                        switch (value) {
                                                          true =>
                                                            SessionType.copilot,

                                                          false =>
                                                            SessionType
                                                                .operator,
                                                        },
                                                      );
                                                },
                                                value:
                                                    state
                                                        .session
                                                        ?.sessionType
                                                        .isCopilot ??
                                                    false,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    Insets.l,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          context
                                                              .colors
                                                              .lightGrey,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          Insets.s,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: ReactiveTextField<
                                                          String
                                                        >(
                                                          autocorrect: false,
                                                          enableSuggestions:
                                                              false,
                                                          minLines: 1,
                                                          maxLines: 4,
                                                          style: context
                                                              .texts
                                                              .body
                                                              .copyWith(
                                                                color:
                                                                    context
                                                                        .colors
                                                                        .darkGreyText,
                                                              ),
                                                          formControl:
                                                              state
                                                                  .messageControl,
                                                          onSubmitted: (
                                                            control,
                                                          ) {
                                                            context
                                                                .read<
                                                                  SessionCubit
                                                                >()
                                                                .sendLog();
                                                          },
                                                          decoration: InputDecoration.collapsed(
                                                            hintText:
                                                                ChatsI18n
                                                                    .typeYourMessage,
                                                            hintStyle: context
                                                                .texts
                                                                .body
                                                                .copyWith(
                                                                  color:
                                                                      context
                                                                          .colors
                                                                          .darkGreyText,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<SessionCubit>()
                                                      .sendLog();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: Insets.s,
                                                      ),
                                                  child: Icon(
                                                    Icons.send,
                                                    color:
                                                        context
                                                            .colors
                                                            .mainOrange,
                                                    size: Insets.xl,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (showConfirmTakeOver || showConfirmReplay)
                              TakeOverWidget(
                                title:
                                    showConfirmTakeOver
                                        ? ChatsI18n.takeOverConversation
                                        : ChatsI18n.joinConversation,
                                description:
                                    showConfirmTakeOver
                                        ? ChatsI18n
                                            .takeOverConversationDescription
                                        : ChatsI18n.joinConversationDescription,
                                onPressedDecline: () {
                                  setState(() {
                                    showConfirmTakeOver = false;
                                    showConfirmReplay = false;
                                  });
                                },
                                onPressedAccept: () {
                                  setState(() {
                                    showConfirmTakeOver = false;
                                    showConfirmReplay = false;
                                  });
                                  context.read<SessionCubit>().takeOver();
                                },
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Insets.xl,
                                  horizontal: Insets.l,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: context.colors.lightGrey,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  spacing: Insets.xs,
                                  children: [
                                    Expanded(
                                      child: UiButton(
                                        type: UiButtonType.secondary,
                                        onPressed: () {
                                          showModalBottomSheet<void>(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor:
                                                context.colors.white100,
                                            useRootNavigator: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(
                                                      Insets.xl,
                                                    ),
                                                  ),
                                            ),
                                            builder: (context) {
                                              return UiBottomSheet(
                                                heightFactor: 0.9,
                                                child: SessionBottomSheet(
                                                  fields:
                                                      state
                                                          .session
                                                          ?.conversationResult ??
                                                      {},
                                                  title: ChatsI18n.results,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        label: ChatsI18n.results,
                                        labelOverflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    Expanded(
                                      child: UiButton(
                                        type: UiButtonType.secondary,
                                        onPressed: () {
                                          showModalBottomSheet<void>(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor:
                                                context.colors.white100,
                                            useRootNavigator: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(
                                                      Insets.xl,
                                                    ),
                                                  ),
                                            ),
                                            builder: (context) {
                                              return UiBottomSheet(
                                                heightFactor: 0.9,
                                                child: SessionBottomSheet(
                                                  fields:
                                                      state.session?.envInfo ??
                                                      {},
                                                  title: ChatsI18n.parameters,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        label: ChatsI18n.parameters,
                                        labelOverflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    //если админ и сессия еще не завершена, показываем одну из кнопок
                                    if ((state.user?.role.isTenantAdmin ??
                                            false) &&
                                        state.session?.finishTime == null)
                                      switch (_getButtonState(state)) {
                                        TakeOverButtonState.takeOver =>
                                          Expanded(
                                            child: UiButton(
                                              type: UiButtonType.secondary,
                                              disabled:
                                                  state.session?.finishTime !=
                                                  null,
                                              onPressed: () {
                                                setState(() {
                                                  showConfirmTakeOver = true;
                                                });
                                              },
                                              label: ChatsI18n.takeOver,
                                              labelOverflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ),

                                        TakeOverButtonState.reply => Expanded(
                                          child: UiButton(
                                            type: UiButtonType.secondary,
                                            disabled:
                                                state.session?.finishTime !=
                                                null,
                                            onPressed: () {
                                              setState(() {
                                                showConfirmReplay = true;
                                              });
                                            },
                                            label: ChatsI18n.reply,
                                            labelOverflow:
                                                TextOverflow.ellipsis,
                                          ),
                                        ),
                                      },
                                  ],
                                ),
                              ),
                            SizedBox(
                              height:
                                  MediaQuery.viewPaddingOf(context).bottom +
                                  Insets.xl,
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
      ),
    );
  }

  TakeOverButtonState _getButtonState(SessionState state) {
    if ((state.session?.sessionType.isRegular ?? false) &&
        state.session?.operatorId == null) {
      return TakeOverButtonState.takeOver;
    }

    return TakeOverButtonState.reply;
  }

  String duration(SessionEntity? session) {
    if (session?.finishTime == null) return '';

    final duration = session!.finishTime!.difference(session.startTime);
    return formatDuration(duration);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final String hours = twoDigits(duration.inHours);
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours == 0) {
      return '$minutes:$seconds';
    } else {
      return '$hours:$minutes:$seconds';
    }
  }
}

enum TakeOverButtonState { takeOver, reply }
