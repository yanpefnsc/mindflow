import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/observation.dart';
import 'add_edit_observation_screen.dart';

class ObservationsScreen extends StatefulWidget {
  const ObservationsScreen({super.key});

  @override
  State<ObservationsScreen> createState() => _ObservationsScreenState();
}

class _ObservationsScreenState extends State<ObservationsScreen> {
  late final Box<Observation> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Observation>('observations');
  }

  List<Observation> get _observacoes {
    final lista = _box.values.toList();
    lista.sort((a, b) => b.atualizadaEm.compareTo(a.atualizadaEm)); // mais recente em cima
    return lista;
  }

  Future<void> _abrirNova() async {
    final resultado = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditObservationScreen()),
    );

    if (!mounted || resultado == null) return;

    final obs = Observation(
      id: resultado['id'] as String,
      texto: resultado['texto'] as String,
      criadaEm: resultado['criadaEm'] as DateTime,
      atualizadaEm: resultado['atualizadaEm'] as DateTime,
    );

    await _box.add(obs);
    setState(() {});
  }

  Future<void> _editar(Observation obs) async {
    final resultado = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditObservationScreen(
          observacaoExistente: {
            'id': obs.id,
            'texto': obs.texto,
            'criadaEm': obs.criadaEm,
            'atualizadaEm': obs.atualizadaEm,
          },
        ),
      ),
    );

    if (!mounted || resultado == null) return;

    obs.texto = resultado['texto'] as String;
    obs.atualizadaEm = resultado['atualizadaEm'] as DateTime;
    await obs.save();
    setState(() {});
  }

  Future<void> _excluir(Observation obs) async {
    await obs.delete();
    setState(() {});
  }

  String _formatar(DateTime data) {
    return DateFormat('dd MMM yyyy', 'pt_BR').format(data);
  }

  @override
  Widget build(BuildContext context) {
    final observacoes = _observacoes;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Observações', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: observacoes.isEmpty
          ? _EmptyState(onAdd: _abrirNova)
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              itemCount: observacoes.length,
              itemBuilder: (context, index) {
                final obs = observacoes[index];
                return Dismissible(
                  key: Key(obs.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red.withOpacity(0.8),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _excluir(obs),
                  child: GestureDetector(
                    onTap: () => _editar(obs),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            obs.texto.isEmpty
                                ? 'Observação sem texto'
                                : (obs.texto.length > 80 ? '${obs.texto.substring(0, 80)}...' : obs.texto),
                            style: const TextStyle(color: Colors.white, fontSize: 17, height: 1.35),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Atualizada: ${_formatar(obs.atualizadaEm)}',
                            style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: observacoes.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _abrirNova,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              child: const Icon(Icons.add, size: 30),
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onAdd,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 1.5),
                ),
                child: const Icon(Icons.add, size: 42, color: Colors.white),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Adicione sua primeira observação',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'Registre o que quiser sobre o seu dia',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}