import 'dart:ui';

import 'package:flutter/material.dart';

import 'screens/benefits.dart';
import 'screens/home.dart';
import 'screens/my_plans.dart';
import 'theme.dart';

/// Shell do app: abas (Home, Meus Planos, Benefícios) + barra suspensa.
///
/// Usa um Navigator aninhado para que telas empurradas dentro do shell
/// (detalhe do plano, criar plano) mantenham a barra visível.
/// Ajustes é empurrado no Navigator raiz — por isso aparece SEM a barra.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  static RootShellState of(BuildContext context) => context.findAncestorStateOfType<RootShellState>()!;

  @override
  State<RootShell> createState() => RootShellState();
}

class RootShellState extends State<RootShell> {
  final _tab = ValueNotifier<int>(0);
  final _nestedNav = GlobalKey<NavigatorState>();

  /// Troca de aba (fecha telas empurradas dentro do shell).
  void switchTab(int index) {
    _nestedNav.currentState?.popUntil((r) => r.isFirst);
    _tab.value = index;
  }

  /// Empurra uma tela DENTRO do shell (barra continua visível).
  Future<T?> pushInShell<T>(Widget screen) {
    return _nestedNav.currentState!.push<T>(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final nav = _nestedNav.currentState;
        if (nav != null && nav.canPop()) nav.pop();
      },
      child: Scaffold(
        backgroundColor: PlanoColors.background,
        extendBody: true, // conteúdo passa por trás da barra translúcida
        body: Navigator(
          key: _nestedNav,
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (_) => ValueListenableBuilder<int>(
              valueListenable: _tab,
              builder: (_, index, __) => IndexedStack(
                index: index,
                children: const [
                  HomeScreen(),
                  MyPlansScreen(),
                  BenefitsScreen(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _tab,
          builder: (_, index, __) => FloatingNavBar(index: index, onTap: switchTab),
        ),
      ),
    );
  }
}

/// Barra de navegação "suspensa": bordas arredondadas + leve transparência.
class FloatingNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const FloatingNavBar({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset > 0 ? bottomInset + 4 : 18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: PlanoColors.shadow,
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 66,
              decoration: BoxDecoration(
                color: PlanoColors.navBackground.withAlpha(70),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: PlanoColors.navBorder.withAlpha(100)),
              ),
              child: Row(
                children: [
                  _item(0, Icons.home_outlined, Icons.home_rounded, 'Home', context),
                  _item(1, Icons.event_note_outlined, Icons.event_note_rounded, 'Meus Planos', context),
                  _item(2, Icons.card_giftcard_outlined, Icons.card_giftcard_rounded, 'Benefícios', context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int i, IconData icon, IconData activeIcon, String label, BuildContext context) {
    final selected = index == i;
    final color = selected ? PlanoColors.greenMid : PlanoColors.textSecondary;
    return Expanded(
      child: GestureDetector(
        onTap: Feedback.wrapForTap(() => onTap(i), context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: selected ? PlanoColors.green.withAlpha(50) : PlanoColors.greenSoft.withAlpha(0),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(selected ? activeIcon : icon, size: 22, color: color),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
