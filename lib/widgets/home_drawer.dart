import 'package:flutter/material.dart';
import '../screens/observations_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  String _dataAtual() {
    final agora = DateTime.now();

    const meses = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
    ];

    final mes = meses[agora.month - 1];
    return '${agora.day} $mes';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 34, 28, 18),
              child: Text(
                _dataAtual(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 28, right: 80),
              child: Divider(
                color: Colors.white24,
                thickness: 1,
                height: 1,
              ),
            ),

            const SizedBox(height: 28),

            // Observações
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
              leading: const Icon(Icons.edit_note, color: Colors.white),
              title: const Text(
                'Observações',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ObservationsScreen(),
                  ),
                );
              },
            ),

            // Conectar médico
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
              leading: const Icon(Icons.medical_services_outlined, color: Colors.white),
              title: const Text(
                'Conectar-se a um médico',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // To-do list prontos
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
              leading: const Icon(Icons.list_alt, color: Colors.white),
              title: const Text(
                'To-do list prontos',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // Configurações
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
              leading: const Icon(Icons.settings_outlined, color: Colors.white),
              title: const Text(
                'Configurações',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}