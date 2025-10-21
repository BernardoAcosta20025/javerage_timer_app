import 'package:flutter/material.dart';
import 'package:javerage_timer/features/timer/presentation/widgets/actions_buttons.dart';
import 'package:javerage_timer/presentation/widgets/background.dart';
import 'package:javerage_timer/presentation/widgets/timer_text.dart';

/// The TimerView class in Dart defines a widget for displaying a timer with associated actions in a
/// responsive layout.
class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isPortrait = constraints.maxHeight > constraints.maxWidth;
          final verticalPadding = isPortrait
              ? constraints.maxHeight * 0.1
              : constraints.maxHeight * 0.05;
          return Stack(
            children: [
              const Background(),
              _TimerView(verticalPadding: verticalPadding),
            ],
          );
        },
      ),
    );
  }
}

/// The _TimerView class is a StatelessWidget in Dart that displays a TimerText widget with specified
/// vertical padding and ActionButtons below it.
class _TimerView extends StatelessWidget {
  const _TimerView({required this.verticalPadding});

  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: const Center(child: TimerText()),
        ),
        const ActionsButtons(),
      ],
    );
  }
}