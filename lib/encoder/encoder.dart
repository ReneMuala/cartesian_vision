import 'package:image/image.dart';
import 'dart:io';

class encoder {
  static void encode({required String filename, required Image source, String format = "png"}) {
    var output = File(filename);
      try {
        switch (format) {
        case "png":
          output.writeAsBytesSync(encodePng(source));
        break;
        case "jpeg":
        case "jpg":
          output.writeAsBytesSync(encodeJpg(source));
          break;
        default:
          throw Exception("unsupported file format");
      }
    } catch (e){
        print("encode(...): ${e}");
      }
  }
}