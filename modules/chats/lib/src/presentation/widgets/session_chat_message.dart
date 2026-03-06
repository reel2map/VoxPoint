import 'dart:convert';

import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ui_kit/ui_kit.dart';

class SessionChatMessage extends StatelessWidget {
  const SessionChatMessage({
    required this.log,
    required this.onCopilotTap,
    super.key,
  });

  final LogEntity log;

  final void Function(String text) onCopilotTap;

  @override
  Widget build(BuildContext context) {
    //    print(log.text.replaceAll('<br>', '<div class="br"></div>'));
    if (log.role.isAi || log.role.isOperator) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: Insets.m,
                horizontal: Insets.l,
              ),
              decoration: BoxDecoration(
                color: context.colors.extraLightGrey,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Insets.l),
                  bottomRight: Radius.circular(Insets.l),
                  topRight: Radius.circular(Insets.l),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Insets.s,
                children: [
                  Html(
                    shrinkWrap: true,
                    data: log.text.replaceAll('<br>', '<div></div>'),
                    onLinkTap: (url, attributes, element) async {
                      if (url != null && await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      }
                    },
                    style: {
                      '*': Style(
                        color: context.colors.semiBlack,
                        fontFamily: FontFamily.commissioner,
                      ),
                      'p': Style(
                        color: context.colors.semiBlack,
                        padding: HtmlPaddings.all(0),
                        fontFamily: FontFamily.commissioner,
                        margin: Margins.all(0),
                      ),
                      'div': Style(
                        color: context.colors.semiBlack,
                        padding: HtmlPaddings.all(0),
                        fontFamily: FontFamily.commissioner,
                        margin: Margins.all(0),
                      ),
                      'ul': Style(
                        color: context.colors.semiBlack,
                        padding: HtmlPaddings.only(left: 16),
                        fontFamily: FontFamily.commissioner,
                        margin: Margins.all(0),
                      ),
                      'a': Style(
                        padding: HtmlPaddings.only(left: 0),
                        fontFamily: FontFamily.commissioner,
                        margin: Margins.all(0),
                      ),
                    },
                  ),

                  // Text(
                  //   log.text,
                  // style: context.texts.body.copyWith(
                  //     color: context.colors.semiBlack,
                  //   ),
                  // ),
                  Row(
                    spacing: Insets.xs,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          '${DateFormat(DateFormats.ddMMMyyyy).format(log.timestamp.toLocal())}・${DateFormat(DateFormats.hhmm).format(log.timestamp.toLocal())}',
                          style: context.texts.body.copyWith(
                            color: context.colors.mediumGrey,
                          ),
                        ),
                      ),
                      if (log.role.isOperator)
                        const Icon(Icons.headphones_outlined, size: Insets.l),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (log.role.isCopilot) {
      return InkWell(
        onTap: () {
          onCopilotTap.call(log.text);
        },
        child: Row(
          children: [
            Flexible(
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  color: context.colors.lightGrey,
                  radius: const Radius.circular(Insets.s),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Insets.m,
                    horizontal: Insets.l,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Insets.l),
                      bottomRight: Radius.circular(Insets.l),
                      topRight: Radius.circular(Insets.l),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Insets.s,
                    children: [
                      Row(
                        spacing: Insets.s,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_outline, size: Insets.l),
                          Expanded(
                            child: Text(
                              ChatsI18n.draftFromCopilot,
                              style: context.texts.body.copyWith(
                                color: context.colors.semiBlack,
                              ),
                            ),
                          ),
                          const Icon(Icons.copy, size: Insets.l),
                        ],
                      ),
                      Text(
                        log.text,
                        style: context.texts.body.copyWith(
                          color: context.colors.semiBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.7),
              padding: const EdgeInsets.symmetric(
                vertical: Insets.m,
                horizontal: Insets.l,
              ),
              decoration: BoxDecoration(
                color: context.colors.semiBlack,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Insets.l),
                  topRight: Radius.circular(Insets.l),
                  topLeft: Radius.circular(Insets.l),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: Insets.s,
                children: [
                  if (log.text.isNotEmpty)
                    Text(
                      log.text,
                      style: context.texts.body.copyWith(
                        color: context.colors.white100,
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...log.attachments
                          .where((e) => e.contentType.contains('image'))
                          .map((e) => ImageAttachmentPreview(attachment: e)),
                    ],
                  ),
                  ...log.attachments
                      .where((e) => !e.contentType.contains('image'))
                      .map(
                        (e) => Text(
                          e.fileName,
                          style: context.texts.body.copyWith(
                            color: context.colors.mediumGrey,
                          ),
                        ),
                      ),
                  Text(
                    '${DateFormat(DateFormats.ddMMMyyyy).format(log.timestamp.toLocal())}・${DateFormat(DateFormats.hhmm).format(log.timestamp.toLocal())}',
                    style: context.texts.body.copyWith(
                      color: context.colors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ImageAttachmentPreview extends StatelessWidget {
  const ImageAttachmentPreview({required this.attachment, super.key});

  final LogAttachmentEntity attachment;

  @override
  Widget build(BuildContext context) {
    if (attachment.content == null) {
      return Container(
        width: Insets.xxl,
        height: Insets.xxl,
        decoration: BoxDecoration(
          color: context.colors.background,
          borderRadius: BorderRadius.circular(Insets.s),
        ),
      );
    }
    return imageFromBase64String(context);
  }

  Widget imageFromBase64String(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        //TODO: save image
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Insets.s),
        child: Container(
          width: Insets.xxl,
          height: Insets.xxl,
          color: context.colors.background,
          child: Image.memory(
            base64Decode(attachment.content ?? ''),
            width: Insets.xxl,
            height: Insets.xxl,
          ),
        ),
      ),
    );
  }
}
