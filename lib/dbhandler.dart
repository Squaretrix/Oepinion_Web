import 'package:cloud_firestore/cloud_firestore.dart';

class DBHandlerService {
  final CollectionReference surveyCollection =
      FirebaseFirestore.instance.collection('Surveys');

  Future createSurvey(String category, String titel, String question) async {
    return await surveyCollection.add({
      'category': category,
      'title': titel,
      'question': question,
    });
  }

  Future updateSurvey(
      String doc_id, String category, String titel, String question) async {
    return await surveyCollection.doc(doc_id).update({
      'category': category,
      'title': titel,
      'question': question,
    });
  }

  Future deleteSurvey(String doc_id) async {
    return await surveyCollection.doc(doc_id).delete();
  }
}
