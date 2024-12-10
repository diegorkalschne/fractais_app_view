import 'dart:io';

import 'package:mobx/mobx.dart';

import '../controllers/mandelbrot_controller.dart';
import '../models/fractal_param_model.dart';

part 'maldebrot_store.g.dart';

class MandelbrotStore = _MandelbrotStore with _$MandelbrotStore;

abstract class _MandelbrotStore with Store {
  @observable
  Future<File?>? future;

  @action
  void setFuture(Future<File?> future) {
    this.future = future;
  }

  Future<File?> generateImage(FractalParamModel config) async {
    final file = await MandelbrotController().generateImage(config);

    return file;
  }
}
