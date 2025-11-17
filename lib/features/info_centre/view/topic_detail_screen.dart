import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../model/info_topic.dart';

class TopicDetailScreen extends StatelessWidget {
  final InfoTopic topic;
  const TopicDetailScreen({required this.topic, super.key});

  @override
  Widget build(BuildContext context) {
    final isYoutube =
        topic.videoUrl != null &&
        (topic.videoUrl!.contains('youtube.com') ||
            topic.videoUrl!.contains('youtu.be'));
    final videoId = isYoutube
        ? YoutubePlayer.convertUrlToId(topic.videoUrl!)
        : null;

    log('videoUrl: ${topic.videoUrl}');
    log('isYoutube: $isYoutube');
    log('videoId: $videoId');

    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            topic.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(topic.description, style: const TextStyle(fontSize: 16)),
          if (isYoutube && videoId != null) ...[
            const SizedBox(height: 24),
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: videoId,
                flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
              ),
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.cyanAccent,
            ),
          ],
          if (topic.sources.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Sources',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...topic.sources.map(
              (s) => Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(s, style: const TextStyle(color: Colors.blue)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
