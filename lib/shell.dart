/// Estrutura principal de navegação do aplicativo Plano.
///
/// Este arquivo implementa um contêiner (Shell) que gerencia um [Navigator]
/// aninhado. Isso permite que a barra de navegação inferior permaneça visível
/// mesmo quando novas telas são abertas dentro das abas.
library;

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

  /// Acessa o estado do [RootShell] a partir de qualquer widget descendente.
  /// 
  /// Útil para forçar a troca de abas ou empurrar telas via [pushInShell]
  /// de dentro das páginas do aplicativo, resolvendo o problema de prop drilling.
  static RootShellState of(BuildContext context) => context.findAncestorStateOfType<RootShellState>()!;

  @override
  State<RootShell> createState() => RootShellState();
}

class RootShellState extends State<RootShell> {
  final _tab = ValueNotifier<int>(0);
  final _nestedNav = GlobalKey<NavigatorState>();

  /// Altera a aba ativa e reseta a pilha de navegação interna.
  ///
  /// Ao clicar em uma aba, qualquer tela que tenha sido empurrada dentro 
  /// do shell atual será fechada, retornando à raiz da aba selecionada.
  void switchTab(int index) {
    _nestedNav.currentState?.popUntil((r) => r.isFirst);
    _tab.value = index;
  }

  /// Empurra uma nova tela mantendo a barra de navegação inferior visível.
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
      // evita que o aplicativo encerre com back gestures do sistema
      canPop: false,                          
      onPopInvokedWithResult: (didPop, _) {  
        if (didPop) return;
        final nav = _nestedNav.currentState;
        if (nav != null && nav.canPop()) nav.pop();
      },

      child: Scaffold(
        backgroundColor: PlanoColors.background,
        extendBody: true, 
        body: Navigator(
          key: _nestedNav,
          onGenerateRoute: (_) => MaterialPageRoute(
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
        // parei aqui
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _tab,
          builder: (_, index, __) => FloatingNavBar(selectedTab: index, handleTap: switchTab),
        ),
      ),
    );
  }
}

/// A barra de navegação flutuante com visual Glassmorphism.
class FloatingNavBar extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> handleTap;

  const FloatingNavBar({super.key, required this.selectedTab, required this.handleTap});

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
                color: PlanoColors.navBackground,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: PlanoColors.navBorder),
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

  /// Constrói um item individual (botão) da barra de navegação.
  Widget _item(int i, IconData icon, IconData activeIcon, String label, BuildContext context) {
    final selected = (selectedTab == i);
    final color = selected ? PlanoColors.greenMid : PlanoColors.textSecondary;
    return  Expanded(
      child: GestureDetector(
        onTap: Feedback.wrapForTap(() => handleTap(i), context),
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
