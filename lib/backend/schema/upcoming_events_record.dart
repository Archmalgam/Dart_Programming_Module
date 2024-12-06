import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UpcomingEventsRecord extends FirestoreRecord {
  UpcomingEventsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "EndDate" field.
  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  bool hasEndDate() => _endDate != null;

  // "StartDate" field.
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  bool hasStartDate() => _startDate != null;

  // "Venue" field.
  String? _venue;
  String get venue => _venue ?? '';
  bool hasVenue() => _venue != null;

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  void _initializeFields() {
    _description = snapshotData['Description'] as String?;
    _endDate = snapshotData['EndDate'] as DateTime?;
    _startDate = snapshotData['StartDate'] as DateTime?;
    _venue = snapshotData['Venue'] as String?;
    _name = snapshotData['Name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('UpcomingEvents');

  static Stream<UpcomingEventsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UpcomingEventsRecord.fromSnapshot(s));

  static Future<UpcomingEventsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UpcomingEventsRecord.fromSnapshot(s));

  static UpcomingEventsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UpcomingEventsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UpcomingEventsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UpcomingEventsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UpcomingEventsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UpcomingEventsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUpcomingEventsRecordData({
  String? description,
  DateTime? endDate,
  DateTime? startDate,
  String? venue,
  String? name,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Description': description,
      'EndDate': endDate,
      'StartDate': startDate,
      'Venue': venue,
      'Name': name,
    }.withoutNulls,
  );

  return firestoreData;
}

class UpcomingEventsRecordDocumentEquality
    implements Equality<UpcomingEventsRecord> {
  const UpcomingEventsRecordDocumentEquality();

  @override
  bool equals(UpcomingEventsRecord? e1, UpcomingEventsRecord? e2) {
    return e1?.description == e2?.description &&
        e1?.endDate == e2?.endDate &&
        e1?.startDate == e2?.startDate &&
        e1?.venue == e2?.venue &&
        e1?.name == e2?.name;
  }

  @override
  int hash(UpcomingEventsRecord? e) => const ListEquality()
      .hash([e?.description, e?.endDate, e?.startDate, e?.venue, e?.name]);

  @override
  bool isValidKey(Object? o) => o is UpcomingEventsRecord;
}
