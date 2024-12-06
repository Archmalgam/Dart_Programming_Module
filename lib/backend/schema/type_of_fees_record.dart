import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TypeOfFeesRecord extends FirestoreRecord {
  TypeOfFeesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  void _initializeFields() {
    _type = snapshotData['Type'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('TypeOfFees');

  static Stream<TypeOfFeesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TypeOfFeesRecord.fromSnapshot(s));

  static Future<TypeOfFeesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TypeOfFeesRecord.fromSnapshot(s));

  static TypeOfFeesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TypeOfFeesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TypeOfFeesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TypeOfFeesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TypeOfFeesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TypeOfFeesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTypeOfFeesRecordData({
  String? type,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Type': type,
    }.withoutNulls,
  );

  return firestoreData;
}

class TypeOfFeesRecordDocumentEquality implements Equality<TypeOfFeesRecord> {
  const TypeOfFeesRecordDocumentEquality();

  @override
  bool equals(TypeOfFeesRecord? e1, TypeOfFeesRecord? e2) {
    return e1?.type == e2?.type;
  }

  @override
  int hash(TypeOfFeesRecord? e) => const ListEquality().hash([e?.type]);

  @override
  bool isValidKey(Object? o) => o is TypeOfFeesRecord;
}
