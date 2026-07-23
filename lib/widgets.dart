import 'package:flutter/material.dart';
import 'models.dart';
import 'theme.dart';

/// Título de seção.
class SectionTitle extends StatelessWidget {
  final String text;
  final Color? color;
  const SectionTitle(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color ?? PlanoColors.textPrimary,
      ),
    );
  }
}

/// Quadrado arredondado com ícone (verde suave por padrão).
class SoftIconBox extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color bg;
  final Color fg;
  const SoftIconBox(
    this.icon, {
    super.key,
    this.size = 48,
    this.bg = PlanoColors.greenSoft,
    this.fg = PlanoColors.greenMid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Icon(icon, color: fg, size: size * 0.5),
    );
  }
}

/// Pílula com o tipo do plano.
class CategoryPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool dark; // versão para fundo verde profundo
  const CategoryPill(this.label, this.icon, {super.key, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final fg = dark ? PlanoColors.onGreenDeep : PlanoColors.greenMid;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: dark ? PlanoColors.white12 : PlanoColors.greenSoft,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
        ],
      ),
    );
  }
}

/// Avatares sobrepostos com fotos ou iniciais.
class MemberAvatars extends StatelessWidget {
  final List<Member> members;
  final int max;
  final double size;
  const MemberAvatars(
    this.members, {
    super.key,
    this.max = 3,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    final show = members.take(max).toList();
    final extra = members.length - show.length;
    final slots = show.length + (extra > 0 ? 1 : 0);
    if (slots == 0) return const SizedBox.shrink();
    final step = size * 0.66;

    Widget circle(Widget child) {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: PlanoColors.baseProfilePicture,
          border: Border.all(width: 2, color: Colors.white),
          shape: BoxShape.circle,
        ),
        child: child,
      );
    }

    return SizedBox(
      width: size + (slots - 1) * step,
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < show.length; i++) Positioned(left: i * step, child: circle(show[i].profilePicture(size))),
          if (extra > 0)
            Positioned(
              left: show.length * step,
              child: circle(Text(
                '+$extra',
                style: TextStyle(fontSize: size * 0.34, fontWeight: FontWeight.w700, color: PlanoColors.greenMid),
              )),
            ),
        ],
      ),
    );
  }
}

/// Linha de informação com rótulo pequeno + valor.
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool light;
  const InfoRow(this.icon, this.label, this.value, {super.key, this.light = false});

  @override
  Widget build(BuildContext context) {
    final labelColor = light ? const Color(0xFFA8CDB8) : PlanoColors.textSecondary;
    final valueColor = light ? Colors.white : PlanoColors.textPrimary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: labelColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: labelColor)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, height: 1.3, color: valueColor)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Botão circular de voltar.
class BackCircle extends StatelessWidget {
  const BackCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: PlanoColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: PlanoColors.border),
        ),
        child: const Icon(Icons.arrow_back_rounded, size: 20, color: PlanoColors.textPrimary),
      ),
    );
  }
}

/// Card de plano (lista da Home).
class PlanCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback onTap;
  const PlanCard(this.plan, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: PlanoColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: PlanoColors.border),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  SoftIconBox(plan.icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${plan.category} · ${formatShort(plan.dateTime)}',
                          style: const TextStyle(fontSize: 12.5, color: PlanoColors.textSecondary),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.place_outlined, size: 13, color: PlanoColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                plan.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.5, color: PlanoColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  MemberAvatars(plan.members, max: 2, size: 26),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Snackbar padrão do app.
void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );
}
