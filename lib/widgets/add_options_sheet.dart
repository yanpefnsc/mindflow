import 'package:flutter/material.dart';

class AddOptionsSheet extends StatelessWidget {
  final VoidCallback onAdicionarTarefa;
  final VoidCallback onConectarProfissional;

  const AddOptionsSheet({
    super.key,
    required this.onAdicionarTarefa,
    required this.onConectarProfissional,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              const SizedBox(height: 22),

              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                leading: const Icon(
                  Icons.add_task,
                  color: Colors.white,
                ),
                title: const Text(
                  'Adicionar tarefa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onTap: onAdicionarTarefa,
              ),

              const SizedBox(height: 6),

              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                leading: const Icon(
                  Icons.link,
                  color: Colors.white,
                ),
                title: const Text(
                  'Conectar profissional',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onTap: onConectarProfissional,
              ),
            ],
          ),
        ),
      ),
    );
  }
}