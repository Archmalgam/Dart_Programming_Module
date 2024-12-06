import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LecturersRecord extends FirestoreRecord {
  LecturersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "LecturerID" field.
  String? _lecturerID;
  String get lecturerID => _lecturerID ?? '';
  bool hasLecturerID() => _lecturerID != null;

  // "LecturerName" field.
  String? _lecturerName;
  String get lecturerName => _lecturerName ?? '';
  bool hasLecturerName() => _lecturerName != null;

  // "LecturerPassword" field.
  String? _lecturerPassword;
  String get lecturerPassword => _lecturerPassword ?? '';
  bool hasLecturerPassword() => _lecturerPassword != null;

  // "DateAdded" field.
  DateTime? _dateAdded;
  DateTime? get dateAdded => _dateAdded;
  bool hasDateAdded() => _dateAdded != null;

  void _initializeFields() {
    _lecturerID = snapshotData['LecturerID'] as String?;
    _lecturerName = snapshotData['LecturerName'] as String?;
    _lecturerPassword = snapshotData['LecturerPassword'] as String?;
    _dateAdded = snapshotData['DateAdded'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Lecturers');

  static Stream<LecturersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LecturersRecord.fromSnapshot(s));

  static Future<LecturersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LecturersRecord.fromSnapshot(s));

  static LecturersRecord fromSnapshot(DocumentSnapshot snapshot) =>
      LecturersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LecturersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LecturersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LecturersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LecturersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLecturersRecordData({
  String? lecturerID,
  String? lecturerName,
  String? lecturerPassword,
  DateTime? dateAdded,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'LecturerID': lecturerID,
      'LecturerName': lecturerName,
      'LecturerPassword': lecturerPassword,
      'DateAdded': dateAdded,
    }.withoutNulls,
  );

  return firestoreData;
}

class LecturersRecordDocumentEquality implements Equality<LecturersRecord> {
  const LecturersRecordDocumentEquality();

  @override
  bool equals(LecturersRecord? e1, LecturersRecord? e2) {
    return e1?.lecturerID == e2?.lecturerID &&
        e1?.lecturerName == e2?.lecturerName &&
        e1?.lecturerPassword == e2?.lecturerPassword &&
        e1?.dateAdded == e2?.dateAdded;
  }

  @override
  int hash(LecturersRecord? e) => const ListEquality().hash(
      [e?.lecturerID, e?.lecturerName, e?.lecturerPassword, e?.dateAdded]);

  @override
  bool isValidKey(Object? o) => o is LecturersRecord;
}
