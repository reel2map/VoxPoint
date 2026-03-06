import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class StageDistributionChart extends StatefulWidget {
  const StageDistributionChart({
    required this.period,
    required this.periods,
    super.key,
  });

  final PeriodType period;

  final List<DashboardCampaignPeriodEntity> periods;

  @override
  State<StageDistributionChart> createState() => _StageDistributionChartState();
}

class _StageDistributionChartState extends State<StageDistributionChart> {
  @override
  void didUpdateWidget(covariant StageDistributionChart oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 313,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ChatsI18n.stageDistribution,
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
                    getTooltipColor: (_) => context.colors.extraLightGrey,
                    maxContentWidth: 200,
                    fitInsideHorizontally: true,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final sortedStages =
                          widget.periods[group.x].stages
                              .sorted((a, b) => a.name.compareTo(b.name))
                              .toList();
                      return BarTooltipItem(
                        '',
                        textAlign: TextAlign.left,
                        context.texts.body,
                        children: [
                          for (int i = 0; i < sortedStages.length; i++)
                            TextSpan(
                              text:
                                  '${sortedStages[i].name}: ${sortedStages[i].value}${i + 1 == sortedStages.length ? '' : '\n'}',
                              style: context.texts.body.copyWith(
                                color: _barColors[i],
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
      final sortedStages =
          widget.periods[i].stages
              .sorted((a, b) => a.name.compareTo(b.name))
              .toList();
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              width: Insets.xl,
              borderRadius: BorderRadius.circular(Insets.xxs),
              rodStackItems: [
                for (int j = 0; j < sortedStages.length; j++)
                  _buildRodItem(j, sortedStages),
              ],
              toY: sortedStages.map((e) => e.value).fold(0, (a, b) => a + b),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  BarChartRodStackItem _buildRodItem(
    int index,
    List<DashboardCampaignItemEntity> stages,
  ) {
    double fromY = 0;

    double toY = 0;

    for (int i = 0; i <= index; i++) {
      toY += stages[i].value;
    }

    fromY = toY - stages[index].value;

    return BarChartRodStackItem(fromY, toY, _barColor(index));
  }

  final _barColors = [
    Colors.blue[600]!,
    Colors.pink[400]!,
    Colors.teal[600]!,
    Colors.orange[400]!,
    Colors.indigo[400]!,
    Colors.deepPurple[600]!,
    Colors.lightGreen[600]!,
    Colors.amber[600]!,
    Colors.cyan[400]!,
    Colors.red[600]!,
    Colors.grey[600]!,
    Colors.lime[600]!,
    Colors.purple[400]!,
    Colors.green[400]!,
    Colors.deepOrange[600]!,
    Colors.brown[600]!,
    Colors.lightBlue[600]!,
    Colors.yellow[600]!,
    Colors.blueGrey[400]!,
    Colors.pink[600]!,
    Colors.blue[400]!,
    Colors.teal[400]!,
    Colors.orange[600]!,
    Colors.indigo[600]!,
    Colors.deepPurple[400]!,
    Colors.lightGreen[400]!,
    Colors.amber[400]!,
    Colors.cyan[600]!,
    Colors.red[400]!,
    Colors.brown[400]!,
    Colors.lightBlue[400]!,
    Colors.blueGrey[600]!,
    Colors.purple[600]!,
    Colors.green[600]!,
    Colors.deepOrange[400]!,
    Colors.lime[400]!,
  ];

  Color _barColor(int index) {
    if (index >= _barColors.length) {
      return _barColors.first;
    }
    return _barColors[index];
  }
}
