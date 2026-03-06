import 'package:auth/src/_src.dart';
import 'package:auto_route/auto_route.dart';
import 'package:config/config.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onResult, this.useAppBar = false});

  final void Function(bool)? onResult;

  final bool useAppBar;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends LoadingState<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  int countLogTaps = 0;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    controller.repeat(reverse: true);

    super.initState();
  }

  void onFinish(BuildContext context) {
    if (widget.onResult == null) {
      context.router.pushNamed('/');
    } else {
      widget.onResult?.call(true);
    }
  }

  @override
  void dispose() {
    controller
      ..stop()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) {
        return sl<LoginCubit>()..checkAuth();
      },
      child: Scaffold(
        backgroundColor: context.colors.white100,
        appBar: widget.useAppBar ? AppBar() : null,
        body: Stack(
          children: [
            // Градиентный фон
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, 1.3), // центр сильно вниз
                    radius: 1.2,
                    colors: [
                      context.colors.mainOrange, // яркий оранжевый
                      context.colors.mainOrange.withAlpha(0), // прозрачный
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: double.infinity,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: Insets.xxxl),
                  SafeArea(
                    child: Center(
                      child: Assets.images.logoOnWhite.image(
                        package: 'ui_kit',
                        width: 132,
                      ),
                    ),
                  ),

                  // const Spacer(),
                  GestureDetector(
                    onTap: () {
                      countLogTaps++;

                      if (countLogTaps % 5 == 0) {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => TalkerScreen(talker: sl()),
                          ),
                        );
                      }
                    },
                    child: Text(
                      AuthI18n.aiHuman,
                      textAlign: TextAlign.center,
                      style: context.texts.accent.copyWith(
                        fontSize: 32,
                        height: 40 / 32,
                        color: context.colors.darkGreyText,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Insets.l,
                      Insets.xxl,
                      Insets.l,
                      Insets.l,
                    ),
                    child: Text(
                      AuthI18n.description,
                      textAlign: TextAlign.center,
                      style: context.texts.title.copyWith(
                        color: context.colors.darkGreyText,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SafeArea(
                    child: BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state.status.isFetchingInProgress) {
                          loadingOverlay.show(context);
                        } else {
                          loadingOverlay.hide();
                        }

                        if (state.stateStatus.isFinish) {
                          onFinish(context);
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(Insets.xl),
                              child: UiCard(
                                color: context.colors.white100,
                                padding: const EdgeInsets.all(Insets.xl),
                                child: Column(
                                  children: [
                                    UiButton(
                                      label: AuthI18n.login,
                                      onPressed:
                                          context.read<LoginCubit>().login,
                                    ),
                                    const SizedBox(height: Insets.xl),
                                    Text(
                                      AuthI18n.youAgree,
                                      style: context.texts.body.copyWith(
                                        color: context.colors.darkGrey,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: parseToLinksText(
                                          AuthI18n.termOfService,
                                          [
                                            () {
                                              launchUrl(
                                                Uri.parse(Env.termOfServiceUrl),
                                              );
                                            },
                                            () {
                                              launchUrl(
                                                Uri.parse(Env.privacyPolicyUrl),
                                              );
                                            },
                                          ],
                                          context.texts.body.copyWith(
                                            color: context.colors.darkGrey,
                                          ),
                                          context.texts.body.copyWith(
                                            color: context.colors.mainOrange,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
