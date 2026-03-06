import 'package:chats/chats.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class OperatorSessionBreakdownChart extends StatefulWidget {
  const OperatorSessionBreakdownChart({
    required this.period,
    required this.periods,
    super.key,
  });

  final PeriodType period;

  final List<DashboardAgentPeriodEntity> periods;

  @override
  State<OperatorSessionBreakdownChart> createState() =>
      _OperatorSessionBreakdownChartState();
}

class _OperatorSessionBreakdownChartState
    extends State<OperatorSessionBreakdownChart> {
  static const Color _transferredToOperatorColor = Color(0xFFF3A701);

  static const Color _answeredByOperatorColor = Color(0xFF7497F7);

  static const Color _resolvedByOperator = Color(0xFF18D603);

  String get handedOver =>
      widget.periods
          .map((e) => e.operatorSessionsCount)
          .fold(0, (a, b) => a + b)
          .toString();

  String get resolved =>
      widget.periods
          .map((e) => e.operatorSessionsResolvedCount)
          .fold(0, (a, b) => a + b)
          .toString();

  String get started =>
      widget.periods
          .map((e) => e.operatorSessionsAnsweredCount)
          .fold(0, (a, b) => a + b)
          .toString();

  ChartType chartType = ChartType.bar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 313,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: Insets.s,
            children: [
              Expanded(
                child: Text(
                  ChatsI18n.operatorSessionBreakdown,
                  style: context.texts.title.copyWith(
                    color: context.colors.semiBlack,
                  ),
                ),
              ),
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
                        color: _transferredToOperatorColor,
                      ),
                    ),
                    const SizedBox(width: Insets.xs),
                    Text(
                      '${ChatsI18n.handedOver}: $handedOver',
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
                        color: _resolvedByOperator,
                      ),
                    ),
                    const SizedBox(width: Insets.xs),
                    Text(
                      '${ChatsI18n.resolved}: $resolved',
                      style: context.texts.body.copyWith(
                        color: context.colors.semiBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                        color: _answeredByOperatorColor,
                      ),
                    ),
                    const SizedBox(width: Insets.xs),
                    Text(
                      '${ChatsI18n.startedConversation}: $started',
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
                  widget.periods[group.x].operatorSessionsCount.toString(),
                  context.texts.body,
                );
              }
              if (rodIndex == 1) {
                return BarTooltipItem(
                  widget.periods[group.x].operatorSessionsAnsweredCount
                      .toString(),
                  context.texts.body,
                );
              }
              if (rodIndex == 2) {
                return BarTooltipItem(
                  widget.periods[group.x].operatorSessionsResolvedCount
                      .toString(),
                  context.texts.body,
                );
              }
              return null;
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
        barGroups: barGroups(),
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
    final spotsHandOver = <FlSpot>[];

    final spotsResolver = <FlSpot>[];

    final spotsStarted = <FlSpot>[];

    for (int i = 0; i < widget.periods.length; i++) {
      spotsHandOver.add(
        FlSpot(
          i.toDouble(),
          widget.periods[i].operatorSessionsCount.toDouble(),
        ),
      );

      spotsResolver.add(
        FlSpot(
          i.toDouble(),
          widget.periods[i].operatorSessionsResolvedCount.toDouble(),
        ),
      );

      spotsStarted.add(
        FlSpot(
          i.toDouble(),
          widget.periods[i].operatorSessionsAnsweredCount.toDouble(),
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
            color: _transferredToOperatorColor,
            barWidth: Insets.xs,
            spots: spotsHandOver,
          ),
          LineChartBarData(
            isCurved: true,
            preventCurveOverShooting: true,
            color: _resolvedByOperator,
            barWidth: Insets.xs,
            spots: spotsResolver,
          ),
          LineChartBarData(
            isCurved: true,
            preventCurveOverShooting: true,
            color: _answeredByOperatorColor,
            barWidth: Insets.xs,
            spots: spotsStarted,
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

  List<BarChartGroupData> barGroups() {
    final barGroups = List<BarChartGroupData>.empty(growable: true);

    for (int i = 0; i < widget.periods.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              width: 7,
              color: _transferredToOperatorColor,
              toY: widget.periods[i].operatorSessionsCount.toDouble(),
              borderRadius: BorderRadius.circular(Insets.xxs),
            ),
            BarChartRodData(
              width: 7,
              color: _answeredByOperatorColor,
              toY: widget.periods[i].operatorSessionsAnsweredCount.toDouble(),
              borderRadius: BorderRadius.circular(Insets.xxs),
            ),
            BarChartRodData(
              width: 7,
              color: _resolvedByOperator,
              toY: widget.periods[i].operatorSessionsResolvedCount.toDouble(),
              borderRadius: BorderRadius.circular(Insets.xxs),
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
