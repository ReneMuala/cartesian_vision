import 'package:image/image.dart';
import 'dart:io';

class decoder {
    static Image? decode({required String filename}){
    try {
        var file = File(filename).readAsBytesSync();
        return decodeImage(file);
    } catch(e){
        print("decode(...): ${e}");
        return null;
    }
  }
}