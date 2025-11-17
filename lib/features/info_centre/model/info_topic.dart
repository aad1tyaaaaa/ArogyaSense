class InfoTopic {
  InfoTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.sources,
  });

  factory InfoTopic.fromMap(Map<String, dynamic> map, String id) {
    return InfoTopic(
      id: id,
      title: map['title'],
      description: map['description'],
      videoUrl: map['videoUrl'],
      sources: List<String>.from(map['sources'] ?? []),
    );
  }

  final String id;
  final String title;
  final String description;
  final String? videoUrl;
  final List<String> sources;
}
