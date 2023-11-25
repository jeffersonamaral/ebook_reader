import 'package:flutter/rendering.dart';

void toggleDebug([bool? enable]) {
  if (enable == null) {
    debugPaintSizeEnabled = !debugPaintSizeEnabled;
    debugPaintPointersEnabled = !debugPaintPointersEnabled;
    debugPaintBaselinesEnabled = !debugPaintBaselinesEnabled;
    debugPaintLayerBordersEnabled = !debugPaintLayerBordersEnabled;
    debugRepaintRainbowEnabled = !debugRepaintRainbowEnabled;
  } else {
    debugPaintSizeEnabled = enable;
    debugPaintPointersEnabled = enable;
    debugPaintBaselinesEnabled = enable;
    debugPaintLayerBordersEnabled = enable;
    debugRepaintRainbowEnabled = enable;
  }
}