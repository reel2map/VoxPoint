import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:settings/src/_src.dart';
import 'package:ui_kit/ui_kit.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends LoadingState<SettingsTab> {
  bool useSystemPushNotification = false;
  bool useClientPushNotification = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    context.read<SettingsCubit>().initLocalAuth();

    final config = context.read<SettingsCubit>().state.user?.mobilePushConfig;

    useSystemPushNotification = config?.systemEnabled ?? false;

    useClientPushNotification = config?.agentsEnabled ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.status.isFetchingInProgress) {
          loadingOverlay.show(context);
        } else {
          loadingOverlay.hide();
        }
        final config =
            context.read<SettingsCubit>().state.user?.mobilePushConfig;

        useSystemPushNotification = config?.systemEnabled ?? false;

        useClientPushNotification = config?.agentsEnabled ?? false;
      },
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              children: [
                if (state.isPushAvailable) ...[
                  SwitchListTile(
                    value: useSystemPushNotification,
                    onChanged: (value) async {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        if (value) {
                          await context
                              .read<SettingsCubit>()
                              .enableSystemPushNotifications();
                        } else {
                          await context
                              .read<SettingsCubit>()
                              .disableSystemPushNotifications();
                        }
                      } catch (e, stackTrace) {
                        sl<Talker>().log(
                          e.toString(),
                          exception: e,
                          stackTrace: stackTrace,
                        );
                      }

                      setState(() {
                        isLoading = false;
                      });
                    },
                    title: Text(
                      SettingsI18n.pushNotificationSettings,
                      style: context.texts.body,
                    ),
                  ),

                  SwitchListTile(
                    value: useClientPushNotification,
                    onChanged: (value) async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        if (value) {
                          await context
                              .read<SettingsCubit>()
                              .enableClientPushNotifications();
                        } else {
                          await context
                              .read<SettingsCubit>()
                              .disableClientPushNotifications();
                        }
                      } catch (e, stackTrace) {
                        sl<Talker>().log(
                          e.toString(),
                          exception: e,
                          stackTrace: stackTrace,
                        );
                      }

                      setState(() {
                        isLoading = false;
                      });
                    },
                    title: Text(
                      SettingsI18n.clientPushNotificationSettings,
                      style: context.texts.body,
                    ),
                  ),
                ],

                const LocalAuthSwitcher(),
                const BiometrySwitcher(),
                const PinCodeChanger(),
                if (!state.isPushAvailable)
                  ListTile(
                    title: Text(
                      SettingsI18n.pushNotificationSettings,
                      style: context.texts.body,
                    ),
                  ),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: const UiProgressIndicator(),
              ),
          ],
        );
      },
    );
  }
}
