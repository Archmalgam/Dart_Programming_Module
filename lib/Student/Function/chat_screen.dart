import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String lecturerId;
  final String lecturerName;
  final String studentId;

  ChatScreen({
    required this.lecturerId,
    required this.lecturerName,
    required this.studentId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = {
      "senderId": widget.studentId,
      "message": _messageController.text.trim(),
      "timestamp": FieldValue.serverTimestamp(),
    };

    String chatRoomId = '${widget.lecturerId}_${widget.studentId}';

    // Save message in Firestore under the chat room
    await _firestore
        .collection("Chats")
        .doc(chatRoomId)
        .collection("messages")
        .add(message);

    // Clear the message input field
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    String chatRoomId = '${widget.lecturerId}_${widget.studentId}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.lecturerName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("Chats")
                  .doc(chatRoomId)
                  .collection("messages")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message['senderId'] == widget.studentId;

                    return ListTile(
                      title: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(message['message']),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
