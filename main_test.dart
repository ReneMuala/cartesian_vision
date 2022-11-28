import "package:cartesian_vision/decoder/decoder.dart";
import 'package:cartesian_vision/encoder/encoder.dart';
import 'package:cartesian_vision/fragment/fragment.dart';
import 'package:cartesian_vision/polarizer/bipolar_polarizer.dart';
import 'package:image/image.dart';

void main(){
  var image = decoder.decode(filename: ".resources/inputs/images/11.jpg")!;
  print("image ${image.width} ${image.height}");
  var optimalParams = bipolarPolarizer.computePolarizationParams(source: image);
  bipolarPolarizer.polarize(source: image, params: optimalParams);
  List fragments = Fragment.generateFragments(polarizedSource: Image.from(image));
  print("generated ${fragments.length} fragments");
  encoder.encode(filename: ".resources/outputs/images/11.png", source: image);
}