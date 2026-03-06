import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class StatusDistributionChart extends StatefulWidget {
  const StatusDistributionChart({
    required this.period,
    required this.periods,
    super.key,
  });

  final PeriodType period;

  final List<DashboardCampaignPeriodEntity> periods;

  @override
  State<StatusDistributionChart> createState() =>
      _StatusDistributionChartState();
}

class _StatusDistributionChartState extends State<StatusDistributionChart> {
  @override
  void didUpdateWidget(covariant StatusDistributionChart oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final statuses = widget.periods.firstOrNull?.statuses ?? [];
    const itemsPerRow = 4;
    final rows = <Widget>[];

    for (int i = 0; i < statuses.length; i += itemsPerRow) {
      final rowItems = statuses.skip(i).take(itemsPerRow).toList();

      rows.add(
        Row(
          spacing: Insets.s,

          children:
              rowItems
                  .map(
                    (e) => StatusDistributionItem(
                      color: _barColor(e.id),
                      text: e.id,
                    ),
                  )
                  .toList(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 313,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ChatsI18n.statusDistribution,
            style: context.texts.title.copyWith(
              color: context.colors.semiBlack,
            ),
          ),
          const SizedBox(height: Insets.xl),
          Expanded(
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    maxContentWidth: 200,
                    fitInsideHorizontally: true,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final sortedStatuses =
                          widget.periods[group.x].statuses
                              .sorted((a, b) => a.name.compareTo(b.name))
                              .toList();
                      return BarTooltipItem(
                        '',
                        textAlign: TextAlign.left,
                        context.texts.body,
                        children: [
                          for (int i = 0; i < sortedStatuses.length; i++)
                            TextSpan(
                              text:
                                  '${sortedStatuses[i].id}: ${sortedStatuses[i].value}${i + 1 == sortedStatuses.length ? '' : '\n'}',
                              style: context.texts.body.copyWith(
                                color: _barColors[sortedStatuses[i].id],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                barGroups: barGroups(),
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine:
                      (value) => FlLine(
                        color: context.colors.lightGrey,
                        strokeWidth: 1,
                        dashArray: [3],
                      ),
                ),
                borderData: FlBorderData(
                  border: Border(
                    bottom: BorderSide(color: context.colors.lightGrey),
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: getTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 40,
                      getTitlesWidget: getLeftTitles,
                      showTitles: true,
                      maxIncluded: false,
                    ),
                  ),
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                ),
              ),
            ),
          ),
          const SizedBox(height: Insets.l),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows),
          // Row(
          //   spacing: Insets.s,
          //   children: [
          //     ...widget.periods.firstOrNull?.statuses.map(
          //           (e) => StatusDistributionItem(
          //             color: _barColor(e.id),
          //             text: e.id,
          //           ),
          //         ) ??
          //         [],
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(
        value.toStringAsFixed(0),
        style: context.texts.body.copyWith(color: context.colors.darkGrey),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    String text;

    text = DateFormat(switch (widget.period) {
      PeriodType.week => DateFormats.ddMM,
      PeriodType.month => DateFormats.ddMM,
      PeriodType.year => DateFormats.MMMyy,
    }).format(widget.periods[value.toInt()].period);

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(
        text,
        style: context.texts.body.copyWith(
          color: context.colors.darkGrey,
          fontSize: 12,
        ),
      ),
    );
  }

  List<BarChartGroupData> barGroups() {
    final barGroups = List<BarChartGroupData>.empty(growable: true);

    for (int i = 0; i < widget.periods.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              width: Insets.xl,
              borderRadius: BorderRadius.circular(Insets.xxs),
              rodStackItems: [
                for (int j = 0; j < widget.periods[i].statuses.length; j++)
                  _buildRodItem(j, widget.periods[i].statuses),
              ],
              toY: widget.periods[i].statuses
                  .map((e) => e.value)
                  .fold(0, (a, b) => a + b),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  BarChartRodStackItem _buildRodItem(
    int index,
    List<DashboardCampaignItemEntity> statuses,
  ) {
    double fromY = 0;

    double toY = 0;

    for (int i = 0; i <= index; i++) {
      toY += statuses[i].value;
    }

    fromY = toY - statuses[index].value;

    return BarChartRodStackItem(fromY, toY, _barColor(statuses[index].id));
  }

  final _barColors = {
    'Negative': const Color(0xFFFE6150),
    'Uncertain': const Color(0xFFD6D7E0),
    'Positive': const Color(0xFF7497F7),
    'Success': const Color(0xFF18D603),
  };

  Color _barColor(String id) {
    return _barColors[id] ?? const Color(0xFFD6D7E0);
  }
}
