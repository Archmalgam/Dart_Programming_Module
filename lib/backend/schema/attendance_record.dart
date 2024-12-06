import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AttendanceRecord extends FirestoreRecord {
  AttendanceRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "isPresent" field.
  bool? _isPresent;
  bool get isPresent => _isPresent ?? false;
  bool hasIsPresent() => _isPresent != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _isPresent = snapshotData['isPresent'] as bool?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('Attendance')
          : FirebaseFirestore.instance.collectionGroup('Attendance');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('Attendance').doc(id);

  static Stream<AttendanceRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AttendanceRecord.fromSnapshot(s));

  static Future<AttendanceRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AttendanceRecord.fromSnapshot(s));

  static AttendanceRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AttendanceRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AttendanceRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AttendanceRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AttendanceRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AttendanceRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAttendanceRecordData({
  bool? isPresent,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'isPresent': isPresent,
    }.withoutNulls,
  );

  return firestoreData;
}

class AttendanceRecordDocumentEquality implements Equality<AttendanceRecord> {
  const AttendanceRecordDocumentEquality();

  @override
  bool equals(AttendanceRecord? e1, AttendanceRecord? e2) {
    return e1?.isPresent == e2?.isPresent;
  }

  @override
  int hash(AttendanceRecord? e) => const ListEquality().hash([e?.isPresent]);

  @override
  bool isValidKey(Object? o) => o is AttendanceRecord;
}
