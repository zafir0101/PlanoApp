import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../shell.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'plan_detail.dart';

/// Meus Planos.
/// Sem planos: estado vazio convidando a explorar.
/// Com plano ativo: verde mais profundo, contagem regressiva ao vivo
/// e botão "Já estou a caminho".
class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        if (appState.myPlans.isEmpty) return const _EmptyState();

        final active = appState.myPlans.first;
        final others = appState.myPlans.skip(1).toList();
        final onTheWay = appState.onTheWayIds.contains(active.id);

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: PlanoColors.greenDeep,
            body: SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                children: [
                  const Text('Meus Planos',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(
                    others.isEmpty
                        ? 'Seu próximo plano'
                        : 'Seu próximo plano · +${others.length} na agenda',
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFFA8CDB8)),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      CategoryPill(active.category, active.icon, dark: true),
                      const Spacer(),
                      if (active.createdByMe)
                        const Text('Criado por você',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFFA8CDB8))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(active.title,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  // Relógio: quanto tempo falta para o evento
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: PlanoColors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CountdownClock(target: active.dateTime),
                  ),
                  const SizedBox(height: 16),
                  _onTheWayButton(context, active, onTheWay),
                  const SizedBox(height: 20),
                  // Todas as informações do evento
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: PlanoColors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(Icons.calendar_today_outlined, 'DATA',
                            capitalize(formatFullDate(active.dateTime)),
                            light: true),
                        const SizedBox(height: 14),
                        InfoRow(Icons.schedule_rounded, 'HORÁRIO',
                            formatTime(active.dateTime),
                            light: true),
                        const SizedBox(height: 14),
                        InfoRow(Icons.place_outlined, 'LOCAL', active.location,
                            light: true),
                        const SizedBox(height: 16),
                        Container(height: 1, color: PlanoColors.white12),
                        const SizedBox(height: 14),
                        Text(active.description,
                            style: const TextStyle(
                                fontSize: 13.5,
                                height: 1.55,
                                color: PlanoColors.onGreenDeep)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const SectionTitle('Quem vai', color: Colors.white),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      MemberAvatars(active.members,
                          max: 4, size: 32, light: true),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(membersLine(active.members),
                            style: const TextStyle(
                                fontSize: 13, color: PlanoColors.onGreenDeep)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        appState.leavePlan(active);
                        showToast(context, 'Você saiu do plano.');
                      },
                      child: const Text('Sair do plano',
                          style: TextStyle(
                              fontSize: 13, color: PlanoColors.white70)),
                    ),
                  ),
                  if (others.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    const SectionTitle('Depois disso', color: Colors.white),
                    const SizedBox(height: 12),
                    for (final plan in others) _MiniPlanTile(plan),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _onTheWayButton(BuildContext context, Plan plan, bool onTheWay) {
    if (onTheWay) {
      return Container(
        height: 56,
        decoration: BoxDecoration(
          color: PlanoColors.white15,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PlanoColors.white12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Você está a caminho',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      );
    }
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          appState.markOnTheWay(plan);
          showToast(context, 'O grupo foi avisado que você está a caminho.');
        },
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: PlanoColors.greenDeep,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: const Icon(Icons.near_me_rounded, size: 20),
        label: const Text('Já estou a caminho',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

/// Contagem regressiva ao vivo (atualiza a cada segundo).
class CountdownClock extends StatefulWidget {
  final DateTime target;
  const CountdownClock({super.key, required this.target});

  @override
  State<CountdownClock> createState() => _CountdownClockState();
}

class _CountdownClockState extends State<CountdownClock> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = widget.target.difference(now);

    String text;
    String caption;
    double size = 38;

    if (diff.isNegative) {
      final stillHappening =
          now.isBefore(widget.target.add(const Duration(hours: 3)));
      text = stillHappening ? 'Acontecendo agora' : 'Encerrado';
      caption = stillHappening ? 'aproveite!' : 'até a próxima';
      size = 24;
    } else if (diff.inDays >= 1) {
      text =
          '${diff.inDays}d ${two(diff.inHours % 24)}h ${two(diff.inMinutes % 60)}min';
      caption = 'para o plano começar';
    } else {
      text =
          '${two(diff.inHours)}:${two(diff.inMinutes % 60)}:${two(diff.inSeconds % 60)}';
      caption = 'para o plano começar';
    }

    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 4),
        Text(caption,
            style: const TextStyle(fontSize: 13, color: Color(0xFFA8CDB8))),
      ],
    );
  }
}

/// Estado vazio (sem planos).
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: PlanoColors.background,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Meus Planos',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SoftIconBox(Icons.event_note_rounded, size: 84),
                        const SizedBox(height: 20),
                        const Text('Nenhum plano por enquanto',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        const Text(
                          'Encontre um plano que combine com você\nou crie o seu próprio.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: PlanoColors.textSecondary),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () => RootShell.of(context).switchTab(0),
                          style: FilledButton.styleFrom(
                            backgroundColor: PlanoColors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Explorar planos',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
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

/// Tile compacto para os próximos planos.
class _MiniPlanTile extends StatelessWidget {
  final Plan plan;
  const _MiniPlanTile(this.plan);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: PlanoColors.white08,
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () =>
                RootShell.of(context).pushInShell(PlanDetailScreen(plan)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  SoftIconBox(plan.icon,
                      size: 42, bg: PlanoColors.white12, fg: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        const SizedBox(height: 3),
                        Text(formatShort(plan.dateTime),
                            style: const TextStyle(
                                fontSize: 12.5, color: Color(0xFFA8CDB8))),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: PlanoColors.white70, size: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
