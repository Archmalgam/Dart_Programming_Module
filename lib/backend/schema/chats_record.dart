import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatsRecord extends FirestoreRecord {
  ChatsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Participant1" field.
  String? _participant1;
  String get participant1 => _participant1 ?? '';
  bool hasParticipant1() => _participant1 != null;

  // "Participant2" field.
  String? _participant2;
  String get participant2 => _participant2 ?? '';
  bool hasParticipant2() => _participant2 != null;

  // "LastMessageTimestamp" field.
  DateTime? _lastMessageTimestamp;
  DateTime? get lastMessageTimestamp => _lastMessageTimestamp;
  bool hasLastMessageTimestamp() => _lastMessageTimestamp != null;

  // "LastMessageSent" field.
  String? _lastMessageSent;
  String get lastMessageSent => _lastMessageSent ?? '';
  bool hasLastMessageSent() => _lastMessageSent != null;

  void _initializeFields() {
    _participant1 = snapshotData['Participant1'] as String?;
    _participant2 = snapshotData['Participant2'] as String?;
    _lastMessageTimestamp = snapshotData['LastMessageTimestamp'] as DateTime?;
    _lastMessageSent = snapshotData['LastMessageSent'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Chats');

  static Stream<ChatsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatsRecord.fromSnapshot(s));

  static Future<ChatsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatsRecord.fromSnapshot(s));

  static ChatsRecord fromSnapshot(DocumentSnapshot snapshot) => ChatsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatsRecordData({
  String? participant1,
  String? participant2,
  DateTime? lastMessageTimestamp,
  String? lastMessageSent,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Participant1': participant1,
      'Participant2': participant2,
      'LastMessageTimestamp': lastMessageTimestamp,
      'LastMessageSent': lastMessageSent,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatsRecordDocumentEquality implements Equality<ChatsRecord> {
  const ChatsRecordDocumentEquality();

  @override
  bool equals(ChatsRecord? e1, ChatsRecord? e2) {
    return e1?.participant1 == e2?.participant1 &&
        e1?.participant2 == e2?.participant2 &&
        e1?.lastMessageTimestamp == e2?.lastMessageTimestamp &&
        e1?.lastMessageSent == e2?.lastMessageSent;
  }

  @override
  int hash(ChatsRecord? e) => const ListEquality().hash([
        e?.participant1,
        e?.participant2,
        e?.lastMessageTimestamp,
        e?.lastMessageSent
      ]);

  @override
  bool isValidKey(Object? o) => o is ChatsRecord;
}
