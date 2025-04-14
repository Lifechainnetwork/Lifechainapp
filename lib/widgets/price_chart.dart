import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';

class PriceChart extends StatelessWidget {
  final String tokenSymbol;
  final List<FlSpot> priceData;
  final double minY;
  final double maxY;
  final bool isPositive;

  const PriceChart({
    super.key,
    required this.tokenSymbol,
    required this.priceData,
    required this.minY,
    required this.maxY,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$tokenSymbol Price',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  isPositive ? '+2.5%' : '-1.2%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: AppTheme.dividerColor, strokeWidth: 0.5);
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: bottomTitleWidgets,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: leftTitleWidgets,
                    reservedSize: 42,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 6,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: priceData,
                  isCurved: true,
                  gradient: LinearGradient(
                    colors:
                        isPositive
                            ? [
                              AppTheme.primaryColor.withValues(
                                alpha: 0.5 * 255,
                              ),
                              AppTheme.primaryColor,
                            ]
                            : [
                              Colors.red.withValues(alpha: 0.5 * 255),
                              Colors.red,
                            ],
                  ),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors:
                          isPositive
                              ? [
                                AppTheme.primaryColor.withValues(
                                  alpha: 0.2 * 255,
                                ),
                                AppTheme.primaryColor.withValues(
                                  alpha: 0.0 * 255,
                                ),
                              ]
                              : [
                                Colors.red.withValues(alpha: 0.2 * 255),
                                Colors.red.withValues(alpha: 0.0 * 255),
                              ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTimeFrameButton('1H', true),
            _buildTimeFrameButton('1D', false),
            _buildTimeFrameButton('1W', false),
            _buildTimeFrameButton('1M', false),
            _buildTimeFrameButton('1Y', false),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeFrameButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.grey, fontSize: 10);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('JAN', style: style);
        break;
      case 1:
        text = const Text('FEB', style: style);
        break;
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 3:
        text = const Text('APR', style: style);
        break;
      case 4:
        text = const Text('MAY', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 6:
        text = const Text('JUL', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.grey, fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('\$${value.toStringAsFixed(1)}', style: style),
    );
  }

  static List<FlSpot> getDemoPositiveData() {
    return [
      const FlSpot(0, 1.5),
      const FlSpot(1, 1.8),
      const FlSpot(2, 1.6),
      const FlSpot(3, 1.9),
      const FlSpot(4, 2.1),
      const FlSpot(5, 2.3),
      const FlSpot(6, 2.5),
    ];
  }

  static List<FlSpot> getDemoNegativeData() {
    return [
      const FlSpot(0, 2.5),
      const FlSpot(1, 2.3),
      const FlSpot(2, 2.1),
      const FlSpot(3, 1.9),
      const FlSpot(4, 1.7),
      const FlSpot(5, 1.5),
      const FlSpot(6, 1.3),
    ];
  }
}
