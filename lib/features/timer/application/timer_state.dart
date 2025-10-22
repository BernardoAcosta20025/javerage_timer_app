part of 'timer_bloc.dart';

/// The `sealed class TimerState extends Equatable` in Dart is defining a base class `TimerState` that
/// is marked as `sealed`. In Dart, a sealed class restricts its subclasses to be defined in the same
/// file. This helps in ensuring that all possible subclasses of `TimerState` are known and handled
/// within the same file.
sealed class TimerState extends Equatable {
  const TimerState({
    required this.currentDuration,
    required this.initialDuration,
    // AÑADIDO: Propiedad para almacenar las vueltas
    this.laps = const [],
  });
  final int currentDuration;
  final int initialDuration;
  // AÑADIDO: Propiedad para almacenar las vueltas
  final List<int> laps;

  @override
  // AÑADIDO: 'laps' a las props para Equatable
  List<Object> get props => [currentDuration, initialDuration, laps];
}

/// The `TimerInitial` class represents the initial state of a timer with a specified duration in Dart.
class TimerInitial extends TimerState {
  const TimerInitial({
    required super.currentDuration,
    required super.initialDuration,
    // AÑADIDO: Aceptar vueltas (para preservar al pausar)
    super.laps,
  });

  @override
  String toString() =>
      'TimerInitial { initialDuration: $initialDuration, currentDuration: $currentDuration, laps: ${laps.length} }';
}

/// The `TimerTicking` class represents the state of a timer that is currently ticking with a specific
/// duration.
class TimerTicking extends TimerState {
  const TimerTicking({
    required super.currentDuration,
    required super.initialDuration,
    // AÑADIDO: Aceptar vueltas
    required super.laps,
  });

  @override
  String toString() =>
      'TimerTicking { initialDuration: $initialDuration, currentDuration: $currentDuration, laps: ${laps.length} }';
}

/// The `TimerFinished` class represents a state where the timer has finished.
class TimerFinished extends TimerState {
  const TimerFinished({
    required super.initialDuration,
    // AÑADIDO: Aceptar vueltas (para mostrarlas al final)
    required super.laps,
  }) : super(currentDuration: 0);
}