import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final StreamController<SwipeRefreshState> _controller =
      StreamController.broadcast();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() async {
      await Future<void>.delayed(Durations.short1);

      if (!scrollController.position.hasPixels) {
        return;
      }

      final double pixels = scrollController.position.pixels;
      final double maxScrollExtent = scrollController.position.maxScrollExtent;
      final double viewportDimension =
          scrollController.position.viewportDimension;

      if (pixels >= maxScrollExtent - viewportDimension) {
        final bloc = context.read<SessionsCubit>();

        if (bloc.state.hasMore) {
          unawaited(bloc.nextPage());
        }
      }
    });

    context.read<SessionsCubit>().setBots(
      context.read<BotsCubit>().state.items,
    );

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<SessionsCubit, SessionsState>(
        listener: (context, state) {
          if (state.status.isFetchingInProgress) {
            _controller.add(SwipeRefreshState.loading);
          } else {
            _controller.add(SwipeRefreshState.hidden);
          }
        },
        builder: (context, state) {
          return BlocListener<BotsCubit, BotsState>(
            listener: (context, state) {
              context.read<SessionsCubit>().setBots(state.items);
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Column(
                  children: [
                    FlametreeSearchBar(
                      control: state.searchControl,
                      isFilterNotEmpty: state.filter.isNotEmpty,
                      searchBarItem: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () => _onTapFilter(context, state),
                        child: Padding(
                          padding: const EdgeInsets.all(Insets.l),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: Insets.s,
                            children: [
                              UiIcon(Assets.icons.search.path, useColor: false),
                              if (state.filter.sessionUserEntity != null)
                                Flexible(
                                  child: Text(
                                    state.filter.sessionUserEntity?.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: context.texts.subtitle.copyWith(
                                      color: context.colors.darkGreyText,
                                    ),
                                  ),
                                )
                              else
                                Flexible(
                                  child: Text(
                                    ChatsI18n.search,
                                    style: context.texts.subtitle.copyWith(
                                      color: context.colors.darkGreyText,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      onPressedFilter: () => _onPressedFilter(context, state),
                    ),
                    const SizedBox(height: Insets.l),
                    if (state.items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: Insets.xxxl),
                        child: Text(
                          ChatsI18n.noResults,
                          style: context.texts.body.copyWith(
                            color: context.colors.darkGreyText,
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: SwipeRefresh.builder(
                          stateStream: _controller.stream,
                          scrollController: scrollController,
                          onRefresh: context.read<SessionsCubit>().init,
                          itemCount: state.items.length,
                          itemBuilder:
                              (context, index) => DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        state.items.last != state.items[index]
                                            ? const BorderSide(
                                              color: Color(0xFFE9E9F8),
                                            )
                                            : BorderSide.none,
                                  ),
                                  borderRadius:
                                      index == 0
                                          ? const BorderRadius.only(
                                            topLeft: Radius.circular(Insets.xl),
                                            topRight: Radius.circular(
                                              Insets.xl,
                                            ),
                                          )
                                          : null,
                                  color: context.colors.white100,
                                ),
                                child: SessionCard(
                                  session: state.items[index],
                                  users: state.users,
                                  onPressedSession: () {
                                    context.navigateTo(
                                      SessionRoute(id: state.items[index].id),
                                    );
                                  },
                                ),
                              ),
                        ),
                      ),
                    const SizedBox(height: Insets.bottomNavBar),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onPressedFilter(
    BuildContext context,
    SessionsState state,
  ) async {
    final result = await context.router.push<SessionFilter>(
      SessionFilterBottomRoute(filter: state.filter, bots: state.bots),
    );
    // final result = await Navigator.of(context).push(
    //   MaterialPageRoute<SessionFilter>(
    //     builder: (context) {
    //       return SessionFilterBottomSheet(

    //       );
    //     },
    //   ),
    // );

    if (result != null) {
      unawaited(context.read<SessionsCubit>().setFilter(result));
    }
  }

  Future<void> _onTapFilter(BuildContext context, SessionsState state) async {
    final result = await showModalBottomSheet<SessionFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.white100,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Insets.xl)),
      ),
      builder: (context) {
        return UiBottomSheet(
          child: SessionUserFilterBottomSheet(
            filter: state.filter,
            users: state.users,
          ),
        );
      },
    );

    if (result != null) {
      unawaited(context.read<SessionsCubit>().setFilter(result));
    }
  }
}
