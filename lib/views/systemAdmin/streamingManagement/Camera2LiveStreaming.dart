// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ffmpeg_kit_flutter_new/return_code.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gallery_saver_plus/gallery_saver.dart';
// import 'package:gesture_zoom_box/gesture_zoom_box.dart';
// import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
// import 'package:ss_home/views/systemAdmin/streamingManagement/BlinkingTimer.dart';
// import 'package:ss_home/util/Videosaver.dart';
// import 'package:ss_home/views/systemAdmin/streamingManagement/videoUtil.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/log.dart';
// import 'package:ffmpeg_kit_flutter_new/session.dart';
// import 'package:ffmpeg_kit_flutter_new/statistics.dart';

// class Camera2StreamingPage extends StatefulWidget {
//   final WebSocketChannel channel;
//   const Camera2StreamingPage({super.key, required this.channel});

//   @override
//   State<Camera2StreamingPage> createState() => _Camera2StreamingPageState();
// }

// class _Camera2StreamingPageState extends State<Camera2StreamingPage> {
//   //video size = VGA (640px x 480px)
//   final videoWidth = 640;
//   final videoHeight = 480;

//   late bool isLandscape;
//   //feed the camera image byte
//   Uint8List? currentImageBytes;
//   var _globalKey = new GlobalKey();

//   late String _timeString;
//   //recording part
//   late Timer _timer;
//   late bool isRecording;
//   final FFmpegKit flutterFFmeg = FFmpegKit();
//   late int frameNum;
//   late ProgressDialog pr;

//   @override
//   void initState() {
//     super.initState();
//     isLandscape = false;
//     //recording
//     isRecording = false;

//     // Initialize currentTime and start timer
//     _timeString = _formatDateTime(DateTime.now());
//     _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
//     _requestPermission();
//     //recording ffmeg
//     frameNum = 0;
//     VideoUtil.workPath = 'images';
//     VideoUtil.getAppTempDirectory();
//     pr = ProgressDialog(
//       context,
//       type: ProgressDialogType.normal,
//       isDismissible: false,
//       showLogs: false,
//     );
//     pr.style(
//       message: 'Saving video ...',
//       borderRadius: 10,
//       backgroundColor: Colors.black,
//       progressWidget: CircularProgressIndicator(),
//       elevation: 10,
//       insetAnimCurve: Curves.easeInOut,
//       messageTextStyle: TextStyle(
//         color: Colors.white70,
//         fontSize: 17,
//         fontWeight: FontWeight.w300,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     widget.channel.sink.close();
//     // Safely cancel the _timer if it's active
//     if (_timer.isActive) {
//       _timer.cancel();
//     }
//     super.dispose();
//   }

//   Future<void> _requestPermission() async {
//     await Permission.storage.request();
//   }

//   String _formatDateTime(DateTime dateTime) {
//     return DateFormat("yyyy/MM/dd hh:mm:ss aaa").format(dateTime);
//   }

//   void _getTime() {
//     final DateTime now = DateTime.now();
//     setState(() {
//       _timeString = _formatDateTime(now);
//     });
//   }

//   videoRecording() {
//     setState(() {
//       isRecording = !isRecording;
//       if (!isRecording && frameNum > 0) {
//         frameNum = 0;
//         makeVideoWithFFMpeg();
//       }
//     });
//   }

//   Future<void> saveCurrentImage(Uint8List imageBytes) async {
//     try {
//       final result = await ImageGallerySaverPlus.saveImage(
//         imageBytes,
//         quality: 100,
//         name: "esp32_capture_${DateTime.now().millisecondsSinceEpoch}",
//       );

//       bool isSuccess = false;
//       if (result is Map) {
//         isSuccess = result['isSuccess'] ?? false;
//       } else if (result is bool) {
//         isSuccess = result;
//       }

//       Fluttertoast.showToast(
//         msg: isSuccess ? "Image saved to gallery" : "Failed to save image",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         backgroundColor: isSuccess ? Colors.green : Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error saving image: $e",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     }
//   }

