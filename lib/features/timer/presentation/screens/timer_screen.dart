import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:javerage_timer/features/timer/application/timer_bloc.dart';
import 'package:javerage_timer/features/timer/data/repositories/timer_repository_impl.dart';
import 'package:javerage_timer/features/timer/domain/entities/ticker.dart';
import 'package:javerage_timer/features/timer/presentation/widgets/timer_view.dart';

/// The TimerScreen class is a StatelessWidget that provides a TimerBloc to its child TimerView.
class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(timerRepository: TimerRepositoryImpl(const Ticker())),
      child: TimerView(),
    );
  }
}