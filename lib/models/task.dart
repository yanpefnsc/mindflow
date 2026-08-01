import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nome;

  @HiveField(2)
  bool concluida;

  @HiveField(3)
  String? horario;

  @HiveField(4)
  bool repetirTodosOsDias;

  Task({
    required this.id,
    required this.nome,
    this.concluida = false,
    this.horario,
    this.repetirTodosOsDias = false,
  });
}