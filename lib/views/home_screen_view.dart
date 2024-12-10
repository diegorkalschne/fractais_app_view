import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../config/enums.dart';
import '../models/fractal_param_model.dart';
import '../services/service_locator.dart';
import '../stores/maldebrot_store.dart';
import '../utils/debouncer.dart';
import '../utils/string_format_utils.dart';
import '../widgets/cs_label_widget.dart';
import '../widgets/cs_radio_button.dart';
import '../widgets/cs_slider.dart';
import '../widgets/cs_text_form_field.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  final mandelbrotStore = locator<MandelbrotStore>();

  final debouncer = Debouncer(milliseconds: 300);

  void onSearch(FractalParamModel config) {
    debouncer(() {
      final future = mandelbrotStore.generateImage(config);

      mandelbrotStore.setFuture(future);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mandelbrot'),
        centerTitle: true,
        backgroundColor: theme.cardColor,
        scrolledUnderElevation: 0,
        elevation: 10,
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _ParamsSectionWidget(onSearch: onSearch),
          ),
          const SizedBox(height: 20),
          Observer(
            builder: (_) {
              return FutureBuilder<File?>(
                future: mandelbrotStore.future,
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao gerar imagem'));
                  }

                  if (!snapshot.hasData) {
                    return Center(child: Text('Nenhuma informação disponível'));
                  }

                  final image = FileImage(snapshot.data!);

                  image.evict();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CsLabelWidget(
                      label: 'Result',
                      fontSize: 20,
                      child: InteractiveViewer(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            image.file,
                            key: UniqueKey(),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ParamsSectionWidget extends StatefulWidget {
  const _ParamsSectionWidget({
    required this.onSearch,
  });

  final void Function(FractalParamModel) onSearch;

  @override
  State<_ParamsSectionWidget> createState() => _ParamsSectionWidgetState();
}

class _ParamsSectionWidgetState extends State<_ParamsSectionWidget> with SingleTickerProviderStateMixin {
  final mandelbrotStore = locator<MandelbrotStore>();
  final config = FractalParamModel();

  late final AnimationController animationController;
  late final Animation<double> animation;

  final xMinController = TextEditingController();
  final xMaxController = TextEditingController();
  final yMinController = TextEditingController();
  final yMaxController = TextEditingController();

  bool expanded = true;

  @override
  void initState() {
    super.initState();

    setInitialData();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

    animation = CurvedAnimation(
      curve: Curves.easeInToLinear,
      reverseCurve: Curves.easeInToLinear,
      parent: animationController,
    );

    animationController.forward();
  }

  @override
  void dispose() {
    xMinController.dispose();
    xMaxController.dispose();
    yMinController.dispose();
    yMaxController.dispose();

    animationController.dispose();

    super.dispose();
  }

  void setInitialData() {
    xMinController.text = formatZeroDouble(config.xMin, 2);
    xMaxController.text = formatZeroDouble(config.xMax, 2);
    yMinController.text = formatZeroDouble(config.yMin, 2);
    yMaxController.text = formatZeroDouble(config.yMax, 2);
  }

  void toogleExpandedFilters() {
    if (expanded) {
      animationController.reverse();
    } else {
      animationController.forward();
    }

    setState(() {
      expanded = !expanded;
    });
  }

  void resetParams() {
    config.reset();
    setInitialData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          margin: const EdgeInsets.all(0).copyWith(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CsLabelWidget(
                  label: 'Params',
                  actions: [
                    IconButton(
                      icon: Icon(Icons.refresh),
                      tooltip: 'Reset Params',
                      onPressed: resetParams,
                    ),
                  ],
                  fontSize: 20,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Divider(
                      height: 0,
                      thickness: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: SizeTransition(
                    sizeFactor: animation,
                    child: Column(
                      children: [
                        CsLabelWidget(
                          label: 'Type',
                          child: Row(
                            children: [
                              Expanded(
                                child: Observer(
                                  builder: (_) {
                                    return CsRadioButton<MandelbrotType>(
                                      label: 'Mandelbrot',
                                      value: MandelbrotType.mandelbrot,
                                      groupValue: config.type,
                                      onChanged: (value) {
                                        config.setType(value!);
                                      },
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: Observer(
                                  builder: (_) {
                                    return CsRadioButton<MandelbrotType>(
                                      label: 'Julia',
                                      value: MandelbrotType.julia,
                                      groupValue: config.type,
                                      onChanged: (value) {
                                        config.setType(value!);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // xMin e xMax
                        Row(
                          children: [
                            Expanded(
                              child: CsLabelWidget(
                                label: 'xMin',
                                child: CsTextFormField(
                                  hintText: 'Type xMin...',
                                  controller: xMinController,
                                  onChanged: (value) {
                                    final param = double.tryParse(value);

                                    if (param != null) {
                                      config.setXMin(param);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CsLabelWidget(
                                label: 'xMax',
                                child: CsTextFormField(
                                  hintText: 'Type xMax...',
                                  controller: xMaxController,
                                  onChanged: (value) {
                                    final param = double.tryParse(value);

                                    if (param != null) {
                                      config.setXMax(param);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // yMin e yMax
                        Row(
                          children: [
                            Expanded(
                              child: CsLabelWidget(
                                label: 'yMin',
                                child: CsTextFormField(
                                  hintText: 'Type yMin...',
                                  controller: yMinController,
                                  onChanged: (value) {
                                    final param = double.tryParse(value);

                                    if (param != null) {
                                      config.setYMin(param);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CsLabelWidget(
                                label: 'yMax',
                                child: CsTextFormField(
                                  hintText: 'Type yMax...',
                                  controller: yMaxController,
                                  onChanged: (value) {
                                    final param = double.tryParse(value);

                                    if (param != null) {
                                      config.setYMax(param);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Interactions
                        Observer(
                          builder: (_) {
                            return Row(
                              children: [
                                Expanded(
                                  child: CsLabelWidget(
                                    label: 'Interactions',
                                    child: CsSlider(
                                      value: config.interactionsFactor.toDouble(),
                                      min: 100,
                                      max: 10000,
                                      label: '${config.interactionsFactor}',
                                      onChanged: (value) {
                                        config.setInteractionsFactor(value.toInt());
                                      },
                                    ),
                                  ),
                                ),
                                Chip(label: Text('${config.interactionsFactor.toInt()}')),
                              ],
                            );
                          },
                        ),

                        // Real part
                        Observer(
                          builder: (_) {
                            return Visibility(
                              visible: config.type == MandelbrotType.julia,
                              child: CsLabelWidget(
                                label: 'Real Part',
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CsSlider(
                                        value: config.juliaRealPart,
                                        min: -10,
                                        max: 10,
                                        label: '${formatZeroDouble(config.juliaRealPart, 3)}',
                                        onChanged: (value) {
                                          config.setJuliaRealPart(value);
                                        },
                                      ),
                                    ),
                                    Chip(label: Text('${formatZeroDouble(config.juliaRealPart, 3)}')),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Imag part
                        Observer(
                          builder: (_) {
                            return Visibility(
                              visible: config.type == MandelbrotType.julia,
                              child: CsLabelWidget(
                                label: 'Image Part',
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CsSlider(
                                        value: config.juliaImagPart,
                                        min: -10,
                                        max: 10,
                                        label: '${formatZeroDouble(config.juliaImagPart, 3)}',
                                        onChanged: (value) {
                                          config.setJuliaImagPart(value);
                                        },
                                      ),
                                    ),
                                    Chip(label: Text('${formatZeroDouble(config.juliaImagPart, 3)}')),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Zoom
                        Observer(
                          builder: (_) {
                            return CsLabelWidget(
                              label: 'Zoom',
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CsSlider(
                                      value: config.zoomFactor,
                                      min: 1,
                                      max: 10,
                                      label: '${formatZeroDouble(config.zoomFactor, 2)}',
                                      onChanged: (value) {
                                        config.setZoomFactor(value);
                                      },
                                    ),
                                  ),
                                  Chip(label: Text('${formatZeroDouble(config.zoomFactor, 2)}')),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onSearch(config);
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(theme.colorScheme.onPrimary),
                              foregroundColor: WidgetStateProperty.all(Colors.grey[50]),
                            ),
                            child: Text(
                              'Generate',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CircleAvatar(
            child: IconButton(
              icon: Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              onPressed: toogleExpandedFilters,
              tooltip: expanded ? 'Retract' : 'Expand',
            ),
          ),
        ),
      ],
    );
  }
}
