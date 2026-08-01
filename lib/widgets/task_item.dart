import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskItem extends StatelessWidget {
  final String nome;
  final String? horario;
  final bool concluida;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const TaskItem({
    super.key,
    required this.nome,
    required this.concluida,
    required this.onTap,
    required this.onLongPress,
    this.horario,
  });

  Future<void> _alternarTarefa() async {
    await HapticFeedback.lightImpact();
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _alternarTarefa,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 19,
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(
                concluida
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                key: ValueKey<bool>(concluida),
                color: concluida ? Colors.white70 : Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                style: TextStyle(
                  color: concluida ? Colors.white60 : Colors.white,
                  fontSize: 24, // ← aumentei o tamanho
                  fontWeight: FontWeight.w400,
                  decoration: concluida
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: Colors.white60,
                  decorationThickness: 1.5,
                ),
                child: Text(nome),
              ),
            ),
            if (horario != null && horario!.isNotEmpty) ...[
              const SizedBox(width: 16),
              Text(
                horario!,
                style: TextStyle(
                  color: concluida ? Colors.white38 : Colors.white60,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  decoration: concluida
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: Colors.white38,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}