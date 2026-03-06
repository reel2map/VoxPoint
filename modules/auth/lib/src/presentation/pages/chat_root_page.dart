import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:config/config.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage(name: 'ChatRootRouter')
class ChatRootPage extends StatelessWidget {
  const ChatRootPage({super.key, @QueryParam('session_id') this.sessionId});

  final String? sessionId;

  String get domain {
    switch (Flavor.status) {
      case FlavorStatus.development:
        return 'https://portal.flametree.dev.enfint.ai';
      case FlavorStatus.testing:
        return 'https://portal.flametree.test.enfint.ai';
      case FlavorStatus.production:
        return 'https://portal.flametree.ai';
      case FlavorStatus.demo:
        return 'https://portal.flametree.demo.ai';
    }
  }
  /*
  String get botId {
    if (Flavor.status.isDev) {
      return '1bc67e0b-187b-4ab5-b5a3-8455cb0fecde';
    }

    return '56420cfb-56a7-4f24-ac82-08f6bcd6ebff';
  }

  String get authorizationToken {
    if (Flavor.status.isDev) {
      return '7B3bCUSDBZ7Z5XIJ5r3q5jQure4kat9ru8wHu5VL3iALB3F2zi';
    }

    return 'LXos8BqOnBXRe3NOTBf2qc3SqKPSc91txGNXk9LRHp7CISu270';
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.user?.isNotAuthenticated ?? true) {
          return const Scaffold();
        }

        return Scaffold(
          body: SafeArea(
            child: BlocBuilder<SupportChatCubit, SupportChatState>(
              builder: (context, supportState) {
                if (supportState.status.isFetchingSuccess) {
                  return UiBotWidget(
                    domain: domain,
                    userId: state.user!.authenticatedOrNull!.id,
                    userName: state.user!.authenticatedOrNull!.fullName,
                    botId: supportState.botId,
                    authorizationToken: supportState.token,
                    sessionId: sessionId,
                  );
                }

                return const UiProgressIndicator();
              },
            ),
          ),
        );
      },
    );
  }
}
