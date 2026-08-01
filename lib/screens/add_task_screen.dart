import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/time_picker_dialog.dart';

class AddTaskScreen extends StatefulWidget {
  final Map<String, dynamic>? tarefaExistente;

  const AddTaskScreen({
    super.key,
    this.tarefaExistente,
  });

  @override
  State<AddTaskScreen> createState() =>
      _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late final TextEditingController _nomeController;
  late final FocusNode _nomeFocusNode;

  final List<Map<String, dynamic>> _tarefasAdicionadas = [];

  TimeOfDay? _horario;
  bool _repetirTodosOsDias = false;

  String? _mensagemDeSucesso;
  Timer? _temporizadorDaMensagem;

  bool get _editando => widget.tarefaExistente != null;

  @override
  void initState() {
    super.initState();

    final tarefa = widget.tarefaExistente;

    _nomeController = TextEditingController(
      text: tarefa?['nome'] as String? ?? '',
    );

    _nomeFocusNode = FocusNode();

    _repetirTodosOsDias =
        tarefa?['repetirTodosOsDias'] as bool? ?? false;

    final horarioSalvo = tarefa?['horario'] as String?;

    if (horarioSalvo != null && horarioSalvo.contains(':')) {
      final partes = horarioSalvo.split(':');

      final hora = int.tryParse(partes[0]);
      final minuto = int.tryParse(partes[1]);

      if (hora != null && minuto != null) {
        _horario = TimeOfDay(
          hour: hora,
          minute: minuto,
        );
      }
    }
  }

  @override
  void dispose() {
    _temporizadorDaMensagem?.cancel();
    _nomeController.dispose();
    _nomeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selecionarHorario() async {
    final horarioEscolhido =
        await showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return MindFlowTimePicker(
          initialTime: _horario,
        );
      },
    );

    if (horarioEscolhido == null || !mounted) {
      return;
    }

    setState(() {
      _horario = horarioEscolhido;
    });
  }

  String? _formatarHorario() {
    if (_horario == null) {
      return null;
    }

    final hora =
        _horario!.hour.toString().padLeft(2, '0');

    final minuto =
        _horario!.minute.toString().padLeft(2, '0');

    return '$hora:$minuto';
  }

  Map<String, dynamic> _criarDadosDaTarefa(String nome) {
    return {
      'nome': nome,
      'concluida':
          widget.tarefaExistente?['concluida'] as bool? ??
              false,
      'horario': _formatarHorario(),
      'repetirTodosOsDias': _repetirTodosOsDias,
    };
  }

  void _removerHorario() {
    setState(() {
      _horario = null;
    });
  }

  void _mostrarMensagemDeSucesso(String nome) {
    _temporizadorDaMensagem?.cancel();

    setState(() {
      _mensagemDeSucesso = '$nome adicionada';
    });

    _temporizadorDaMensagem = Timer(
      const Duration(seconds: 4),
      () {
        if (!mounted) {
          return;
        }

        setState(() {
          _mensagemDeSucesso = null;
        });
      },
    );
  }

  void _limparFormulario() {
    _nomeController.clear();

    setState(() {
      _horario = null;
      _repetirTodosOsDias = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _nomeFocusNode.requestFocus();
      }
    });
  }

  void _salvarTarefa() {
    final nome = _nomeController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o nome da tarefa.'),
        ),
      );

      _nomeFocusNode.requestFocus();
      return;
    }

    final tarefa = _criarDadosDaTarefa(nome);

    if (_editando) {
      Navigator.pop(context, tarefa);
      return;
    }

    _tarefasAdicionadas.add(tarefa);

    _mostrarMensagemDeSucesso(nome);
    _limparFormulario();
  }

  void _fecharTela() {
    if (_editando) {
      Navigator.pop(context);
      return;
    }

    Navigator.pop(
      context,
      List<Map<String, dynamic>>.from(
        _tarefasAdicionadas,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _fecharTela();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: _fecharTela,
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              28,
              20,
              28,
              32,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _editando
                      ? 'Editar tarefa'
                      : 'Nova tarefa',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 34),

                TextField(
                  controller: _nomeController,
                  focusNode: _nomeFocusNode,
                  autofocus: !_editando,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    _salvarTarefa();
                  },
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Nome da tarefa',
                    labelStyle: const TextStyle(
                      color: Colors.white54,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.white38,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.schedule,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Horário',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Text(
                    _horario == null
                        ? 'Sem horário definido'
                        : _formatarHorario()!,
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_horario != null)
                        IconButton(
                          onPressed: _removerHorario,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white54,
                          ),
                        ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                  onTap: _selecionarHorario,
                ),

                const SizedBox(height: 12),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: Colors.black,
                  activeTrackColor: Colors.white,
                  inactiveThumbColor: Colors.white54,
                  inactiveTrackColor: Colors.white12,
                  title: const Text(
                    'Repetir todos os dias',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  value: _repetirTodosOsDias,
                  onChanged: (valor) {
                    setState(() {
                      _repetirTodosOsDias = valor;
                    });
                  },
                ),

                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _salvarTarefa,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _editando
                          ? 'Salvar alterações'
                          : 'Adicionar tarefa',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 250),
                  transitionBuilder: (
                    child,
                    animation,
                  ) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.96,
                          end: 1,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _mensagemDeSucesso == null
                      ? const SizedBox(
                          key: ValueKey('sem-mensagem'),
                          height: 34,
                        )
                      : Center(
                          key: ValueKey(
                            _mensagemDeSucesso,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF72E0A2),
                                size: 26,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  _mensagemDeSucesso!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color:
                                        Color(0xFF72E0A2),
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}