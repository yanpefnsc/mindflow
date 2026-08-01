import 'package:flutter/material.dart';

class AddEditObservationScreen extends StatefulWidget {
  final Map<String, dynamic>? observacaoExistente;

  const AddEditObservationScreen({
    super.key,
    this.observacaoExistente,
  });

  @override
  State<AddEditObservationScreen> createState() =>
      _AddEditObservationScreenState();
}

class _AddEditObservationScreenState extends State<AddEditObservationScreen> {
  late final TextEditingController _controller;
  late final bool _editando;

  @override
  void initState() {
    super.initState();
    _editando = widget.observacaoExistente != null;
    _controller = TextEditingController(
      text: widget.observacaoExistente?['texto'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _salvar() {
    final texto = _controller.text.trim();

    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva alguma coisa antes de salvar')),
      );
      return;
    }

    final agora = DateTime.now();

    final dados = {
      'id': widget.observacaoExistente?['id'] ?? agora.millisecondsSinceEpoch.toString(),
      'texto': texto,
      'criadaEm': widget.observacaoExistente?['criadaEm'] ?? agora,
      'atualizadaEm': agora,
    };

    Navigator.pop(context, dados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _editando ? 'Editar observação' : 'Nova observação',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _salvar,
            child: const Text(
              'Salvar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: TextField(
          controller: _controller,
          autofocus: true,
          maxLines: null,
          expands: true,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            height: 1.5,
          ),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Escreva suas observações aqui...',
            hintStyle: TextStyle(color: Colors.white38),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}