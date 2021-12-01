library flutter_audio_visualizer;

import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/painters/polygon_waveform_painter.dart';
import 'package:flutter_audio_visualizer/painters/rectangle_waveform_painter.dart';
import 'package:flutter_audio_visualizer/painters/squiggly_waveform_painter.dart';

class AudioVisualizer extends StatefulWidget {
  const AudioVisualizer({
    Key? key,
    required this.maxDuration,
    required this.elapsedDuration,
    required this.samples,
    required this.height,
    required this.width,
    this.shader,
    this.color,
    this.waveFormType = WaveFormType.polygon,
  }) : super(key: key);

  final Duration maxDuration;
  final Duration elapsedDuration;
  final List<double> samples;
  final double width;
  final double height;
  final Shader? shader;
  final Color? color;
  final WaveFormType waveFormType;

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer> {
  late List<double> data;
  late Duration maxDuration;
  late Duration elapsedDuration;
  late int xAudio;
  late double sliderValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    data = widget.samples;
    maxDuration = widget.maxDuration;
    elapsedDuration = widget.elapsedDuration;
    xAudio = 0;
    sliderValue = 0;
  }

  @override
  void didUpdateWidget(covariant AudioVisualizer oldWidget) {
    // TODO: implement didUpdateWidget
    setState(() {
      data = widget.samples;
      maxDuration = widget.maxDuration;
      elapsedDuration = widget.elapsedDuration;
      sliderValue = elapsedDuration.inMilliseconds / maxDuration.inMilliseconds;

      xAudio = (data.length * sliderValue).toInt();
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    switch (widget.waveFormType) {
      case WaveFormType.polygon:
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: PolygonWaveformPainter(
            samples: data,
            sliderValue: xAudio,
            color: widget.color ?? Theme.of(context).primaryColor,
          ),
        );

      case WaveFormType.squiggly:
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: SquigglyWaveformPainter(
            samples: data,
            xAudioPosition: xAudio,
            sliderValue: sliderValue,
            color: widget.color ?? Theme.of(context).primaryColor,
          ),
        );
      case WaveFormType.rectangle:
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: RectangleWaveformPainter(
            samples: data,
            sliderValue: xAudio,
          ),
        );
    }
  }
}

enum WaveFormType {
  polygon,
  squiggly,
  rectangle,
}
