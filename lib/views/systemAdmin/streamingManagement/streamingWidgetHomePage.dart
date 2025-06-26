// camera_streaming_widget.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CameraStreamingWidget extends StatefulWidget {
  final String cameraName;
  final WebSocketChannel channel;

  const CameraStreamingWidget({
    super.key,
    required this.cameraName,
    required this.channel,
  });

  @override
  State<CameraStreamingWidget> createState() => _CameraStreamingWidgetState();
}

class _CameraStreamingWidgetState extends State<CameraStreamingWidget> {
  Uint8List? currentImageBytes;

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: widget.channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              try {
                currentImageBytes = snapshot.data;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: GestureZoomBox(
                        maxScale: 4.0,
                        doubleTapScale: 2.0,
                        child: Image.memory(
                          currentImageBytes!,
                          gaplessPlayback: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                );
              } catch (e) {
                return const Text('Error displaying image');
              }
            } else {
              return Column(
                children: const [
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Connecting to camera..."),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
