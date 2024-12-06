import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AvailableIntakesRecord extends FirestoreRecord {
  AvailableIntakesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "IntakeNumber" field.
  String? _intakeNumber;
  String get intakeNumber => _intakeNumber ?? '';
  bool hasIntakeNumber() => _intakeNumber != null;

  void _initializeFields() {
    _intakeNumber = snapshotData['IntakeNumber'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('AvailableIntakes');

  static Stream<AvailableIntakesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AvailableIntakesRecord.fromSnapshot(s));

  static Future<AvailableIntakesRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => AvailableIntakesRecord.fromSnapshot(s));

  static AvailableIntakesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AvailableIntakesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AvailableIntakesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AvailableIntakesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AvailableIntakesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AvailableIntakesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAvailableIntakesRecordData({
  String? intakeNumber,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'IntakeNumber': intakeNumber,
    }.withoutNulls,
  );

  return firestoreData;
}

class AvailableIntakesRecordDocumentEquality
    implements Equality<AvailableIntakesRecord> {
  const AvailableIntakesRecordDocumentEquality();

  @override
  bool equals(AvailableIntakesRecord? e1, AvailableIntakesRecord? e2) {
    return e1?.intakeNumber == e2?.intakeNumber;
  }

  @override
  int hash(AvailableIntakesRecord? e) =>
      const ListEquality().hash([e?.intakeNumber]);

  @override
  bool isValidKey(Object? o) => o is AvailableIntakesRecord;
}
