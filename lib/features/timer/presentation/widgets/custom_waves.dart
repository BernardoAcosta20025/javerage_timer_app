import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

/// The `CustomWaves` class creates a widget with custom wave configurations for a visually appealing
/// design.
class CustomWaves extends StatelessWidget {
  const CustomWaves({super.key});

  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            const Color.fromRGBO(72, 136, 199, 1),
            const Color.fromRGBO(72, 136, 199, 1),
          ],
          [
            const Color.fromRGBO(72, 136, 199, 0.8),
            const Color.fromRGBO(72, 136, 199, 0.8),
          ],
          [
            const Color.fromRGBO(72, 136, 199, 0.6),
            const Color.fromRGBO(72, 136, 199, 0.6),
          ],
          [
            const Color.fromRGBO(72, 136, 199, 0.4),
            const Color.fromRGBO(72, 136, 199, 0.4),
          ],
        ],
        durations: [30000, 21000, 18000, 50000],

        heightPercentages: [0.30, 0.28, 0.30, 0.26],
        blur: const MaskFilter.blur(BlurStyle.solid, 10),
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topRight,
      ),
      waveAmplitude: 35,
      size: const Size(double.infinity, double.infinity),
    );
  }
}