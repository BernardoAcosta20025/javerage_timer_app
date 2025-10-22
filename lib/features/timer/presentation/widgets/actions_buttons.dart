import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:javerage_timer/features/timer/application/timer_bloc.dart';

/// The `ActionsButtons` class in Dart is a stateless widget that displays different action buttons
/// based on the state of a `TimerBloc` in a Flutter application.
class ActionsButtons extends StatelessWidget {
  const ActionsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...switch (state) {
              TimerInitial() => [
                FloatingActionButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed: () => context.read<TimerBloc>().add(
                        // MODIFICADO: Usar 'currentDuration'
                        TimerStarted(duration: state.currentDuration),
                      ),
                ),
              ],
              TimerTicking() => [
                FloatingActionButton(
                  child: const Icon(Icons.pause),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerPaused()),
                ),
                // --- INICIO DESAFÍO 4 ---
                FloatingActionButton(
                  child: const Icon(Icons.flag),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerLapPressed()),
                ),
                // --- FIN DESAFÍO 4 ---
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
              TimerFinished() => [
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
            },
          ],
        );
      },
    );
  }
}