import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TimetableRecord extends FirestoreRecord {
  TimetableRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "EndDateTime" field.
  DateTime? _endDateTime;
  DateTime? get endDateTime => _endDateTime;
  bool hasEndDateTime() => _endDateTime != null;

  // "Intake" field.
  String? _intake;
  String get intake => _intake ?? '';
  bool hasIntake() => _intake != null;

  // "LecturerId" field.
  String? _lecturerId;
  String get lecturerId => _lecturerId ?? '';
  bool hasLecturerId() => _lecturerId != null;

  // "Module" field.
  String? _module;
  String get module => _module ?? '';
  bool hasModule() => _module != null;

  // "Room" field.
  String? _room;
  String get room => _room ?? '';
  bool hasRoom() => _room != null;

  // "StartDateTime" field.
  DateTime? _startDateTime;
  DateTime? get startDateTime => _startDateTime;
  bool hasStartDateTime() => _startDateTime != null;

  // "Topic" field.
  String? _topic;
  String get topic => _topic ?? '';
  bool hasTopic() => _topic != null;

  void _initializeFields() {
    _endDateTime = snapshotData['EndDateTime'] as DateTime?;
    _intake = snapshotData['Intake'] as String?;
    _lecturerId = snapshotData['LecturerId'] as String?;
    _module = snapshotData['Module'] as String?;
    _room = snapshotData['Room'] as String?;
    _startDateTime = snapshotData['StartDateTime'] as DateTime?;
    _topic = snapshotData['Topic'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Timetable');

  static Stream<TimetableRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TimetableRecord.fromSnapshot(s));

  static Future<TimetableRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TimetableRecord.fromSnapshot(s));

  static TimetableRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TimetableRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TimetableRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TimetableRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TimetableRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TimetableRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTimetableRecordData({
  DateTime? endDateTime,
  String? intake,
  String? lecturerId,
  String? module,
  String? room,
  DateTime? startDateTime,
  String? topic,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'EndDateTime': endDateTime,
      'Intake': intake,
      'LecturerId': lecturerId,
      'Module': module,
      'Room': room,
      'StartDateTime': startDateTime,
      'Topic': topic,
    }.withoutNulls,
  );

  return firestoreData;
}

class TimetableRecordDocumentEquality implements Equality<TimetableRecord> {
  const TimetableRecordDocumentEquality();

  @override
  bool equals(TimetableRecord? e1, TimetableRecord? e2) {
    return e1?.endDateTime == e2?.endDateTime &&
        e1?.intake == e2?.intake &&
        e1?.lecturerId == e2?.lecturerId &&
        e1?.module == e2?.module &&
        e1?.room == e2?.room &&
        e1?.startDateTime == e2?.startDateTime &&
        e1?.topic == e2?.topic;
  }

  @override
  int hash(TimetableRecord? e) => const ListEquality().hash([
        e?.endDateTime,
        e?.intake,
        e?.lecturerId,
        e?.module,
        e?.room,
        e?.startDateTime,
        e?.topic
      ]);

  @override
  bool isValidKey(Object? o) => o is TimetableRecord;
}
