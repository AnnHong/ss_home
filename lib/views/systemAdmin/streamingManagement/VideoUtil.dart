import 'dart:async';

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class VideoUtil {
  static String? workPath;
  static String? appTempDir;

  static Future<void> getAppTempDirectory() async {
    appTempDir = '${(await getTemporaryDirectory()).path}/$workPath';
  }

  static Future<void> saveImageFileToDirectory(
    Uint8List byteData,
    String localName,
  ) async {
    if (appTempDir == null) {
      await getAppTempDirectory();
    }
    final directory = await Directory(appTempDir!).create(recursive: true);
    final file = File('${directory.path}/$localName');

    await file.writeAsBytes(
      byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
    );

    print("filePath : ${file.path}");
  }

  static Future<void> deleteTempDirectory() async {
    final dir = Directory(appTempDir!);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  static String generateEncodeVideoScript(String videoCodec, String fileName) {
    String outputPath = "$appTempDir/$fileName";

    return "-hide_banner -y -framerate 30 -i '" +
        appTempDir! +
        "/" +
        "image_%d.jpg" +
        "' -c:v " +
        videoCodec +
        " " +
        outputPath;
  }
}
