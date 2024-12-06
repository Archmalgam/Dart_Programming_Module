import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';

Future<void> pickAndUploadFile(BuildContext context, Map<String, dynamic> classData) async {
  // Lock to prevent multiple dialog openings
  bool isPickingFile = false;

  // Check if a file picker is already active
  if (isPickingFile) return;

  isPickingFile = true; // Lock the file picker

  try {
    // Pick a file using file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name; // Retrieve the name of the selected file

      // Read the file as bytes
      File file = File(filePath);
      List<int> fileBytes = await file.readAsBytes();
      
      // Convert file to Base64 string
      String base64String = base64Encode(fileBytes);

      // Generate a unique document ID automatically using Firestore
      String documentId = FirebaseFirestore.instance.collection('FileUploads').doc().id;

      // Extract predefined values from classData
      String lecturerId = classData['LecturerId'];
      String module = classData['Module'];
      String intake = classData['Intake'];

      // Upload file data to Firestore as Base64 with additional metadata
      await FirebaseFirestore.instance.collection('FileUploads').doc(documentId).set({
        'fileData': base64String, // Store the file data in Base64 encoding
        'fileName': fileName, // Store the file name
        'lecturerId': lecturerId,
        'module': module,
        'intake': intake,
        'uploadedAt': Timestamp.now(),
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File uploaded successfully!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No file selected")));
    }
  } catch (e) {
    print("File picking failed: $e");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("File upload error: $e")));
  } finally {
    isPickingFile = false; // Release the lock
  }
}
