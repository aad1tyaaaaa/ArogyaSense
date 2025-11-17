import 'package:flutter/material.dart';
import 'package:health_app/core/shimmers/health_data_shimmer.dart';
import 'package:health_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:health_app/features/health_data/model/health_data_model.dart';
import 'package:health_app/features/health_data/viewmodel/health_data_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HealthDataScreen extends StatelessWidget {
  const HealthDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authVM.user?.uid ?? '';

    return ChangeNotifierProvider(
      create: (_) => HealthDataViewModel()..fetchLatestData(userId),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Health Dashboard'),
            actions: [
              IconButton(
                onPressed: () {
                  final vm = context.read<HealthDataViewModel>();
                  vm.fetchLatestData(userId);
                },
                tooltip: 'Refresh',
                icon: const Icon(
                  Icons.refresh,
                  semanticLabel: 'Refresh health data',
                ),
              ),
            ],
          ),
          body: Consumer<HealthDataViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return const HealthDataShimmer();
              }
              if (vm.error != null) {
                return Center(
                  child: Text(
                    vm.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              final data = vm.latestData ?? HealthDataModel();
              // if (data == null) {
              //   return _HealthDashboard(data: );
              // }
              return _HealthDashboard(data: data);
            },
          ),
        ),
      ),
    );
  }
}

class _HealthDashboard extends StatelessWidget {
  final HealthDataModel data;
  const _HealthDashboard({required this.data});

  @override
  Widget build(BuildContext context) {
    final String userName =
        Provider.of<AuthViewModel>(context, listen: false).user?.name ?? 'User';
    final today = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    String getGreeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Good Morning';
      } else if (hour < 17) {
        return 'Good Afternoon';
      } else {
        return 'Good Evening';
      }
    }

    final String greeting = getGreeting();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '$greeting, $userName',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            today,
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 24),
          _MetricCard(
            label: 'Heart Rate',
            value: data.heartRate != null ? '${data.heartRate}' : '--',
            unit: 'BPM',
            target: '60-100',
            icon: Icons.favorite,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 16),
          _MetricCard(
            label: 'Blood Oxygen',
            value: data.spo2 != null ? '${data.spo2}' : '--',
            unit: '%',
            target: '95-100',
            icon: Icons.bloodtype,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 16),
          _MetricCard(
            label: 'Steps Today',
            value: data.steps != null ? '${data.steps}' : '--',
            unit: 'steps',
            target: '10,000',
            icon: Icons.directions_walk,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          _MetricCard(
            label: 'Temperature',
            value: data.temperature != null ? '${data.temperature}' : '--',
            unit: '°C',
            target: '36.1-37.2',
            icon: Icons.thermostat,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          _MetricCard(
            label: 'Humidity',
            value: data.humidity != null ? '${data.humidity}' : '--',
            unit: '%',
            target: '40-80',
            icon: Icons.water_drop,
            color: Colors.teal,
          ),
          const SizedBox(height: 32),
          _SummaryCard(
            healthScore: 92, // Replace with real data if available
            activeMinutes: 127,
            sleepQuality: 8.2,
          ),
          const SizedBox(height: 24),
          _InsightsCard(),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label, value, unit, target;
  final IconData icon;
  final Color color;
  const _MetricCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.target,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$value $unit',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  Text(
                    'Target: $target',
                    style: TextStyle(fontSize: 12, color: Colors.white38),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int healthScore;
  final int activeMinutes;
  final double sleepQuality;
  const _SummaryCard({
    required this.healthScore,
    required this.activeMinutes,
    required this.sleepQuality,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Overall Health Score: $healthScore',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Active Minutes: $activeMinutes   |   Sleep Quality: $sleepQuality/10',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Insights',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '• Cardiovascular health is optimal.\n• Hydration is on track.\n• Remember to reach your step goal today!',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
