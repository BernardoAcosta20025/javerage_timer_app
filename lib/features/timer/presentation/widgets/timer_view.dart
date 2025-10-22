import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// AÑADIDO: Importación para el reproductor de audio
import 'package:audioplayers/audioplayers.dart';
import 'package:javerage_timer/features/timer/application/timer_bloc.dart';
import 'package:javerage_timer/features/timer/presentation/widgets/actions_buttons.dart';
import 'package:javerage_timer/features/timer/presentation/widgets/background.dart';
import 'package:javerage_timer/features/timer/presentation/widgets/timer_text.dart';

/// The TimerView class in Dart defines a widget for displaying a timer with associated actions in a
/// responsive layout.
class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    // (Código del Desafío 3)
    return BlocListener<TimerBloc, TimerState>(
      listenWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      listener: (context, state) {
        if (state is TimerFinished) {
          AudioPlayer().play(AssetSource('audio/notification.mp3'));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Timer')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                const Background(),
                // MODIFICADO: Ya no pasamos padding, el layout lo maneja _TimerView
                const _TimerView(),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// The _TimerView class is a StatelessWidget in Dart that displays a TimerText widget with specified
/// vertical padding and ActionButtons below it.
class _TimerView extends StatelessWidget {
  const _TimerView(); // MODIFICADO: Eliminado el padding

  // AÑADIDO: Función de ayuda para formatear la duración
  String _formatDuration(int duration) {
    final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildPortraitLayout(context);
        } else {
          return _buildLandscapeLayout(context);
        }
      },
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    // --- INICIO DESAFÍO 4 (Layout) ---
    // Dividimos la vista en 2 secciones: Timer/Botones y Lista de Vueltas
    return Column(
      children: [
        // Sección 1: Timer y Botones
        const Expanded(
          flex: 3, // Ocupa el 60% superior
          child: _TimerSection(),
        ),

        // Sección 2: Lista de Vueltas
        const Expanded(
          flex: 2, // Ocupa el 40% inferior
          child: _LapListSection(),
        ),
        // --- FIN DESAFÍO 4 ---
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return const Row(
      children: [
        // Sección 1: Timer y Botones
        Expanded(
          flex: 1,
          child: _TimerSection(),
        ),
        // Separador
        VerticalDivider(color: Colors.white54, width: 1),
        // Sección 2: Lista de Vueltas
        Expanded(
          flex: 1,
          child: _LapListSection(),
        ),
      ],
    );
  }
}

class _TimerSection extends StatelessWidget {
  const _TimerSection();

  // AÑADIDO: Método para mostrar el diálogo de duración
  Future<int?> _showDurationDialog(BuildContext context, int currentDuration) {
    final controller =
        TextEditingController(text: (currentDuration / 60).floor().toString());

    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Establecer Duración (minutos)'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Minutos',
              suffixIcon: Icon(Icons.timer_outlined),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final minutes = int.tryParse(controller.text);
                if (minutes != null && minutes > 0) {
                  Navigator.pop(context, minutes * 60);
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      // (Código del Desafío 2)
                      final progress = state.initialDuration == 0
                          ? 1.0
                          : state.currentDuration / state.initialDuration;

                      final size = constraints.maxWidth < constraints.maxHeight
                          ? constraints.maxWidth * 0.75
                          : constraints.maxHeight * 0.6;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: size,
                            height: size,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 10,
                              backgroundColor: Colors.white30,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          // (Código del Desafío 1)
                          GestureDetector(
                            onTap: state is TimerInitial
                                ? () async {
                                    // MODIFICADO: Usamos el método privado
                                    final newDuration =
                                        await _showDurationDialog(
                                      context,
                                      state.currentDuration,
                                    );

                                    if (newDuration != null && context.mounted) {
                                      context.read<TimerBloc>().add(
                                            TimerStarted(duration: newDuration),
                                          );
                                    }
                                  }
                                : null,
                            child: const TimerText(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const ActionsButtons(),
            ],
          ),
        ),
      );
    });
  }
}

class _LapListSection extends StatelessWidget {
  const _LapListSection();

  String _formatDuration(int duration) {
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      // Nos reconstruimos solo si la lista de vueltas cambia
      buildWhen: (prev, state) => prev.laps != state.laps,
      builder: (context, state) {
        if (state.laps.isEmpty) {
          // No mostrar nada si no hay vueltas
          return const Center(
            child: Text(
              'No hay vueltas registradas',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        return Container(
          color: Colors.white10,
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: state.laps.length,
            itemBuilder: (context, index) {
              // Formateamos el tiempo de la vuelta
              final lapTime = state.laps[index];
              final formattedTime = _formatDuration(lapTime);

              return ListTile(
                visualDensity: VisualDensity.compact,
                leading: Text(
                  'Vuelta ${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  formattedTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  } // CORREGIDO: Llave de cierre añadida
}