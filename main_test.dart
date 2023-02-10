import "package:cartesian_vision/decoder/decoder.dart";
import 'package:cartesian_vision/encoder/encoder.dart';
import 'package:cartesian_vision/fragment/fragment.dart';
import 'package:cartesian_vision/polarizer/bipolar_polarizer.dart';
import 'package:image/image.dart';

void main() {
  var point = Point(0, 0);

  print(point);

  var image = decoder.decode(filename: ".resources/inputs/images/11.jpg")!;
  print("image ${image.width} ${image.height}");
  var optimalParams = bipolarPolarizer.computePolarizationParams(source: image);
  bipolarPolarizer.polarize(source: image, params: optimalParams);
  var fragments =
      Fragment.generateFragments(polarizedSource: Image.from(image));
  fragments.removeWhere((frag) => frag.width < 20);
  print("generated ${fragments.length} fragments");
  encoder.encode(filename: ".resources/outputs/images/11.png", source: image);
}
