import 'dart:io';

import '../models/fractal_param_model.dart';

abstract class IMandelbrot {
  Future<File> generateImage(FractalParamModel config);
}
