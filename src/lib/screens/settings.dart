import 'package:flutter/material.dart';

import '../theme.dart';

/// Ajustes — aberta pelo canto superior direito da Home.
/// É a única tela SEM a barra de navegação inferior
/// (é empurrada no Navigator raiz, acima do shell).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlanoColors.background,
      appBar: AppBar(
        title: const Text('Ajustes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _profileCard(),
          const SizedBox(height: 20),
          _group('CONTA', [
            _tile(Icons.person_outline_rounded, 'Perfil'),
            _switchTile(Icons.notifications_none_rounded, 'Notificações'),
            _tile(Icons.lock_outline_rounded, 'Privacidade'),
          ]),
          const SizedBox(height: 16),
          _group('PREFERÊNCIAS', [
            _tile(Icons.tune_rounded, 'Categorias favoritas'),
            _tile(Icons.place_outlined, 'Localização'),
          ]),
          const SizedBox(height: 16),
          _group('SUPORTE', [
            _tile(Icons.help_outline_rounded, 'Ajuda'),
            _tile(Icons.info_outline_rounded, 'Sobre o Plano'),
          ]),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: PlanoColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: PlanoColors.border),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout_rounded,
                  color: Color(0xFFB3564A), size: 22),
              title: const Text('Sair da conta',
                  style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB3564A))),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text('Plano · versão 0.1.0',
                style:
                    TextStyle(fontSize: 12, color: PlanoColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PlanoColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PlanoColors.border),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: PlanoColors.greenSoft,
            child: Text('J',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: PlanoColors.greenMid)),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('João',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('jppschmall02@outlook.com',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12.5, color: PlanoColors.textSecondary)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: PlanoColors.textSecondary),
        ],
      ),
    );
  }

  Widget _group(String label, List<Widget> tiles) {
    final children = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      children.add(tiles[i]);
      if (i < tiles.length - 1) {
        children.add(
            const Divider(height: 1, indent: 56, color: PlanoColors.border));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: PlanoColors.textSecondary)),
        ),
        Container(
          decoration: BoxDecoration(
            color: PlanoColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: PlanoColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _tile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: PlanoColors.textSecondary, size: 22),
      title: Text(title,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded,
          size: 20, color: PlanoColors.textSecondary),
      onTap: () {},
    );
  }

  Widget _switchTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: PlanoColors.textSecondary, size: 22),
      title: Text(title,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: _notifications,
        onChanged: (v) => setState(() => _notifications = v),
      ),
    );
  }
}
