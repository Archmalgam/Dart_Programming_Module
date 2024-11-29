import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RoomAvailabilityPage extends StatefulWidget {
  @override
  _RoomAvailabilityPageState createState() => _RoomAvailabilityPageState();
}

class _RoomAvailabilityPageState extends State<RoomAvailabilityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Availability'),
        backgroundColor: Color(0xFFd5e7ff),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Rooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading rooms.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No rooms available.'));
          }

          final rooms = snapshot.data!.docs;

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              final roomData = room.data() as Map<String, dynamic>?;

              if (roomData == null) {
                return SizedBox.shrink();
              }

              final roomName = roomData['roomName'] ?? 'Room ${room.id}';

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Rooms')
                    .doc(room.id)
                    .collection('Booking detail')
                    .get(),
                builder: (context, bookingSnapshot) {
                  if (bookingSnapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (bookingSnapshot.hasError) {
                    return SizedBox(
                      height: 100,
                      child: Center(child: Text('Error loading booking details.')),
                    );
                  }

                  final bookings = bookingSnapshot.data?.docs ?? [];
                  bool isOccupied = false;
                  final now = DateTime.now().add(Duration(hours: 8)); // Adjust to UTC+8

                  for (var booking in bookings) {
                    final bookingData = booking.data() as Map<String, dynamic>;
                    final startDateTime = bookingData['startDateTime'] != null
                        ? (bookingData['startDateTime'] as Timestamp).toDate().toUtc()
                        : null;
                    final endDateTime = bookingData['endDateTime'] != null
                        ? (bookingData['endDateTime'] as Timestamp).toDate().toUtc()
                        : null;

                    // Debugging
                    print('Booking: ${booking.id}');
                    print('Start Time (UTC): $startDateTime');
                    print('End Time (UTC): $endDateTime');
                    print('Current Time (UTC): $now');

                    if (startDateTime != null &&
                        endDateTime != null &&
                        now.isAfter(startDateTime) &&
                        now.isBefore(endDateTime)) {
                      isOccupied = true;
                      break; // Exit loop if room is occupied
                    }
                  }

                  // Update Firestore status dynamically
                  _updateRoomStatus(room.id, isOccupied);

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        roomName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        isOccupied ? 'Occupied' : 'Free',
                        style: TextStyle(
                          color: isOccupied ? Colors.red : Colors.green,
                          fontSize: 14,
                        ),
                      ),
                      // All rooms are now clickable
                      onTap: () {
                        _showRoomDetails(context, roomName, bookings);
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Function to update room status in Firestore
  void _updateRoomStatus(String roomId, bool isOccupied) async {
    final roomDoc = FirebaseFirestore.instance.collection('Rooms').doc(roomId);

    try {
      final snapshot = await roomDoc.get();
      final currentStatus = snapshot['status'];

      // Debugging
      print('Room ID: $roomId');
      print('Current Status in Firestore: $currentStatus');
      print('New Status: ${isOccupied ? 'occupied' : 'free'}');

      // Update Firestore only if the status has changed
      if (isOccupied && currentStatus != 'occupied') {
        await roomDoc.update({'status': 'occupied'});
        print('Room $roomId updated to Occupied');
      } else if (!isOccupied && currentStatus != 'free') {
        await roomDoc.update({'status': 'free'});
        print('Room $roomId updated to Free');
      }
    } catch (e) {
      print('Error updating room status: $e');
    }
  }


  void _showRoomDetails(BuildContext context, String roomName, List<QueryDocumentSnapshot> bookings) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text(
            "Room Details - $roomName",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
          ),
          content: bookings.isEmpty
              ? Text("No bookings available.")
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bookings.map((booking) {
                    final data = booking.data() as Map<String, dynamic>;
                    final lecturerName = data['lecturerName'] ?? 'Unknown';
                    final startDateTime = data['startDateTime'] != null
                        ? (data['startDateTime'] as Timestamp).toDate()
                        : null;
                    final endDateTime = data['endDateTime'] != null
                        ? (data['endDateTime'] as Timestamp).toDate()
                        : null;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "Lecturer: $lecturerName\nStart: ${startDateTime != null ? DateFormat.yMMMd().add_jm().format(startDateTime) : 'Unknown'}\nEnd: ${endDateTime != null ? DateFormat.yMMMd().add_jm().format(endDateTime) : 'Unknown'}",
                      ),
                    );
                  }).toList(),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

  Widget _buildDialogInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: Colors.black87),
          children: [
            TextSpan(
              text: "$label: ",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
