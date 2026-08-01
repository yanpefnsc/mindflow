import 'package:hive/hive.dart';

part 'observation.g.dart';

@HiveType(typeId: 1)
class Observation extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String texto;

  @HiveField(2)
  DateTime criadaEm;

  @HiveField(3)
  DateTime atualizadaEm;

  Observation({
    required this.id,
    required this.texto,
    required this.criadaEm,
    required this.atualizadaEm,
  });
}