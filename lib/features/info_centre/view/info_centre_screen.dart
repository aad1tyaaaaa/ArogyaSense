import 'package:flutter/material.dart';
import 'package:health_app/core/shimmers/info_centre_shimmer.dart';
import 'package:health_app/features/info_centre/view/topic_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:health_app/features/info_centre/viewmodel/info_centre_view_model.dart';
import '../model/info_topic.dart';

class InfoCentreScreen extends StatelessWidget {
  const InfoCentreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InfoCentreViewModel()..fetchTopics(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Info Centre')),
        body: Consumer<InfoCentreViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const InfoCentreShimmer();
            }
            if (vm.error != null) {
              return Center(
                child: Text(
                  vm.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            final topics = vm.topics;
            if (topics.isEmpty) {
              return const Center(child: Text('No topics available.'));
            }
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Curated health insights and evidence-based guidance.",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 24),
                ...topics.map((topic) => _TopicCard(topic: topic)),
                const SizedBox(height: 32),
                _FeaturedResourcesSection(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final InfoTopic topic;
  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    // Dummy icon and time for demo; you can map icons by topic if you wish
    final icon = Icons.info_outline;
    final time = _estimateTime(topic.title);

    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.cyanAccent, size: 32),
        title: Text(
          topic.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          topic.description,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.cyanAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            time,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TopicDetailScreen(topic: topic)),
          );
        },
      ),
    );
  }

  // Dummy time estimates based on topic title
  String _estimateTime(String title) {
    switch (title) {
      case 'Heart Health Basics':
        return '5 min';
      case 'Mental Wellness':
        return '8 min';
      case 'Nutrition Guidelines':
        return '6 min';
      case 'Exercise Fundamentals':
        return '7 min';
      case 'Sleep Optimization':
        return '4 min';
      case 'Preventive Care':
        return '6 min';
      case 'Vital Signs Guide':
        return '5 min';
      case 'Energy Management':
        return '6 min';
      default:
        return '5 min';
    }
  }
}

class _FeaturedResourcesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy values for featured resources
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Featured Resources',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Latest Articles: 1 new',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              'Video Content: 1 videos',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              'Expert Insights: 0 updates',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
