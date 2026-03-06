import 'dart:convert';

import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ui_kit/ui_kit.dart';

class SessionUserBottomSheet extends StatelessWidget {
  const SessionUserBottomSheet({required this.user, super.key});

  final SessionUserEntity user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ChatsI18n.userInfo,
            style: context.texts.title.copyWith(
              color: context.colors.semiBlack,
            ),
          ),
          const SizedBox(height: Insets.l),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _UserField(title: ChatsI18n.name, text: user.name),
                  Divider(
                    height: Insets.xl,
                    color: context.colors.extraLightGrey,
                  ),
                  _UserField(title: ChatsI18n.type, text: user.type.name),
                  Divider(
                    height: Insets.xl,
                    color: context.colors.extraLightGrey,
                  ),
                  _UserField(title: ChatsI18n.extId, text: user.extId),
                  const SizedBox(height: Insets.xl),
                ],
              ),
            ),
          ),
          Row(
            spacing: Insets.s,
            children: [
              Expanded(
                child: UiButton(
                  type: UiButtonType.secondary,
                  onPressed: _addContact,
                  label: ChatsI18n.addToContacts,
                ),
              ),
              Expanded(
                child: UiButton(
                  type: UiButtonType.secondary,
                  onPressed: _shareContact,
                  label: ChatsI18n.share,
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.l),
        ],
      ),
    );
  }

  Future<void> _addContact() async {
    if (await FlutterContacts.requestPermission()) {
      final newContact =
          Contact()
            ..name.first = user.name ?? ''
            ..emails = user.email != null ? [Email(user.email ?? '')] : []
            ..phones = [Phone(user.phone ?? user.extId)];

      await FlutterContacts.openExternalInsert(newContact);
    }
  }

  Future<void> _shareContact() async {
    final newContact =
        Contact()
          ..name.first = user.name ?? ''
          ..emails = user.email != null ? [Email(user.email ?? '')] : []
          ..phones = [Phone(user.phone ?? user.extId)];

    final bytes = const Utf8Encoder().convert(newContact.toVCard());

    final file = XFile.fromData(
      bytes,
      name: 'contact.vcf',
      length: bytes.lengthInBytes,
    );

    await Share.shareXFiles(
      [file],
      subject: user.name,
      fileNameOverrides: ['contact.vcf'],
    );
  }
}

class _UserField extends StatelessWidget {
  const _UserField({required this.title, this.text});

  final String title;

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: context.texts.subtitle.copyWith(
            color: context.colors.semiBlack,
          ),
        ),
        const SizedBox(height: Insets.xs),
        Row(
          spacing: Insets.s,
          children: [
            Expanded(
              child: SelectableText(
                text ?? '—',
                style: context.texts.subtitle.copyWith(
                  color: context.colors.mediumGrey,
                ),
              ),
            ),
            Visibility(
              visible: text != null,
              child: GestureDetector(
                onTap: () async {
                  if (text != null) {
                    await Clipboard.setData(ClipboardData(text: text ?? ''));
                  }
                },
                child: Icon(Icons.copy, color: context.colors.mediumGrey),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
