import 'package:flutter/material.dart';

class MindFlowTimePicker extends StatefulWidget {
  final TimeOfDay? initialTime;

  const MindFlowTimePicker({
    super.key,
    this.initialTime,
  });

  @override
  State<MindFlowTimePicker> createState() =>
      _MindFlowTimePickerState();
}

class _MindFlowTimePickerState
    extends State<MindFlowTimePicker> {
  late int hora;
  late int minuto;

  late final FixedExtentScrollController _horaController;
  late final FixedExtentScrollController _minutoController;

  @override
  void initState() {
    super.initState();

    final horarioInicial = widget.initialTime ??
        const TimeOfDay(
          hour: 8,
          minute: 0,
        );

    hora = horarioInicial.hour;
    minuto = horarioInicial.minute;

    _horaController = FixedExtentScrollController(
      initialItem: hora,
    );

    _minutoController = FixedExtentScrollController(
      initialItem: minuto,
    );
  }

  @override
  void dispose() {
    _horaController.dispose();
    _minutoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        28,
        20,
        28,
        28,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 26),

            const Text(
              'Horário',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.06,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TimeWheel(
                        controller: _horaController,
                        itemCount: 24,
                        selectedValue: hora,
                        onChanged: (valor) {
                          setState(() {
                            hora = valor;
                          });
                        },
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        child: Text(
                          ':',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      _TimeWheel(
                        controller: _minutoController,
                        itemCount: 60,
                        selectedValue: minuto,
                        onChanged: (valor) {
                          setState(() {
                            minuto = valor;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            const Divider(
              color: Colors.white12,
              height: 1,
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        TimeOfDay(
                          hour: hora,
                          minute: minuto,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeWheel extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int itemCount;
  final int selectedValue;
  final ValueChanged<int> onChanged;

  const _TimeWheel({
    required this.controller,
    required this.itemCount,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 180,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 56,
        diameterRatio: 1.6,
        perspective: 0.003,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            final selecionado = index == selectedValue;

            return Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(
                  milliseconds: 150,
                ),
                style: TextStyle(
                  color: selecionado
                      ? Colors.white
                      : Colors.white24,
                  fontSize: selecionado ? 34 : 22,
                  fontWeight: selecionado
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                child: Text(
                  index.toString().padLeft(2, '0'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}