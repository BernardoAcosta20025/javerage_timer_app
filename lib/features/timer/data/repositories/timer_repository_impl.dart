import 'package:javerage_timer/features/timer/domain/repositories/timer_repository.dart';
import 'package.javerage_timer/features/timer/domain/entities/ticker.dart';

/// The `TimerRepositoryImpl` class implements the `TimerRepository` interface and provides a stream of
/// ticks using a `Ticker` instance.
class TimerRepositoryImpl implements TimerRepository {
  TimerRepositoryImpl(this._ticker);

  final Ticker _ticker;

  @override
  Stream<int> ticker() => _ticker.tick();
}