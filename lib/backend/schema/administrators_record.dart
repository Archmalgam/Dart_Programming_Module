import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AdministratorsRecord extends FirestoreRecord {
  AdministratorsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "AdminID" field.
  String? _adminID;
  String get adminID => _adminID ?? '';
  bool hasAdminID() => _adminID != null;

  // "AdminName" field.
  String? _adminName;
  String get adminName => _adminName ?? '';
  bool hasAdminName() => _adminName != null;

  // "AdminPassword" field.
  String? _adminPassword;
  String get adminPassword => _adminPassword ?? '';
  bool hasAdminPassword() => _adminPassword != null;

  void _initializeFields() {
    _adminID = snapshotData['AdminID'] as String?;
    _adminName = snapshotData['AdminName'] as String?;
    _adminPassword = snapshotData['AdminPassword'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Administrators');

  static Stream<AdministratorsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AdministratorsRecord.fromSnapshot(s));

  static Future<AdministratorsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AdministratorsRecord.fromSnapshot(s));

  static AdministratorsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AdministratorsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AdministratorsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AdministratorsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AdministratorsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AdministratorsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAdministratorsRecordData({
  String? adminID,
  String? adminName,
  String? adminPassword,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'AdminID': adminID,
      'AdminName': adminName,
      'AdminPassword': adminPassword,
    }.withoutNulls,
  );

  return firestoreData;
}

class AdministratorsRecordDocumentEquality
    implements Equality<AdministratorsRecord> {
  const AdministratorsRecordDocumentEquality();

  @override
  bool equals(AdministratorsRecord? e1, AdministratorsRecord? e2) {
    return e1?.adminID == e2?.adminID &&
        e1?.adminName == e2?.adminName &&
        e1?.adminPassword == e2?.adminPassword;
  }

  @override
  int hash(AdministratorsRecord? e) =>
      const ListEquality().hash([e?.adminID, e?.adminName, e?.adminPassword]);

  @override
  bool isValidKey(Object? o) => o is AdministratorsRecord;
}
