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
