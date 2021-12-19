import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/waveforms/polygon_waveform/polygon_waveform.dart';
import 'package:flutter_audio_waveforms/src/util/waveform_alignment.dart';
import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';

///InActiveWaveformPainter for the [PolygonWaveform]
class PolygonInActiveWaveformPainter extends InActiveWaveformPainter {
  // ignore: public_member_api_docs
  PolygonInActiveWaveformPainter({
    Color color = Colors.white,
    Gradient? gradient,
    required List<double> samples,
    required WaveformAlignment waveformAlignment,
    required this.style,
    required double sampleWidth,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
        );

  /// Style of the waveform
  final PaintingStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = style
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path();

    for (var i = 0; i < samples.length; i++) {
      final x = sampleWidth * i;
      final y = samples[i];

      if (i == samples.length - 1) {
        path.lineTo(x, 0);
      } else {
        path.lineTo(x, y);
      }
    }

    //Gets the [alignPosition] depending on [waveformAlignment]
    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    //Shifts the path along y-axis by amount of [alignPosition]
    final shiftedPath = path.shift(Offset(0, alignPosition));

    canvas.drawPath(shiftedPath, paint);
  }
}
