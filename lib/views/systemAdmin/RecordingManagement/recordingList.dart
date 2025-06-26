import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ss_home/views/systemAdmin/RecordingManagement/player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VideoList extends StatelessWidget {
  const VideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('Recording')
              .orderBy('videoTimestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No recordings found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final videos = snapshot.data!.docs;
        final count = videos.length;
        // UPDATED: New title format to match the notification page
        final titleText = "Recordings ($count)";

        // UPDATED: The layout now includes the new title style and a divider.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // UPDATED: Title style now matches the NotificationPage.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                titleText,
                style: const TextStyle(
                  fontSize: 24, // Using the same larger font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // NEW: Added a Divider for consistency.
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(thickness: 1.0),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8.0),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final videoDoc = videos[index];
                  // The VideoCard handles the display of each item. No changes needed here.
                  return VideoCard(videoDoc: videoDoc);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// NO CHANGES ARE NEEDED for the VideoCard widget. It stays the same.
class VideoCard extends StatelessWidget {
  final QueryDocumentSnapshot videoDoc;

  const VideoCard({super.key, required this.videoDoc});

  Future<String?> _generateThumbnail(String videoUrl) async {
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 150,
      quality: 50,
    );
    return thumbnailPath;
  }

  void _deleteVideo(BuildContext context, String docId, String videoUrl) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Recording'),
            content: const Text(
              'Are you sure you want to delete this recording?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('Recording')
            .doc(docId)
            .delete();

        final storageRef = FirebaseStorage.instance.refFromURL(videoUrl);
        await storageRef.delete();

        if (context.mounted) {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('Success'),
                  content: const Text('Recording deleted successfully.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete recording: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoData = videoDoc.data() as Map<String, dynamic>;
    final String videoUrl = videoData['videoUrl'] ?? '';
    final String videoName = videoData['videoName'] ?? 'Unnamed Video';
    final Timestamp? videotimestamp = videoData['videoTimestamp'];
    final String formattedDate =
        videotimestamp != null
            ? DateFormat('dd MMM yyyy, hh:mm a').format(videotimestamp.toDate())
            : 'No date';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (videoUrl.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => VideoPlayerScreen(
                          videoUrl: videoUrl,
                          videoName: videoName,
                        ),
                  ),
                );
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                FutureBuilder<String?>(
                  future: _generateThumbnail(videoUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data == null) {
                      return AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                          child: const Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      );
                    }
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.file(
                        File(snapshot.data!),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        videoName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _deleteVideo(context, videoDoc.id, videoUrl),
                  tooltip: 'Delete Recording',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
