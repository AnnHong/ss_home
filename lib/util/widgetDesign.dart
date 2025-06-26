import 'package:flutter/material.dart';
import 'package:ss_home/views/systemAdmin/streamingManagement/streamingWidgetHomePage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WidgetDesign {
  Widget buildCameraContainer(
    BuildContext context,
    String cameraName,
    bool isEnabled,
    VoidCallback onPrimaryButtonClick,
    VoidCallback onToggleButtonClick, {
    WebSocketChannel? channel, // Optional WebSocket channel
  }) {
    return SizedBox(
      height: 700,
      child: Container(
        padding: const EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFF448AFF).withOpacity(0.6),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 5,
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cameraName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF448AFF),
                  fontWeight: FontWeight.bold,
                ),
              ),

              // === LIVE STREAM PREVIEW OR PLACEHOLDER ===
              isEnabled && channel != null
                  ? CameraStreamingWidget(
                    cameraName: cameraName,
                    channel: channel,
                  )
                  : Container(
                    width: double.infinity,
                    height: 180.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.grey[200]!, width: 2.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_rounded,
                          size: 80.0,
                          color: const Color(0xFF448AFF),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          '$cameraName Closed',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: isEnabled ? onPrimaryButtonClick : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnabled ? Colors.green : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      elevation: isEnabled ? 8 : 0,
                      shadowColor:
                          isEnabled
                              ? Colors.red.withOpacity(0.4)
                              : Colors.transparent,
                      textStyle: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                    child: Text(
                      isEnabled ? 'Open $cameraName' : '$cameraName Closed',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onToggleButtonClick,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isEnabled
                              ? Colors.redAccent
                              : const Color(0xFF448AFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      elevation: isEnabled ? 8 : 0,
                      shadowColor:
                          isEnabled
                              ? Colors.redAccent.withOpacity(0.4)
                              : const Color(0xFF448AFF).withOpacity(0.4),
                      textStyle: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                    child: Text(isEnabled ? 'Close Camera' : 'Open Camera'),
                  ),
                ],
              ),

              // const SizedBox(width: 15.0),
            ],
          ),
        ),
      ),
    );
  }
}
