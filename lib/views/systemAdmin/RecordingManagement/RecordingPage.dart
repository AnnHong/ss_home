import 'package:flutter/material.dart';
import 'package:ss_home/views/systemAdmin/RecordingManagement/imageList.dart';
import 'package:ss_home/views/systemAdmin/RecordingManagement/recordingList.dart';

class RecordingAndCapturePage extends StatefulWidget {
  const RecordingAndCapturePage({super.key});

  @override
  State<RecordingAndCapturePage> createState() =>
      _RecordingAndCapturePageState();
}

class _RecordingAndCapturePageState extends State<RecordingAndCapturePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom tab buttons (instead of AppBar)
        Container(
          color: Colors.grey[200],
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(icon: Icon(Icons.videocam), text: 'Recordings'),
              Tab(icon: Icon(Icons.camera_alt), text: 'Images'),
            ],
          ),
        ),
        // Tab content area
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [VideoList(), ImageList()],
          ),
        ),
      ],
    );
  }
}
