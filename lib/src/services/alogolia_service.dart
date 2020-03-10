import 'package:algolia/algolia.dart';
import '../models/student.dart';

class AlogoliaService {
  AlogoliaService._privateConstructor();

  static final AlogoliaService instance = AlogoliaService._privateConstructor();
  AlgoliaTask taskAdded, taskUpdated, taskDeleted;
  AlgoliaObjectSnapshot addedObject;
  static final algolisServices = AlogoliaService.instance;

  final Algolia _algolia = Algolia.init(
    applicationId: '3QP67BLU0T',
    apiKey: '5cf4a935655079910682450b8c7b69f2',
  );

  AlgoliaIndexReference get _students => _algolia.instance.index('students');

  Future<String> performUpdateStudentObject(updateData) async {
    taskUpdated = await _students.object().updateData(updateData);
    return taskUpdated.data['objectID'].toString();
  }

  Future<String> performDeleteStudentsObject(deleteData) async {
    taskAdded = await _students.deleteIndex();
    return taskDeleted.data['objectID'].toString();
  }

  Future<String> performAddStudentsObject(addData) async {
    taskAdded = await _students.addObject(addData);
    return taskAdded.data['objectID'].toString();
  }

  Future<List<Student>> performStudentSearch({text: String}) async {
    final query = _students.search(text);
    final snap = await query.getObjects();
    final students =
        snap.hits.map((students) => Student.fromJSON(students.data)).toList();
    return students;
  }
}
