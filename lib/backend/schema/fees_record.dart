import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FeesRecord extends FirestoreRecord {
  FeesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "FeePriceInRM" field.
  double? _feePriceInRM;
  double get feePriceInRM => _feePriceInRM ?? 0.0;
  bool hasFeePriceInRM() => _feePriceInRM != null;

  // "FeeType" field.
  String? _feeType;
  String get feeType => _feeType ?? '';
  bool hasFeeType() => _feeType != null;

  // "TimeIssued" field.
  DateTime? _timeIssued;
  DateTime? get timeIssued => _timeIssued;
  bool hasTimeIssued() => _timeIssued != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _feePriceInRM = castToType<double>(snapshotData['FeePriceInRM']);
    _feeType = snapshotData['FeeType'] as String?;
    _timeIssued = snapshotData['TimeIssued'] as DateTime?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('Fees')
          : FirebaseFirestore.instance.collectionGroup('Fees');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('Fees').doc(id);

  static Stream<FeesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FeesRecord.fromSnapshot(s));

  static Future<FeesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FeesRecord.fromSnapshot(s));

  static FeesRecord fromSnapshot(DocumentSnapshot snapshot) => FeesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FeesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FeesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FeesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FeesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFeesRecordData({
  double? feePriceInRM,
  String? feeType,
  DateTime? timeIssued,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'FeePriceInRM': feePriceInRM,
      'FeeType': feeType,
      'TimeIssued': timeIssued,
    }.withoutNulls,
  );

  return firestoreData;
}

class FeesRecordDocumentEquality implements Equality<FeesRecord> {
  const FeesRecordDocumentEquality();

  @override
  bool equals(FeesRecord? e1, FeesRecord? e2) {
    return e1?.feePriceInRM == e2?.feePriceInRM &&
        e1?.feeType == e2?.feeType &&
        e1?.timeIssued == e2?.timeIssued;
  }

  @override
  int hash(FeesRecord? e) =>
      const ListEquality().hash([e?.feePriceInRM, e?.feeType, e?.timeIssued]);

  @override
  bool isValidKey(Object? o) => o is FeesRecord;
}
