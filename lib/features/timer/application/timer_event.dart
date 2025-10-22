part of 'timer_bloc.dart';

/// The `sealed class TimerEvent extends Equatable` declaration in Dart is creating a base class called
/// `TimerEvent` that is marked as `sealed`. In Dart, a sealed class restricts its subclasses to be
/// defined in the same file. This helps in ensuring that all possible subclasses of `TimerEvent` are
/// known and handled within the same file.
sealed class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

/// The `TimerStarted` class in Dart represents an event indicating the start of a timer with a
/// specified duration.
class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration});
  final int duration;
}

/// The `TimerTicked` class represents an event that occurs when a timer ticks with a specified
/// duration.
class TimerTicked extends TimerEvent {
  const TimerTicked({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}

/// The `TimerPaused` class is a Dart class that represents an event where a timer is paused.
class TimerPaused extends TimerEvent {
  const TimerPaused();
}

/// The `TimerReset` class is a subclass of `TimerEvent` in Dart that represents an event to reset the
/// timer.
class TimerReset extends TimerEvent {
  const TimerReset();
}

// AÑADIDO: Evento para marcar una vuelta
class TimerLapPressed extends TimerEvent {
  const TimerLapPressed();
}