//   Widget _getFab() {
//     return SpeedDial(
//       overlayOpacity: 0.1,
//       animatedIcon: AnimatedIcons.menu_home,
//       animatedIconTheme: IconThemeData(size: 22),
//       curve: Curves.bounceIn,
//       children: [
//         SpeedDialChild(
//           child: Icon(Icons.photo_camera),
//           label: "Capture Image",
//           onTap: () {
//             if (currentImageBytes != null) {
//               saveCurrentImage(currentImageBytes!);
//               Videosaver().uploadImageToFirebase(currentImageBytes!);
//             } else {
//               Fluttertoast.showToast(
//                 msg: "No image data to save",
//                 toastLength: Toast.LENGTH_SHORT,
//                 gravity: ToastGravity.CENTER,
//                 backgroundColor: Colors.red,
//                 textColor: Colors.white,
//                 fontSize: 16.0,
//               );
//             }
//           },
//         ),
//         SpeedDialChild(
//           child: isRecording ? Icon(Icons.stop) : Icon(Icons.videocam),
//           label: isRecording ? "Stop Recording" : "Start Recording",
//           onTap: () {
//             videoRecording();
//           },
//         ),
//       ],
//     );
//   }

//   Future<int> execute(String command) async {
//     final session = await FFmpegKit.execute(command);
//     final returnCode = await session.getReturnCode();

//     if (ReturnCode.isSuccess(returnCode)) {
//       print('FFmpeg command executed successfully');
//       return 0; // success code
//     } else {
//       print('FFmpeg command failed with return code $returnCode');
//       return 1; // failure code
//     }
//   }

//   makeVideoWithFFMpeg() {
//     pr.show();
//     String tempVideofileName = "${DateTime.now().millisecondsSinceEpoch}.mp4";
//     execute(
//       VideoUtil.generateEncodeVideoScript("mpeg4", tempVideofileName),
//     ).then((rc) {
//       pr.hide();
//       if (rc == 0) {
//         print("Video complete");

//         String outputPath = "${VideoUtil.appTempDir}/$tempVideofileName";
//         _saveVideo(outputPath);
//       }
//     });
//   }

//   _saveVideo(String path) async {
//     final result = await GallerySaver.saveVideo(path);
//     print("Video Save result : $result");

//     Fluttertoast.showToast(
//       msg: (result ?? false) ? "Video Saved" : "Video Failure!",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       backgroundColor: (result ?? false) ? Colors.green : Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );

//     if (result == true) {
//       await Videosaver().uploadVideoToFirebase(
//         path,
//       ); // Upload video after saving locally
//     }

//     VideoUtil.deleteTempDirectory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Camera 2')),
//       backgroundColor: Colors.white,
//       body: OrientationBuilder(
//         builder: (context, orientation) {
//           isLandscape = (orientation == Orientation.landscape);

//           return Container(
//             child: StreamBuilder(
//               stream: widget.channel.stream,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData && snapshot.data != null) {
//                   try {
//                     currentImageBytes = snapshot.data;
//                     if (isRecording) {
//                       VideoUtil.saveImageFileToDirectory(
//                         snapshot.data,
//                         'image_$frameNum.jpg',
//                       );
//                       frameNum++;
//                     }

