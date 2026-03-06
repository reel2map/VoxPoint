import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class IntegrationIcon extends StatelessWidget {
  const IntegrationIcon({required this.type, super.key});

  final String type;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      'chatwoot' => UiIcon(
        Assets.icons.chatWu.path,
        color: context.colors.mediumGrey,
      ),
      'facebook' => UiIcon(
        Assets.icons.facebook.path,
        color: context.colors.mediumGrey,
      ),
      'mailservice' => UiIcon(
        Assets.icons.mail.path,
        color: context.colors.mediumGrey,
      ),
      'email' => UiIcon(
        Assets.icons.msExchange.path,
        color: context.colors.mediumGrey,
      ),
      'imapsmtpservice' => UiIcon(
        Assets.icons.imapsmtp.path,
        color: context.colors.mediumGrey,
      ),
      'intercom' => UiIcon(
        Assets.icons.intercom.path,
        color: context.colors.mediumGrey,
      ),
      'sip' => UiIcon(Assets.icons.sip.path, color: context.colors.mediumGrey),
      'telegram' => UiIcon(
        Assets.icons.tg.path,
        color: context.colors.mediumGrey,
      ),
      'twilio' => UiIcon(
        Assets.icons.twilio.path,
        color: context.colors.mediumGrey,
      ),
      'translator' => UiIcon(
        Assets.icons.translator.path,
        color: context.colors.mediumGrey,
      ),
      'transcriptor' => UiIcon(
        Assets.icons.transcriptor.path,
        color: context.colors.mediumGrey,
      ),
      'fastopenai' => UiIcon(
        Assets.icons.iconFastLLM.path,
        color: context.colors.mediumGrey,
      ),
      'whatsapp' => UiIcon(
        Assets.icons.wapp.path,
        color: context.colors.mediumGrey,
      ),
      'api' => UiIcon(Assets.icons.api.path, color: context.colors.mediumGrey),
      'openai' => UiIcon(
        Assets.icons.iconLLM.path,
        color: context.colors.mediumGrey,
      ),
      'speechtotext' => UiIcon(
        Assets.icons.iconSpeechToText.path,
        color: context.colors.mediumGrey,
      ),
      'database' => UiIcon(
        Assets.icons.iconDataBase.path,
        color: context.colors.mediumGrey,
      ),
      'voip' => UiIcon(
        Assets.icons.voip.path,
        color: context.colors.mediumGrey,
      ),
      'texttospeech' => UiIcon(
        Assets.icons.iconTextToSpeech.path,
        color: context.colors.mediumGrey,
      ),
      'embedder_model' => UiIcon(
        Assets.icons.iconEmbedder.path,
        color: context.colors.mediumGrey,
      ),
      'birdapiservice' => UiIcon(
        Assets.icons.birdApi.path,
        color: context.colors.mediumGrey,
      ),
      'web' => UiIcon(Assets.icons.web.path, color: context.colors.mediumGrey),
      String() => const SizedBox(),
    };
  }
}
