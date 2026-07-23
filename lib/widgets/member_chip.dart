import 'package:flutter/material.dart';
import 'package:plano_app/models.dart';
import 'package:plano_app/theme.dart';

class MemberChip extends StatelessWidget {
  final Member member;
  final bool translucent;

  const MemberChip(this.member, {this.translucent = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: translucent ? Colors.white54 : PlanoColors.surface),
      child: ActionChip(
        avatar: member.profilePicture(24),
        onPressed: () {}, // TODO: Abrir prévia do perfil do membro ao clicar.
        shape: const RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(100))),
        side: BorderSide(color: PlanoColors.border.withAlpha(translucent ? 170 : 255)),
        label: Text(member.firstName,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: PlanoColors.textPrimary)),
      ),
    );
  }
}
