import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class TotalSessionVolumeChart extends StatefulWidget {
  const TotalSessionVolumeChart({
    required this.period,
    required this.periods,
    super.key,
  });

  final PeriodType period;

  final List<DashboardAgentPeriodEntity> periods;

  @override
  State<TotalSessionVolumeChart> createState() =>
      _TotalSessionVolumeChartState();
}

class _TotalSessionVolumeChartState extends State<TotalSessionVolumeChart> {
  static const Color _barColor = Color(0xFF18D603);
  static const Color _barColor2 = Color(0xffFA8434);

  ChartType chartType = ChartType.bar;

  @override
  void didUpdateWidget(covariant TotalSessionVolumeChart oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  String get totalSessions =>
      widget.periods
          .map((e) => e.sessionsCount)
          .fold(0, (a, b) => a + b)
          .toString();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 363,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                ChatsI18n.totalSessionVolume,
                style: context.texts.title.copyWith(
                  color: context.colors.semiBlack,
                ),
              ),
              const SizedBox(width: Insets.xs),
              Text(
                totalSessions,
                style: context.texts.title.copyWith(
                  color: context.colors.mainOrange,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    chartType = ChartType.bar;
                  });
                },
                child: UiIcon(
                  Assets.icons.chatSquare2.path,
                  color:
                      chartType.isBar
                          ? context.colors.mainOrange
                          : context.colors.darkGreyText,
                ),
              ),
              const SizedBox(width: Insets.s),
              GestureDetector(
                onTap: () {
                  setState(() {
                    chartType = ChartType.linear;
                  });
                },
                child: UiIcon(
                  Assets.icons.graphUp.path,
                  color:
                      chartType.isLinear
                          ? context.colors.mainOrange
                          : context.colors.darkGreyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.xl),
          Expanded(
            child: switch (chartType) {
              ChartType.bar => _buildBarChart(),
              ChartType.linear => _buildLinearChart(),
            },
          ),
          const SizedBox(height: Insets.l),
          Row(
            spacing: Insets.s,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: Insets.xs),
                      width: Insets.s,
                      height: Insets.s,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _barColor,
                      ),
                    ),
                    const SizedBox(width: Insets.xs),
                    Text(
                      ChatsI18n.totalSessions,
                      style: context.texts.body.copyWith(
                        color: context.colors.semiBlack,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: Insets.xs),
                      width: Insets.s,
                      height: Insets.s,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _barColor2,
                      ),
                    ),
                    const SizedBox(width: Insets.xs),
                    Text(
                      ChatsI18n.answered,
                      style: context.texts.body.copyWith(
                        color: context.colors.semiBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (rodIndex == 0) {
                return BarTooltipItem(
                  widget.periods[group.x].sessionsCount.toString(),
                  context.texts.body,
                );
              }

              return BarTooltipItem(
                widget.periods[group.x].humanSessionsAnsweredCount.toString(),
                context.texts.body,
              );
            },
          ),
        ),
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
          border: Border(bottom: BorderSide(color: context.colors.lightGrey)),
        ),
        barGroups: barGroups(context),
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
    );
  }

  Widget _buildLinearChart() {
    final spots = <FlSpot>[];
    final spots2 = <FlSpot>[];

    for (int i = 0; i < widget.periods.length; i++) {
      spots.add(
        FlSpot(i.toDouble(), widget.periods[i].sessionsCount.toDouble()),
      );
      spots2.add(
        FlSpot(
          i.toDouble(),
          widget.periods[i].humanSessionsAnsweredCount.toDouble(),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine:
              (value) => FlLine(
                color: context.colors.lightGrey,
                strokeWidth: 1,
                dashArray: [3],
              ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: getTitles,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              getTitlesWidget: getLeftTitles,
              showTitles: true,
              minIncluded: false,
              maxIncluded: false,
            ),
          ),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        borderData: FlBorderData(
          border: Border(bottom: BorderSide(color: context.colors.lightGrey)),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            preventCurveOverShooting: true,
            color: _barColor,
            barWidth: Insets.xs,
            spots: spots,
          ),
          LineChartBarData(
            isCurved: true,
            preventCurveOverShooting: true,
            color: _barColor2,
            barWidth: Insets.xs,
            spots: spots2,
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots
                  .map(
                    (e) => LineTooltipItem(
                      e.y.toStringAsFixed(2),
                      context.texts.body,
                    ),
                  )
                  .toList();
            },
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> barGroups(BuildContext context) {
    final barGroups = List<BarChartGroupData>.empty(growable: true);

    for (int i = 0; i < widget.periods.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              width: Insets.l,
              color: _barColor,
              borderRadius: BorderRadius.circular(Insets.xxs),
              toY: widget.periods[i].sessionsCount.toDouble(),
            ),
            BarChartRodData(
              width: Insets.l,
              color: _barColor2,
              borderRadius: BorderRadius.circular(Insets.xxs),
              toY: widget.periods[i].humanSessionsAnsweredCount.toDouble(),
            ),
          ],
        ),
      );
    }
    return barGroups;
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
}
