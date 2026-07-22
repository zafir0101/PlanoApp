import 'package:flutter/material.dart';

import '../models.dart';
import '../shell.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import '../widgets/confirm_dialog.dart';

/// Detalhe do plano: tipo, data e hora, localização, descrição,
/// membros participando e botão para entrar.
class PlanDetailScreen extends StatelessWidget {
  final Plan plan;
  const PlanDetailScreen(this.plan, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlanoColors.background,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final joined = appState.isJoined(plan);
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              children: [
                const Row(children: [BackCircle()]),
                const SizedBox(height: 20),
                Row(children: [CategoryPill(plan.category, plan.icon)]),
                const SizedBox(height: 10),
                Text(
                  plan.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: PlanoColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: PlanoColors.border),
                  ),
                  child: Column(
                    children: [
                      InfoRow(Icons.calendar_today_outlined, 'DATA', capitalize(formatFullDate(plan.dateTime))),
                      const SizedBox(height: 14),
                      InfoRow(Icons.schedule_rounded, 'HORÁRIO', formatTime(plan.dateTime)),
                      const SizedBox(height: 14),
                      InfoRow(Icons.place_outlined, 'LOCAL', plan.location),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const SectionTitle('Sobre o plano'),
                const SizedBox(height: 8),
                Text(plan.description, style: const TextStyle(fontSize: 14, height: 1.55, color: Color(0xFF4A514A))),
                const SizedBox(height: 22),
                SectionTitle('Quem vai · ${plan.members.length}'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final m in plan.members) _MemberChip(m),
                  ],
                ),
                const SizedBox(height: 26),
                if (joined) _joinedState(context) else _joinButton(context),
                const SizedBox(height: 110),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _joinButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x335FAE7F), blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: SizedBox(
        height: 58,
        width: double.infinity,
        child: FilledButton(
          onPressed: () {
            final shell = RootShell.of(context);
            appState.joinPlan(plan);
            showToast(context, 'Você entrou no plano!');
            shell.switchTab(1); // vai para Meus Planos
          },
          style: FilledButton.styleFrom(
            backgroundColor: PlanoColors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: const Text('Participar do plano', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _joinedState(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PlanoColors.greenSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: PlanoColors.greenMid),
              SizedBox(width: 10),
              Text(
                'Você está nesse plano',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: PlanoColors.greenMid,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            showConfirmDialog(
              context,
              promptText: "Deseja realmente sair do plano?",
              description: "Os outros participantes irão sentir a sua falta.",
              confirmText: "Sair do plano",
              onConfirm: () {
                appState.leavePlan(plan);
                showToast(context, 'Você saiu do plano.');
              },
            );
          },
          child: const Text(
            'Sair do plano',
            style: TextStyle(fontSize: 13, color: PlanoColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _MemberChip extends StatelessWidget {
  final Member member;
  const _MemberChip(this.member);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
      decoration: BoxDecoration(
        color: PlanoColors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: PlanoColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: PlanoColors.greenSoft,
            child: Text(
              member.initials,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: PlanoColors.greenMid,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(member.firstName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
