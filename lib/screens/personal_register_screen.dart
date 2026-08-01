import 'package:flutter/material.dart';

class PersonalRegisterScreen extends StatefulWidget {
  const PersonalRegisterScreen({super.key});

  @override
  State<PersonalRegisterScreen> createState() =>
      _PersonalRegisterScreenState();
}

class _PersonalRegisterScreenState extends State<PersonalRegisterScreen> {
  bool esconderSenha = true;
  bool esconderConfirmacao = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crie sua conta',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            const _CampoTexto(label: 'Nome'),
            const SizedBox(height: 18),
            const _CampoTexto(
              label: 'E-mail',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 18),
            _CampoSenha(
              label: 'Senha',
              esconder: esconderSenha,
              aoAlternar: () {
                setState(() {
                  esconderSenha = !esconderSenha;
                });
              },
            ),
            const SizedBox(height: 18),
            _CampoSenha(
              label: 'Confirmar senha',
              esconder: esconderConfirmacao,
              aoAlternar: () {
                setState(() {
                  esconderConfirmacao = !esconderConfirmacao;
                });
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Criar conta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampoTexto extends StatelessWidget {
  final String label;
  final TextInputType? keyboardType;

  const _CampoTexto({
    required this.label,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}

class _CampoSenha extends StatelessWidget {
  final String label;
  final bool esconder;
  final VoidCallback aoAlternar;

  const _CampoSenha({
    required this.label,
    required this.esconder,
    required this.aoAlternar,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: esconder,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        suffixIcon: IconButton(
          onPressed: aoAlternar,
          icon: Icon(
            esconder ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}