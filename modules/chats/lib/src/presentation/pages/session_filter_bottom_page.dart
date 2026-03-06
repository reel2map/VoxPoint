import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:chats/chats.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class SessionFilterBottomPage extends StatefulWidget {
  const SessionFilterBottomPage({
    required this.filter,
    required this.bots,
    super.key,
  });

  final SessionFilter filter;

  final List<BotEntity> bots;

  @override
  State<SessionFilterBottomPage> createState() =>
      SessionFilterBottomPageState();
}

class SessionFilterBottomPageState extends State<SessionFilterBottomPage> {
  late SessionFilter currentFilter;

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  late FormGroup form;

  @override
  void initState() {
    currentFilter = widget.filter.copyWith(
      useCount: widget.filter.logsCount != null,
    );

    form = FormGroup({
      'logs_count': FormControl<int>(value: currentFilter.logsCount),
      'logs_count_op': FormControl<String>(value: currentFilter.logsCountOp),
      'use_count': FormControl<bool>(value: widget.filter.logsCount != null),
      'start_time_from': FormControl<DateTime>(
        value: currentFilter.startTimeFromDateTime,
      ),
      'start_time_to': FormControl<DateTime>(
        value: currentFilter.startTimeToDateTime,
      ),
      'last_message_time_from': FormControl<DateTime>(
        value: currentFilter.lastMessageTimeFromDateTime,
      ),
      'last_message_time_to': FormControl<DateTime>(
        value: currentFilter.lastMessageTimeToDateTime,
      ),
    });

    _subscriptions.add(
      form.valueChanges.listen((event) {
        setState(() {
          currentFilter = currentFilter.copyWith(
            logsCount: event?['logs_count'] as int?,
            logsCountOp: event?['logs_count_op'] as String?,
            startTimeFrom: event?['start_time_from']?.toString(),
            startTimeTo: event?['start_time_to']?.toString(),
            lastMessageTimeFrom: event?['last_message_time_from']?.toString(),
            lastMessageTimeTo: event?['last_message_time_to']?.toString(),
          );
        });
      }),
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SessionFilterBottomPage oldWidget) {
    setState(() {});

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    for (final element in _subscriptions) {
      element.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(ChatsI18n.filter),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      body: ReactiveForm(
        formGroup: form,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: Insets.m,
                  horizontal: Insets.l,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ChatsI18n.agent,
                            style: context.texts.title.copyWith(
                              color: context.colors.semiBlack,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final result =
                                  await showModalBottomSheet<SessionFilter>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: context.colors.white100,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(Insets.xl),
                                      ),
                                    ),
                                    builder: (context) {
                                      return UiBottomSheet(
                                        heightFactor: 0.92,
                                        child: SessionFilterItemBottomSheet(
                                          filter: currentFilter,
                                          bots: widget.bots,
                                          filterType: SessionFilterType.agents,
                                        ),
                                      );
                                    },
                                  );

                              if (result != null) {
                                setState(() {
                                  currentFilter = result;
                                });
                              }
                            },
                            child: _InputField(value: currentFilter.bot?.name),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Insets.l),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ChatsI18n.communicationChannel,
                            style: context.texts.title.copyWith(
                              color: context.colors.semiBlack,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final result =
                                  await showModalBottomSheet<SessionFilter>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: context.colors.white100,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(Insets.xl),
                                      ),
                                    ),
                                    builder: (context) {
                                      return UiBottomSheet(
                                        heightFactor: 0.92,
                                        child: SessionFilterItemBottomSheet(
                                          filter: currentFilter,
                                          bots: widget.bots,
                                          filterType:
                                              SessionFilterType.channels,
                                        ),
                                      );
                                    },
                                  );

                              if (result != null) {
                                setState(() {
                                  currentFilter = result;
                                });
                              }
                            },
                            child: _InputField(
                              value: currentFilter.userType?.name,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Insets.l),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        ChatsI18n.messageCount,
                        style: context.texts.title.copyWith(
                          color: context.colors.semiBlack,
                        ),
                      ),
                      value: currentFilter.useCount,
                      onChanged: (value) {
                        final bool isSelected = value ?? false;

                        if (isSelected) {
                          form.control('logs_count').patchValue(1);
                          form.control('logs_count_op').patchValue('MORE_THAN');
                        } else {
                          form.control('logs_count').patchValue(null);
                          form.control('logs_count_op').patchValue(null);
                        }

                        setState(() {
                          currentFilter = currentFilter.copyWith(
                            useCount: value ?? false,
                            // logsCount: !isSelected ? null : currentFilter.logsCount,
                            // logsCountOp:
                            //     !isSelected ? null : currentFilter.logsCountOp,
                          );
                        });
                      },
                    ),
                    if (currentFilter.useCount)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Insets.l),
                        child: Row(
                          children: [
                            Expanded(
                              child: ComparisonDropdown(
                                formControlName: 'logs_count_op',
                                hintText: ChatsI18n.selectOperator,
                              ),
                            ),
                            const SizedBox(width: Insets.xl),
                            Expanded(
                              child: ReactiveTextField<int>(
                                formControlName: 'logs_count',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: context.texts.body.copyWith(
                                  color: context.colors.semiBlack,
                                ),

                                decoration: InputDecoration(
                                  hintText: ChatsI18n.count,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  labelStyle: context.texts.body.copyWith(
                                    color: context.colors.semiBlack,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    Divider(color: context.colors.lightGrey),
                    const SizedBox(height: Insets.l),
                    Center(
                      child: Text(
                        'Date filters',
                        style: context.texts.subtitle.copyWith(
                          color: context.colors.darkGreyText,
                        ),
                      ),
                    ),
                    const SizedBox(height: Insets.l),
                    Row(
                      children: [
                        Expanded(
                          child: ReactiveDateTimePicker(
                            formControlName: 'start_time_from',
                            type: ReactiveDatePickerFieldType.dateTime,
                            style: context.texts.body.copyWith(
                              color: context.colors.darkGreyText,
                            ),
                            decoration: InputDecoration(
                              labelText: 'First message from',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Insets.xl),
                              ),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                        const SizedBox(width: Insets.l),
                        Expanded(
                          child: ReactiveDateTimePicker(
                            formControlName: 'start_time_to',
                            type: ReactiveDatePickerFieldType.dateTime,
                            style: context.texts.body.copyWith(
                              color: context.colors.darkGreyText,
                            ),
                            decoration: InputDecoration(
                              labelText: 'First message to',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Insets.xl),
                              ),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Insets.l),
                    Row(
                      children: [
                        Expanded(
                          child: ReactiveDateTimePicker(
                            formControlName: 'last_message_time_from',
                            type: ReactiveDatePickerFieldType.dateTime,
                            style: context.texts.body.copyWith(
                              color: context.colors.darkGreyText,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Last message from',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Insets.xl),
                              ),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                        const SizedBox(width: Insets.l),
                        Expanded(
                          child: ReactiveDateTimePicker(
                            formControlName: 'last_message_time_to',
                            type: ReactiveDatePickerFieldType.dateTime,
                            style: context.texts.body.copyWith(
                              color: context.colors.darkGreyText,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Last message to',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Insets.xl),
                              ),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: Insets.xl),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Insets.m,
                  horizontal: Insets.xl,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: context.colors.lightGrey),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: UiButton(
                        type: UiButtonType.secondary,
                        label: ChatsI18n.clear,
                        onPressed: () {
                          setState(() {
                            form.reset();
                            currentFilter = widget.filter.copyWith(
                              bot: null,
                              userType: null,
                              sessionLength: null,
                              lastMessageTimeFrom: null,
                              lastMessageTimeTo: null,
                              logsCount: null,
                              logsCountOp: null,
                              startTimeFrom: null,
                              startTimeTo: null,
                              useCount: false,
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
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({super.key, this.value});

  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.s,
        vertical: Insets.m,
      ),
      decoration: BoxDecoration(
        color: context.colors.background,
        border: Border.all(),
        borderRadius: BorderRadius.circular(Insets.xxl),
      ),
      child: Row(
        children: [
          UiIcon(Assets.icons.search.path, useColor: false),
          const SizedBox(width: Insets.s),
          Expanded(
            child: Text(
              value ?? '',
              style: context.texts.body.copyWith(
                color: context.colors.semiBlack,
                height: 1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ComparisonDropdown extends StatelessWidget {
  const ComparisonDropdown({
    required this.formControlName,
    super.key,
    this.hintText,
    this.labelText,
  });
  final String formControlName;
  final String? hintText;
  final String? labelText;

  // Enum для операций сравнения
  static const Map<String, String> comparisonOperators = {
    'EQUAL': 'Equal',
    'NOT_EQUAL': 'Not equal',
    'MORE_THAN': 'Greater than',
    'LESS_THAN': 'Less than',
    'MORE_THAN_OR_EQUAL': 'Greater than or equal',
    'LESS_THAN_OR_EQUAL': 'Less than or equal',
  };

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField<String>(
      formControlName: formControlName,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(14),
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
        labelStyle: context.texts.body.copyWith(
          color: context.colors.semiBlack,
        ),
      ),

      style: context.texts.body.copyWith(
        color: context.colors.semiBlack,
        overflow: TextOverflow.ellipsis,
      ),
      isExpanded: true,
      items:
          comparisonOperators.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(
                ChatsI18n.selectLogsCountOp(entry.key),
                style: context.texts.body.copyWith(
                  color: context.colors.semiBlack,
                ),
              ),
            );
          }).toList(),
    );
  }
}
