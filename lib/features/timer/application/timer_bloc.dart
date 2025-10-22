import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:javerage_timer/features/timer/domain/repositories/timer_repository.dart';

part 'timer_event.dart';
part 'timer_state.dart';

/// The TimerBloc class in Dart is responsible for managing timer events and states, utilizing a
/// TimerRepository for functionality like starting, ticking, pausing, and resetting timers.
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required TimerRepository timerRepository})
      : _timerRepository = timerRepository,
        super(const TimerInitial(
          currentDuration: _duration,
          initialDuration: _duration,
          laps: [],
        )) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerReset>(_onReset);
    // AÑADIDO: Registrar el manejador del nuevo evento
    on<TimerLapPressed>(_onLapPressed);
  }

  final TimerRepository _timerRepository;
  static const int _duration = 60;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerTicking(
      currentDuration: event.duration,
      initialDuration: event.duration,
      // AÑADIDO: Empezar con una lista de vueltas vacía
      laps: const [],
    ));
    _tickerSubscription?.cancel();
    _tickerSubscription = _timerRepository
        .ticker()
        .listen((ticks) => add(TimerTicked(duration: event.duration - ticks)));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0
          ? TimerTicking(
              currentDuration: event.duration,
              initialDuration: state.initialDuration,
              // AÑADIDO: Preservar las vueltas en cada tick
              laps: state.laps,
            )
          : TimerFinished(
              initialDuration: state.initialDuration,
              // AÑADIDO: Preservar las vueltas al finalizar
              laps: state.laps,
            ),
    );
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerTicking) {
      _tickerSubscription?.pause();
      emit(TimerInitial(
        currentDuration: state.currentDuration,
        initialDuration: state.initialDuration,
        // AÑADIDO: Preservar las vueltas al pausar
        laps: state.laps,
      ));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    // MODIFICADO: El estado inicial por defecto ya tiene 'laps: []'
    emit(const TimerInitial(
      currentDuration: _duration,
      initialDuration: _duration,
    ));
  }

  // AÑADIDO: Manejador para el evento 'TimerLapPressed'
  void _onLapPressed(TimerLapPressed event, Emitter<TimerState> emit) {
    // Solo podemos marcar vueltas si el temporizador está corriendo
    if (state is TimerTicking) {
      // Obtenemos la duración actual
      final lapTime = state.currentDuration;
      // Creamos una nueva lista con la vuelta añadida
      final updatedLaps = List<int>.from(state.laps)..add(lapTime);

      // Emitimos un nuevo estado 'Ticking' con la lista de vueltas actualizada
      emit(TimerTicking(
        currentDuration: state.currentDuration,
        initialDuration: state.initialDuration,
        laps: updatedLaps,
      ));
    }
  }
}