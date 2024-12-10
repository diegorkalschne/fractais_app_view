import 'package:mobx/mobx.dart';

import '../config/enums.dart';

part 'fractal_param_model.g.dart';

class FractalParamModel = _FractalParamModel with _$FractalParamModel;

abstract class _FractalParamModel with Store {
  @observable
  MandelbrotType type = MandelbrotType.mandelbrot;

  @observable
  double zoomFactor = 1;

  @observable
  int interactionsFactor = 100;

  @observable
  double xMin = -2;

  @observable
  double xMax = 1;

  @observable
  double yMin = -1.5;

  @observable
  double yMax = 1.5;

  @observable
  double juliaRealPart = -0.8;

  @observable
  double juliaImagPart = 0.156;

  @action
  void setType(MandelbrotType type) {
    this.type = type;
  }

  @action
  void setZoomFactor(double zoomFactor) {
    this.zoomFactor = zoomFactor;
  }

  @action
  void setInteractionsFactor(int interactionsFactor) {
    this.interactionsFactor = interactionsFactor;
  }

  @action
  void setXMin(double xMin) {
    this.xMin = xMin;
  }

  @action
  void setXMax(double xMax) {
    this.xMax = xMax;
  }

  @action
  void setYMin(double yMin) {
    this.yMin = yMin;
  }

  @action
  void setYMax(double yMax) {
    this.yMax = yMax;
  }

  @action
  void setJuliaRealPart(double juliaRealPart) {
    this.juliaRealPart = juliaRealPart;
  }

  @action
  void setJuliaImagPart(double juliaImagPart) {
    this.juliaImagPart = juliaImagPart;
  }

  @action
  void reset() {
    zoomFactor = 1;
    interactionsFactor = 100;
    xMin = -2;
    xMax = 1;
    yMin = -1.5;
    yMax = 1.5;
    juliaRealPart = -0.8;
    juliaImagPart = 0.156;
  }
}
