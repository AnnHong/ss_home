import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:ss_home/views/systemAdmin/streamingManagement/videoUtil.dart';

class Videosaver {
  final CollectionReference RecordingCollection = FirebaseFirestore.instance
      .collection('Recording');

  //Save the recording to Firebase
  Future<void> uploadVideoToFirebase(String localFilePath) async {
    try {
      final timestamp = DateTime.now();
      final fileName = "Recording_${timestamp.millisecondsSinceEpoch}.mp4";

      final storageRef = FirebaseStorage.instance.ref().child(
        'recording/$fileName',
      );
      final uploadTask = await storageRef.putFile(File(localFilePath));

      final downloadUrl = await storageRef.getDownloadURL();

      await RecordingCollection.add({
        'videoUrl': downloadUrl,
        'videoTimestamp': timestamp,
        'videoName': fileName,
      });

      Fluttertoast.showToast(
        msg: "Video uploaded to Firebase",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Upload failed: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> uploadImageToFirebase(Uint8List imageBytes) async {
    try {
      final timestamp = DateTime.now();
      final fileName = "Image_${timestamp.millisecondsSinceEpoch}.jpg";

      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(
        'image/$fileName',
      );
      final uploadTask = await storageRef.putData(imageBytes);

      // Get download URL
      final downloadUrl = await storageRef.getDownloadURL();

      // Save metadata to Firestore
      await FirebaseFirestore.instance.collection('Image').add({
        'imageUrl': downloadUrl,
        'imageTimestamp': timestamp,
        'imageName': fileName,
      });

      Fluttertoast.showToast(
        msg: "Image uploaded to Firebase",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Upload failed: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
