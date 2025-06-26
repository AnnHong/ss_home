import 'package:flutter/material.dart';
import 'package:ss_home/util/widgetDesign.dart';
import 'package:ss_home/views/systemAdmin/RecordingManagement/RecordingPage.dart';
import 'package:ss_home/views/systemAdmin/alertManagement/AlertNotificationPage.dart';
import 'package:ss_home/views/systemAdmin/manageStaff.dart';
import 'package:ss_home/views/systemAdmin/streamingManagement/Camera2LiveStreaming.dart';
import 'package:ss_home/views/systemAdmin/streamingManagement/Camera3LiveStreaming.dart';
import 'package:ss_home/views/systemAdmin/streamingManagement/Camera1StreamingPage.dart';
import 'package:ss_home/views/systemAdmin/RecordingManagement/recordingList.dart';
import 'package:ss_home/util/showDialog.dart';
import 'package:ss_home/util/callFunction.dart';
import 'package:ss_home/views/systemAdmin/streamingManagement/streamingWidgetHomePage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SystemAdminHomepage extends StatefulWidget {
  const SystemAdminHomepage({super.key});

  @override
  State<SystemAdminHomepage> createState() => _SystemAdminHomepageState();
}

class _SystemAdminHomepageState extends State<SystemAdminHomepage> {
  int currentPageIndex = 0;
  bool isCamera1ButtonEnabled = true;
  bool isCamera2ButtonEnabled = true;
  bool isCamera3ButtonEnabled = true;
  int selectedCameraIndex = 1;

  // WebSocket channels for each camera
  // late final channel1 =
  //   IOWebSocketChannel.connect('ws://192.168.61.110:8888');

  //   late final channel2 = IOWebSocketChannel.connect('ws://192.168.61.110:8889');
  //   late final channel3 = IOWebSocketChannel.connect('ws://192.168.61.110:8890');
  late final Map<int, WebSocketChannel> channels = {
    1: IOWebSocketChannel.connect('ws://192.168.61.110:8888'),
    2: IOWebSocketChannel.connect('ws://192.168.61.110:8889'),
    3: IOWebSocketChannel.connect('ws://192.168.61.110:8890'),
  };

  // Create an instance of WidgetDesign to access its widget building methods
  final WidgetDesign _widgetDesign = WidgetDesign();

  void dispose() {
    // Close all WebSocket connections when the widget is disposed
    for (var channel in channels.values) {
      channel.sink.close();
    }
    super.dispose();
  }

  void _toggleCamera1Button() {
    setState(() {
      isCamera1ButtonEnabled = !isCamera1ButtonEnabled;
    });
  }

  /// Function to toggle the enabled status of Camera 2's button.
  void _toggleCamera2Button() {
    setState(() {
      isCamera2ButtonEnabled = !isCamera2ButtonEnabled;
    });
  }

  void _toggleCamera3Button() {
    setState(() {
      isCamera3ButtonEnabled = !isCamera3ButtonEnabled;
    });
  }

  /// Function to handle the click for Camera 1's primary button.
  void _handleCamera1Click() {
    if (isCamera1ButtonEnabled) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => Camera1StreamingPage(
                channel: IOWebSocketChannel.connect
                // ('ws://35.197.135.31:65080'),
                ('ws://192.168.61.110:8888'),
              ),
        ),
      );
    }
  }

  /// Function to handle the click for Camera 2's primary button.
  void _handleCamera2Click() {
    if (isCamera2ButtonEnabled) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => Camera2StreamingPage(
                channel: IOWebSocketChannel.connect('ws://192.168.61.110:8889'),
              ),
        ),
      );
    }
  }

  void _handleCamera3Click() {
    if (isCamera3ButtonEnabled) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => Camera3StreamingPage(
                channel: IOWebSocketChannel.connect('ws://192.168.61.110:8890'),
              ),
        ),
      );
    }
  }

  void _showFamilyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Family Members'),
            content: SizedBox(
              width: double.maxFinite,
              child: FamilyMemberList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showStaffDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Staff Info'),
            content: SizedBox(width: double.maxFinite, child: StaffList()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showCallingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Emergency Service'),
            content: SizedBox(width: double.maxFinite, child: EmergencyList()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF448AFF),
        title: const Text("SS Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent),
            onPressed: () {
              _showStaffDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.emergency),
            onPressed: () {
              _showCallingDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              DialogHelper.showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_camera_back),
            label: 'Recording/Capture',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_sharp),
            label: 'Notifications',
          ),
        ],
      ),
      body: Stack(
        children: [
          <Widget>[
            // Home page
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showFamilyDialog(context),
                          icon: const Icon(
                            Icons.family_restroom,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Emergency Call",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            DialogHelper.showPasswordDialog(context);
                          },
                          icon: const Icon(
                            Icons.manage_accounts,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Manage staff",
                            style: TextStyle(color: Colors.white),
                          ),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth:
                            380.0, // Set a max width (e.g., 450px) for the content area
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Determine number of columns based on screen width
                          int crossAxisCount =
                              constraints.maxWidth > 600
                                  ? 2
                                  : 1; // Adjusted breakpoint
                          return GridView.count(
                            shrinkWrap:
                                true, // Important for GridView inside Column
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 15.0,
                            mainAxisSpacing: 15.0,
                            childAspectRatio:
                                1.0, // Slightly adjusted aspect ratio
                            children: <Widget>[
                              _widgetDesign.buildCameraContainer(
                                context,
                                'Camera 1',
                                isCamera1ButtonEnabled,
                                _handleCamera1Click,
                                _toggleCamera1Button,
                                channel: IOWebSocketChannel.connect(
                                  'ws://192.168.61.110:8888',
                                ),
                              ),
                              // Camera 2 Container, built using WidgetDesign instance
                              _widgetDesign.buildCameraContainer(
                                context,
                                'Camera 2',
                                isCamera2ButtonEnabled,
                                _handleCamera2Click,
                                _toggleCamera2Button,
                                channel: IOWebSocketChannel.connect(
                                  'ws://192.168.61.110:8889',
                                ),
                              ),
                              _widgetDesign.buildCameraContainer(
                                context,
                                'Camera 3',
                                isCamera3ButtonEnabled,
                                _handleCamera3Click,
                                _toggleCamera3Button,
                                channel: IOWebSocketChannel.connect(
                                  'ws://192.168.61.110:8890',
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 10.0),
                ],
              ),
            ),

            // Recording page
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: RecordingAndCapturePage(),
            ),
            // Notifications page
            Padding(padding: EdgeInsets.all(8.0), child: NotificationPage()),
          ][currentPageIndex],
        ],
      ),
    );
  }
}
