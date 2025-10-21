/// The `TimerRepository` class in Dart provides a stream of integer values representing time ticks.
abstract class TimerRepository {
  Stream<int> ticker();
}