//                     return Column(
//                       mainAxisAlignment:
//                           isLandscape
//                               ? MainAxisAlignment.center
//                               : MainAxisAlignment.start,
//                       children: <Widget>[
//                         Expanded(
//                           flex: isLandscape ? 1 : 5,
//                           child: Center(
//                             // Added Center here to explicitly center the video in landscape
//                             child: AspectRatio(
//                               aspectRatio: videoWidth / videoHeight,
//                               child: Stack(
//                                 children: <Widget>[
//                                   RepaintBoundary(
//                                     key: _globalKey,
//                                     child: GestureZoomBox(
//                                       maxScale: 5.0,
//                                       doubleTapScale: 2.0,
//                                       duration: const Duration(
//                                         milliseconds: 200,
//                                       ),
//                                       child: Image.memory(
//                                         snapshot.data,
//                                         gaplessPlayback: true,
//                                         fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned.fill(
//                                     child: Align(
//                                       alignment: Alignment.topCenter,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: <Widget>[
//                                             Text(
//                                               "Camera 2",
//                                               style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white,
//                                                 shadows: [
//                                                   Shadow(
//                                                     blurRadius: 3.0,
//                                                     color: Colors.white,
//                                                     offset: Offset(1.0, 1.0),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(height: 4),
//                                             Text(
//                                               "Live | $_timeString",
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w300,
//                                                 color: Colors.white,
//                                                 shadows: [
//                                                   Shadow(
//                                                     blurRadius: 3.0,
//                                                     color: Colors.black,
//                                                     offset: Offset(1.0, 1.0),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(height: 4),
//                                             isRecording
//                                                 ? BlinkingTimers()
//                                                 : Container(),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         if (!isLandscape)
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                               color: Colors.white,
//                               width: MediaQuery.of(context).size.width,
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                 ),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: <Widget>[
//                                     IconButton(
//                                       onPressed: () {
//                                         videoRecording();
//                                       },
//                                       icon: Icon(
//                                         isRecording
//                                             ? Icons.stop
//                                             : Icons.videocam,
//                                       ),
//                                       iconSize: 24,
//                                     ),
//                                     IconButton(
//                                       onPressed: () {
//                                         if (currentImageBytes != null) {
//                                           saveCurrentImage(currentImageBytes!);
//                                           Videosaver().uploadImageToFirebase(
//                                             currentImageBytes!,
//                                           );
//                                         } else {
//                                           Fluttertoast.showToast(
//                                             msg: "No image data to save",
//                                             toastLength: Toast.LENGTH_SHORT,
//                                             gravity: ToastGravity.CENTER,
//                                             backgroundColor: Colors.red,
//                                             textColor: Colors.white,
//                                             fontSize: 16.0,
//                                           );
//                                         }
//                                       },
//                                       icon: Icon(Icons.camera_alt),
//                                       iconSize: 24,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     );
//                   } catch (e) {
//                     print("Error rendering image: $e");
//                     return const Text(
//                       'Error rendering image.',
//                       style: TextStyle(color: Colors.red),
//                     );
//                   }
//                 } else {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Colors.grey.shade400,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           snapshot.connectionState == ConnectionState.waiting
//                               ? "Connecting to camera..."
//                               : "No connection. Please check camera or network.",
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w300,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: isLandscape ? _getFab() : null,
//     );
//   }
// }
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:ss_home/views/systemAdmin/streamingManagement/BlinkingTimer.dart';
import 'package:ss_home/util/Videosaver.dart';
import 'package:ss_home/views/systemAdmin/streamingManagement/videoUtil.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/log.dart';
import 'package:ffmpeg_kit_flutter_new/session.dart';
import 'package:ffmpeg_kit_flutter_new/statistics.dart';

class Camera2StreamingPage extends StatefulWidget {
  final WebSocketChannel channel;
  const Camera2StreamingPage({super.key, required this.channel});

  @override
  State<Camera2StreamingPage> createState() => _Camera2StreamingPageState();
}

class _Camera2StreamingPageState extends State<Camera2StreamingPage> {
  //video size = VGA (640px x 480px)
  final videoWidth = 640;
  final videoHeight = 480;
  double newVideoWidth = 640;
  double newVideoHeight = 480;

  late bool isLandscape;
  //feed the camera image byte
  Uint8List? currentImageBytes;
  var _globalKey = new GlobalKey();

  late String _timeString;
  //recording part
  late Timer _timer;
  late bool isRecording;
  final FFmpegKit flutterFFmeg = FFmpegKit();
  late int frameNum;
  late ProgressDialog pr;
  @override
  void initState() {
    super.initState();
    isLandscape = false;
    //recording
    isRecording = false;

    // Initialize currentTime and start timer
    _timeString = _formatDateTime(DateTime.now());
    // Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _requestPermission();
    //recording ffmeg
    frameNum = 0;
    VideoUtil.workPath = 'images';
    VideoUtil.getAppTempDirectory();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.normal,
      isDismissible: false,
      showLogs: false,
    );
    pr.style(
      message: 'Saving video ...',
      borderRadius: 10,
      backgroundColor: Colors.black,
      progressWidget: CircularProgressIndicator(),
      elevation: 10,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
        color: Colors.white70,
        fontSize: 17,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    // _timer.cancel();
    // Safely cancel the _timer if it's active
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  Future<void> _requestPermission() async {
    await Permission.storage.request();
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat("yyyy/MM/dd hh:mm:ss aaa").format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = _formatDateTime(now);
    });
  }

  videoRecording() {
    isRecording = !isRecording;
    if (!isRecording && frameNum > 0) {
      frameNum = 0;
      makeVideoWithFFMpeg();
    }
  }

  //function
  Future<void> saveCurrentImage(Uint8List imageBytes) async {
    try {
      final result = await ImageGallerySaverPlus.saveImage(
        imageBytes,
        quality: 100,
        name: "Image_${DateTime.now().millisecondsSinceEpoch}",
      );

      bool isSuccess = false;
      if (result is Map) {
        isSuccess = result['isSuccess'] ?? false;
      } else if (result is bool) {
        isSuccess = result;
      }

      Fluttertoast.showToast(
        msg: isSuccess ? "Image saved to gallery" : "Failed to save image",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error saving image: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  //function
  Widget _getFab() {
    return SpeedDial(
      overlayOpacity: 0.1,
      animatedIcon: AnimatedIcons.menu_home,
      animatedIconTheme: IconThemeData(size: 22),
      visible: isLandscape,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.photo_camera),
          onTap: () {
            if (currentImageBytes != null) {
              saveCurrentImage(currentImageBytes!);
            } else {
              Fluttertoast.showToast(
                msg: "No image data to save",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          },
        ),
        SpeedDialChild(
          //recording feature
          child: isRecording ? Icon(Icons.stop) : Icon(Icons.videocam),
          onTap: () {
            videoRecording();
          },
        ),
      ],
    );
  }

  Future<int> execute(String command) async {
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      print('FFmpeg command executed successfully');
      return 0; // success code
    } else {
      print('FFmpeg command failed with return code $returnCode');
      return 1; // failure code
    }
  }

  makeVideoWithFFMpeg() {
    pr.show();
    String tempVideofileName = "${DateTime.now().millisecondsSinceEpoch}.mp4";
    execute(
      VideoUtil.generateEncodeVideoScript("mpeg4", tempVideofileName),
    ).then((rc) {
      pr.hide();
      if (rc == 0) {
        print("Video complete");

        String outputPath = "${VideoUtil.appTempDir}/$tempVideofileName";
        _saveVideo(outputPath);
      }
    });
  }

  _saveVideo(String path) async {
    final result = await GallerySaver.saveVideo(path);
    print("Video Save result : $result");

    Fluttertoast.showToast(
      msg: (result ?? false) ? "Video Saved" : "Video Failure!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: (result ?? false) ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    if (result == true) {
      await Videosaver().uploadVideoToFirebase(
        path,
      ); // Upload video after saving locally
    }

    VideoUtil.deleteTempDirectory();
  }

  //UI Design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Camera 1')),
      // backgroundColor: Colors.white,
      body: OrientationBuilder(
        builder: (context, orientation) {
          var screenWidth = MediaQuery.of(context).size.width;
          var screenHeight = MediaQuery.of(context).size.height;

          if (orientation == Orientation.portrait) {
            //screenWidth <screeneight
            //can be change to landscape
            isLandscape = false;
            newVideoWidth = screenWidth;
            // > videoWidth ? videoWidth.toDouble() : screenWidth;
            newVideoHeight =
                (videoHeight * newVideoWidth / videoWidth).toDouble();
          } else {
            isLandscape = true;
            newVideoHeight = screenHeight;
            // > videoHeight
            //     ? videoHeight.toDouble()
            //     : screenHeight;
            newVideoWidth =
                (videoWidth * newVideoHeight / videoHeight).toDouble();
          }

          return Container(
            child: StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  try {
                    currentImageBytes = snapshot.data;
                    if (isRecording) {
                      VideoUtil.saveImageFileToDirectory(
                        snapshot.data,
                        'image_$frameNum.jpg',
                      );
                      frameNum++;
                    }

                    return Column(
                      children: <Widget>[
                        SizedBox(height: isLandscape ? 0 : 30),
                        Stack(
                          children: <Widget>[
                            RepaintBoundary(
                              key: _globalKey,
                              child: GestureZoomBox(
                                maxScale: 5.0,
                                doubleTapScale: 2.0,
                                duration: const Duration(milliseconds: 200),
                                child: Image.memory(
                                  snapshot.data,
                                  gaplessPlayback: true,
                                  width: newVideoWidth,
                                  height: newVideoHeight,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 16),

                                    Text(
                                      "Camera 2",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Live | $_timeString",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color:
                                            Colors
                                                .white, // Set font color to white
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    isRecording
                                        ? BlinkingTimers()
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Row for icon alert capture record
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      videoRecording();
                                    },
                                    icon: Icon(
                                      isRecording ? Icons.stop : Icons.videocam,
                                    ),
                                    iconSize: 24,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // if (snapshot.hasData &&
                                      //     snapshot.data != null) {
                                      //   saveCurrentImage(snapshot.data);

                                      // }
                                      if (currentImageBytes != null) {
                                        saveCurrentImage(currentImageBytes!);
                                        Videosaver().uploadImageToFirebase(
                                          currentImageBytes!,
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "No image data to save",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.camera_alt),
                                    iconSize: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } catch (e) {
                    return const Text(
                      'Error rendering image.',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          snapshot.connectionState == ConnectionState.waiting
                              ? "Connecting to camera..."
                              : "No connection. Please check camera or network.",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: _getFab(),
    );
  }
}
