import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:settings/settings.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, @QueryParam('tab') this.tab});

  final String? tab;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends LoadingState<ProfilePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const ProfileTab(),
          actions: [
            Builder(
              builder: (context) {
                return InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    context.read<ProfileCubit>().logout();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: Insets.l),
                    child: UiIcon(Assets.icons.logout.path),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                bottom:
                    Insets.bottomNavBar +
                    MediaQuery.viewPaddingOf(context).bottom,
              ),
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (state.user?.authenticatedOrNull != null)
                    AccountTab(user: state.user!.authenticatedOrNull!)
                  else
                    const SizedBox.shrink(),
                  BillingTab(subscriptions: state.subscriptions),
                  if (state.user?.authenticatedOrNull != null)
                    const SettingsTab(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
