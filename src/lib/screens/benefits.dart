import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Benefícios: promoções e vantagens para usuários do Plano.
class BenefitsScreen extends StatelessWidget {
  const BenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: PlanoColors.background,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            children: [
              const Text('Benefícios', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text(
                'Vantagens exclusivas para quem usa o Plano.',
                style: TextStyle(fontSize: 13.5, color: PlanoColors.textSecondary),
              ),
              const SizedBox(height: 20),
              for (final benefit in mockBenefits)
                _BenefitCard(
                  benefit,
                  onRedeem: () => _showCode(context, benefit),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCode(BuildContext context, Benefit benefit) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: PlanoColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: PlanoColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              SoftIconBox(benefit.icon, size: 64),
              const SizedBox(height: 14),
              Text(
                benefit.partner,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                benefit.offer,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: PlanoColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: PlanoColors.greenSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  benefit.code,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: PlanoColors.greenMid,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apresente este código no parceiro.',
                style: TextStyle(fontSize: 12, color: PlanoColors.textSecondary),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  style: FilledButton.styleFrom(
                    backgroundColor: PlanoColors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Fechar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final Benefit benefit;
  final VoidCallback onRedeem;
  const _BenefitCard(this.benefit, {required this.onRedeem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PlanoColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PlanoColors.border),
      ),
      child: Row(
        children: [
          SoftIconBox(benefit.icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(benefit.partner, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(benefit.offer, style: const TextStyle(fontSize: 13, color: PlanoColors.textSecondary)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: PlanoColors.greenSoft,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    benefit.tag,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: PlanoColors.greenMid,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onRedeem,
            style: TextButton.styleFrom(
              backgroundColor: PlanoColors.greenSoft,
              foregroundColor: PlanoColors.greenMid,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Resgatar', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
