import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExerciseStatsChart extends StatefulWidget {
  ExerciseStatsChart({Key? key}) : super(key: key);

  @override
  _ExerciseStatsChartState createState() => _ExerciseStatsChartState();
}

class _ExerciseStatsChartState extends State<ExerciseStatsChart> {
  List<FlSpot> dataSpots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadChartData();
  }

  void loadChartData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      var querySnapshot = await FirebaseFirestore.instance
          .collection('exercises')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp')
          .get();

      List<FlSpot> spots = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        var timestamp = data['timestamp'] as Timestamp;
        var sets = data['sets'] as List<dynamic>;
        double totalWeight = sets.fold(
            0.0, (sum, set) => sum + (set['weight'] as num).toDouble());
        double x = timestamp
            .toDate()
            .difference(DateTime(2024, 1, 1))
            .inDays
            .toDouble(); // Eje x: días desde el inicio del año 2024
        double y = totalWeight; // Eje y: peso total
        spots.add(FlSpot(x, y));
      }

      if (!mounted) return;
      setState(() {
        dataSpots = spots;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      print('Error loading chart data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (dataSpots.isEmpty) {
      // No hay puntos de datos para mostrar
      return Center(child: Text('No data available'));
    } else {
      // Se garantiza que dataSpots no está vacía, por lo que es seguro llamar a .reduce
      double minX = dataSpots.map((spot) => spot.x).reduce(min);
      double maxX = dataSpots.map((spot) => spot.x).reduce(max);
      double minY = dataSpots.map((spot) => spot.y).reduce(min);
      double maxY = dataSpots.map((spot) => spot.y).reduce(max);

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(show: true),
            borderData: FlBorderData(show: true),
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                  spots: dataSpots, isCurved: true, color: Colors.blue),
            ],
          ),
        ),
      );
    }
  }
}
