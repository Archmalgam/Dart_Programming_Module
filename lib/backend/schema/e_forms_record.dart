import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EFormsRecord extends FirestoreRecord {
  EFormsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "lecturerid" field.
  String? _lecturerid;
  String get lecturerid => _lecturerid ?? '';
  bool hasLecturerid() => _lecturerid != null;

  // "recipient" field.
  String? _recipient;
  String get recipient => _recipient ?? '';
  bool hasRecipient() => _recipient != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  void _initializeFields() {
    _description = snapshotData['description'] as String?;
    _lecturerid = snapshotData['lecturerid'] as String?;
    _recipient = snapshotData['recipient'] as String?;
    _status = snapshotData['status'] as String?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _type = snapshotData['type'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('eForms');

  static Stream<EFormsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EFormsRecord.fromSnapshot(s));

  static Future<EFormsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EFormsRecord.fromSnapshot(s));

  static EFormsRecord fromSnapshot(DocumentSnapshot snapshot) => EFormsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EFormsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EFormsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EFormsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EFormsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEFormsRecordData({
  String? description,
  String? lecturerid,
  String? recipient,
  String? status,
  DateTime? timestamp,
  String? type,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'description': description,
      'lecturerid': lecturerid,
      'recipient': recipient,
      'status': status,
      'timestamp': timestamp,
      'type': type,
    }.withoutNulls,
  );

  return firestoreData;
}

class EFormsRecordDocumentEquality implements Equality<EFormsRecord> {
  const EFormsRecordDocumentEquality();

  @override
  bool equals(EFormsRecord? e1, EFormsRecord? e2) {
    return e1?.description == e2?.description &&
        e1?.lecturerid == e2?.lecturerid &&
        e1?.recipient == e2?.recipient &&
        e1?.status == e2?.status &&
        e1?.timestamp == e2?.timestamp &&
        e1?.type == e2?.type;
  }

  @override
  int hash(EFormsRecord? e) => const ListEquality().hash([
        e?.description,
        e?.lecturerid,
        e?.recipient,
        e?.status,
        e?.timestamp,
        e?.type
      ]);

  @override
  bool isValidKey(Object? o) => o is EFormsRecord;
}
