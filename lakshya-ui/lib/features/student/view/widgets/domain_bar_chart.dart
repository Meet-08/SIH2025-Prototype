import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DomainBarChart extends StatelessWidget {
  final Map<String, int> domainScores;

  const DomainBarChart({super.key, required this.domainScores});

  @override
  Widget build(BuildContext context) {
    // Define max scores per domain (based on scoring rules)
    const maxScores = {
      'Logical': 19,
      'Creative': 15,
      'Social': 15,
      'Technical': 21,
    };

    final domainPercentages = domainScores.map((domain, rawScore) {
      final maxScore = maxScores[domain] ?? 100;
      final percentage = ((rawScore / maxScore) * 100).clamp(0, 100).round();
      return MapEntry(domain, percentage);
    });

    final domains = domainPercentages.keys.toList();
    final percentages = domainPercentages.values.toList();

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          maxY: 100,
          gridData: const FlGridData(show: true, horizontalInterval: 25),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (index, meta) {
                  if (index < domains.length) {
                    return Text(
                      domains[index.toInt()],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 25,
                getTitlesWidget: (value, meta) {
                  if (value % 25 == 0) {
                    return Text(
                      "${value.toInt()}",
                      style: const TextStyle(fontSize: 16),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                reservedSize: 30,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 0),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(domains.length, (index) {
            final color = _getBarColor(domains[index]);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: percentages[index].toDouble(),
                  width: 32,
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Color _getBarColor(String domain) {
    switch (domain) {
      case 'Logical':
        return Colors.blue;
      case 'Creative':
        return Colors.green;
      case 'Social':
        return Colors.yellow[700]!;
      case 'Technical':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
