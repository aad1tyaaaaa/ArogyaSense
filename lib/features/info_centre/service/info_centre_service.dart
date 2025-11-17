import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_app/core/utils/constants.dart';
import 'package:health_app/features/info_centre/model/info_topic.dart';

class InfoCentreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<InfoTopic>> fetchTopics() async {
    try {
      final snapshot = await _firestore.collection(infoCentreCollection).get();
      return snapshot.docs
          .map((doc) => InfoTopic.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch topics: $e.');
    }
  }

  Future<InfoTopic?> fetchTopicById(String id) async {
    try {
      final doc = await _firestore
          .collection(infoCentreCollection)
          .doc(id)
          .get();

      if (doc.exists) {
        return InfoTopic.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch topic by Id: $e.');
    }
  }
}
