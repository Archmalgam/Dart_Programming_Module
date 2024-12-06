import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StudentsRecord extends FirestoreRecord {
  StudentsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Intake" field.
  String? _intake;
  String get intake => _intake ?? '';
  bool hasIntake() => _intake != null;

  // "StudentID" field.
  String? _studentID;
  String get studentID => _studentID ?? '';
  bool hasStudentID() => _studentID != null;

  // "StudentName" field.
  String? _studentName;
  String get studentName => _studentName ?? '';
  bool hasStudentName() => _studentName != null;

  // "StudentPassword" field.
  String? _studentPassword;
  String get studentPassword => _studentPassword ?? '';
  bool hasStudentPassword() => _studentPassword != null;

  // "DateAdded" field.
  DateTime? _dateAdded;
  DateTime? get dateAdded => _dateAdded;
  bool hasDateAdded() => _dateAdded != null;

  void _initializeFields() {
    _intake = snapshotData['Intake'] as String?;
    _studentID = snapshotData['StudentID'] as String?;
    _studentName = snapshotData['StudentName'] as String?;
    _studentPassword = snapshotData['StudentPassword'] as String?;
    _dateAdded = snapshotData['DateAdded'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Students');

  static Stream<StudentsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => StudentsRecord.fromSnapshot(s));

  static Future<StudentsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => StudentsRecord.fromSnapshot(s));

  static StudentsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      StudentsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static StudentsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      StudentsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'StudentsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is StudentsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createStudentsRecordData({
  String? intake,
  String? studentID,
  String? studentName,
  String? studentPassword,
  DateTime? dateAdded,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Intake': intake,
      'StudentID': studentID,
      'StudentName': studentName,
      'StudentPassword': studentPassword,
      'DateAdded': dateAdded,
    }.withoutNulls,
  );

  return firestoreData;
}

class StudentsRecordDocumentEquality implements Equality<StudentsRecord> {
  const StudentsRecordDocumentEquality();

  @override
  bool equals(StudentsRecord? e1, StudentsRecord? e2) {
    return e1?.intake == e2?.intake &&
        e1?.studentID == e2?.studentID &&
        e1?.studentName == e2?.studentName &&
        e1?.studentPassword == e2?.studentPassword &&
        e1?.dateAdded == e2?.dateAdded;
  }

  @override
  int hash(StudentsRecord? e) => const ListEquality().hash([
        e?.intake,
        e?.studentID,
        e?.studentName,
        e?.studentPassword,
        e?.dateAdded
      ]);

  @override
  bool isValidKey(Object? o) => o is StudentsRecord;
}
