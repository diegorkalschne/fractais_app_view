import 'dart:io';

import '../interfaces/imandelbrot.dart';
import '../models/fractal_param_model.dart';
import '../repositories/mandelbrot_repository.dart';

class MandelbrotController implements IMandelbrot {
  @override
  Future<File> generateImage(FractalParamModel config) async {
    return await MandelbrotRepository.generateImage(config);
  }
}
