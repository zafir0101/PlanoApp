/// Ponto de entrada do aplicativo.
///
/// Este arquivo é responsável por inicializar o Flutter e configurar 
/// as propriedades globais do aplicativo, como o tema base e a 
/// o Shell.

import 'package:flutter/material.dart';
import 'shell.dart';
import 'theme.dart';

void main() => runApp(const PlanoApp());

class PlanoApp extends StatelessWidget {
  const PlanoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plano',
      debugShowCheckedModeBanner: false,
      theme: buildPlanoTheme(),
      home: const RootShell(),
    );
  }
}
