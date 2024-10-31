import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:accesible_route/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).admin_reports_title),
        backgroundColor: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
      ),
      backgroundColor:
          isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').snapshots(),
                builder: (context, usersSnapshot) {
                  if (!usersSnapshot.hasData) {
                    return LoadingScreen();
                  }
                  final userDocs = usersSnapshot.data!.docs;
                  int totalUsers = userDocs.length;

                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('places').snapshots(),
                    builder: (context, placesSnapshot) {
                      if (!placesSnapshot.hasData) {
                        return LoadingScreen();
                      }

                      final placeDocs = placesSnapshot.data!.docs;
                      int totalPlaces = placeDocs.length;

                      double avgSessionTime =
                          35.2; // Ortalama kullanım süresi (sallama)

                      List<FlSpot> spots = List.generate(totalUsers, (index) {
                        return FlSpot(
                            index.toDouble(), (20 + index * 2).toDouble());
                      });

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: _buildInfoCard(
                              title: S.of(context).admin_reports_total_user,
                              value: '$totalUsers',
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            child: _buildInfoCard(
                              title: S.of(context).admin_reports_total_place,
                              value: '$totalPlaces',
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            child: _buildInfoCard(
                              title: S.of(context).admin_reports_average_app,
                              value: '$avgSessionTime dakika',
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            S.of(context).admin_reports_average_app_user,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          AspectRatio(
                            aspectRatio: 1.4,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: isDarkMode
                                          ? Colors.white12
                                          : Colors.black12,
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          '${S.of(context).admin_user_management_user} ${value.toInt() + 1}', // Kullanıcı indeksleri
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: true),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: spots,
                                    isCurved: true,
                                    color: Colors.amber,
                                    barWidth: 4,
                                    isStrokeCapRound: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required bool isDarkMode,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.amber : Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
