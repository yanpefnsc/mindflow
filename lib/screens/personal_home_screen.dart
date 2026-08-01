import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/task.dart';
import '../widgets/home_drawer.dart';
import '../widgets/task_item.dart';
import 'add_task_screen.dart';

class PersonalHomeScreen extends StatefulWidget {
  const PersonalHomeScreen({super.key});

  @override
  State<PersonalHomeScreen> createState() => _PersonalHomeScreenState();
}

class _PersonalHomeScreenState extends State<PersonalHomeScreen> {
  late final Box<Task> _taskBox;

  @override
  void initState() {
    super.initState();
    _taskBox = Hive.box<Task>('tasks');
  }

  List<Task> get _tarefas {
    final lista = _taskBox.values.toList();
    // Concluídas sobem
    lista.sort((a, b) {
      if (a.concluida == b.concluida) return 0;
      return a.concluida ? -1 : 1;
    });
    return lista;
  }

  void _alternarTarefa(Task tarefa) {
    tarefa.concluida = !tarefa.concluida;
    tarefa.save();
    setState(() {});
  }

  Future<void> _abrirTelaAdicionarTarefa() async {
    final resultado = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );

    if (!mounted || resultado == null) return;

    if (resultado is List<Map<String, dynamic>>) {
      for (final map in resultado) {
        final task = Task(
          id: DateTime.now().millisecondsSinceEpoch.toString() + map['nome'],
          nome: map['nome'] as String,
          concluida: map['concluida'] as bool? ?? false,
          horario: map['horario'] as String?,
          repetirTodosOsDias: map['repetirTodosOsDias'] as bool? ?? false,
        );
        await _taskBox.add(task);
      }
      setState(() {});
    }
  }

  Future<void> _editarTarefa(Task tarefa) async {
    final resultado = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(
          tarefaExistente: {
            'nome': tarefa.nome,
            'concluida': tarefa.concluida,
            'horario': tarefa.horario,
            'repetirTodosOsDias': tarefa.repetirTodosOsDias,
          },
        ),
      ),
    );

    if (!mounted || resultado == null) return;

    if (resultado is Map<String, dynamic>) {
      tarefa.nome = resultado['nome'] as String;
      tarefa.horario = resultado['horario'] as String?;
      tarefa.repetirTodosOsDias = resultado['repetirTodosOsDias'] as bool? ?? false;
      await tarefa.save();
      setState(() {});
    }
  }

  Future<void> _excluirTarefa(Task tarefa) async {
    await tarefa.delete();
    setState(() {});
  }

  void _abrirOpcoesDaTarefa(Task tarefa) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF121212),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
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
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.edit_outlined, color: Colors.white),
                  title: const Text('Editar', style: TextStyle(color: Colors.white, fontSize: 18)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _editarTarefa(tarefa);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.white70),
                  title: const Text('Excluir', style: TextStyle(color: Colors.white70, fontSize: 18)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _excluirTarefa(tarefa);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tarefas = _tarefas;

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const HomeDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 64,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: tarefas.isEmpty
            ? _EmptyState(onAdd: _abrirTelaAdicionarTarefa)
            : ListView.builder(
                key: const ValueKey('lista-tarefas'),
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 110),
                physics: const BouncingScrollPhysics(),
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  final tarefa = tarefas[index];
                  return TaskItem(
                    nome: tarefa.nome,
                    horario: tarefa.horario,
                    concluida: tarefa.concluida,
                    onTap: () => _alternarTarefa(tarefa),
                    onLongPress: () => _abrirOpcoesDaTarefa(tarefa),
                  );
                },
              ),
      ),
      floatingActionButton: tarefas.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _abrirTelaAdicionarTarefa,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              child: const Icon(Icons.add, size: 32),
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
              'Adicione sua primeira tarefa',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'Toque no + para começar',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}