import 'package:flutter/material.dart';
import 'package:javerage_timer/features/timer/presentation/widgets/custom_waves.dart';

/// The `Background` class is a StatelessWidget that returns a `CustomWaves` widget in its build method.
class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomWaves();
  }
}