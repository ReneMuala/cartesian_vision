import 'package:cartesian_vision/color_operations/color_operations.dart';
import 'package:image/image.dart';

class BipolarPolarizationParams {
  int delimiter, negative, positive;
  @override
  String toString(){
    return "{delimiter: ${delimiter.toRadixString(16)} negative: ${negative.toRadixString(16)}  positive: ${positive.toRadixString(16)}}";
  }
  BipolarPolarizationParams({required int this.delimiter, required int this.negative,  required int this.positive});
}

final DefaultBipolarPolarizationParams = BipolarPolarizationParams(
  delimiter: Color.fromRgb(127, 127, 127), 
  negative: Color.fromRgb(0, 0, 0),
  positive: Color.fromRgb(255, 255, 255),
);

class bipolarPolarizer {

  static BipolarPolarizationParams computePolarizationParams({required Image source}){
    var firstIteration = true;
    int minColor = 0, maxColor= 0;
    source.data.forEach((color) {
      if(firstIteration){
        minColor = maxColor = color;
        firstIteration = false;
      } else {
        if(getRed(color)  < getRed(minColor)) minColor = setRed(minColor, getRed(color));
        else if(getRed(color)  >= getRed(maxColor)) maxColor = setRed(maxColor, getRed(color));

        if(getGreen(color) < getGreen(minColor)) minColor = setGreen(minColor, getGreen(color));
        else if(getGreen(color) >= getGreen(maxColor)) maxColor = setGreen(maxColor, getGreen(color));

        if(getBlue(color) < getBlue(minColor)) minColor = setBlue(minColor, getBlue(color));
        else if(getBlue(color) >= getBlue(maxColor)) maxColor = setBlue(maxColor, getBlue(color));
      }
    });
    var params = BipolarPolarizationParams(delimiter: colorOperations.avgRGB(maxColor, minColor), negative: minColor, positive: maxColor);
    return params;
  }

  static void polarize({required Image source, required BipolarPolarizationParams params}){
    for (var y = 0; y < source.height; y++) {
      for (var x = 0; x < source.width; x++) {
        var color = source.getPixel(x, y);
        if(getRed(color) > getRed(params.delimiter) || getGreen(color) > getGreen(params.delimiter) || getBlue(color) > getBlue(params.delimiter)){
          source.setPixel(x, y, params.positive);
        } else {
          source.setPixel(x, y, params.negative);
        }
      }
    }
  }
}