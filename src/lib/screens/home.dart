import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../shell.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'create_plan.dart';
import 'plan_detail.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  String? _filter;

  static final _mainLabels = planCategories.map((c) => c.$1).toSet();

  String? get _extraSelected => _filter != null && !_mainLabels.contains(_filter) ? _filter : null;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia,';
    if (h < 18) return 'Boa tarde,';
    return 'Boa noite,';
  }

  List<Plan> _filtered(List<Plan> plans) {
    final q = _query.trim().toLowerCase();
    final result = plans.where((p) {
      final matchesCategory = _filter == null || p.category == _filter;
      final matchesQuery = q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.location.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return result;
  }

  void _toggleFilter(String label) => setState(() => _filter = _filter == label ? null : label);

  Future<void> _openMoreTypes() async {
    final selected = await showModalBottomSheet<String>(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PlanoColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const SectionTitle('Mais tipos de plano'),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final c in morePlanCategories)
                    _TypeChip(
                      label: c.$1,
                      icon: c.$2,
                      selected: _filter == c.$1,
                      onTap: () => Navigator.pop(sheetContext, c.$1),
                    ),
                ],
              ),
              if (_filter != null) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(sheetContext, ''),
                    child: const Text('Limpar filtro', style: TextStyle(color: PlanoColors.textSecondary)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    if (selected == null || !mounted) return;
    setState(() => _filter = selected.isEmpty ? null : (_filter == selected ? null : selected));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: PlanoColors.background,
        body: SafeArea(
          bottom: false,
          child: ListenableBuilder(
            listenable: appState,
            builder: (context, _) {
              final plans = _filtered(appState.discover);
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                children: [
                  _header(context),
                  const SizedBox(height: 18),
                  _searchField(),
                  const SizedBox(height: 16),
                  _createButton(context),
                  const SizedBox(height: 26),
                  _categories(),
                  const SizedBox(height: 26),
                  SectionTitle(_query.trim().isNotEmpty ? 'Resultados' : (_filter ?? 'Planos em destaque')),
                  const SizedBox(height: 12),
                  if (plans.isEmpty)
                    _emptyResults()
                  else
                    for (final plan in plans)
                      PlanCard(
                        plan,
                        onTap: () => RootShell.of(context).pushInShell(PlanDetailScreen(plan)),
                      ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        // Foto do usuário (iniciais como placeholder)
        const CircleAvatar(
          radius: 20,
          backgroundColor: PlanoColors.greenSoft,
          child: Text('J', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: PlanoColors.greenMid)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_greeting(), style: const TextStyle(fontSize: 13, color: PlanoColors.textSecondary)),
            const Text(AppState.userName, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ],
        ),
        const Spacer(),
        // Ajustes — canto superior direito (abre SEM a barra de navegação)
        IconButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
          icon: const Icon(Icons.settings_outlined, color: PlanoColors.textPrimary),
          tooltip: 'Ajustes',
        ),
      ],
    );
  }

  Widget _searchField() {
    return TextField(
      onChanged: (v) => setState(() => _query = v),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Buscar planos',
        hintStyle: const TextStyle(color: PlanoColors.textSecondary, fontSize: 14.5),
        prefixIcon: const Icon(Icons.search_rounded, color: PlanoColors.textSecondary),
        filled: true,
        fillColor: PlanoColors.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _createButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x335FAE7F), blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () => RootShell.of(context).pushInShell(const CreatePlanScreen()),
          style: FilledButton.styleFrom(
            backgroundColor: PlanoColors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          icon: const Icon(Icons.add_rounded, size: 24),
          label: const Text('Criar meu próprio plano', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _categories() {
    return SizedBox(
      height: 84,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          for (final c in planCategories) ...[
            _CategoryButton(
              label: c.$1,
              icon: c.$2,
              selected: _filter == c.$1,
              onTap: () => _toggleFilter(c.$1),
            ),
            const SizedBox(width: 14),
          ],
          _CategoryButton(
            label: _extraSelected ?? 'Mais',
            icon: _extraSelected != null ? iconForCategory(_extraSelected!) : Icons.travel_explore_rounded,
            selected: _extraSelected != null,
            muted: _extraSelected == null,
            onTap: _openMoreTypes,
          ),
        ],
      ),
    );
  }

  Widget _emptyResults() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: PlanoColors.textSecondary),
          SizedBox(height: 12),
          Text('Nenhum plano encontrado', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text(
            'Tente outra busca — ou crie o seu próprio plano.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: PlanoColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Botão de categoria (ícone em quadrado arredondado + rótulo).
class _CategoryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool muted; // estilo cinza (botão "Mais")
  final VoidCallback onTap;
  const _CategoryButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = selected ? PlanoColors.green : (muted ? PlanoColors.surfaceAlt : PlanoColors.greenSoft);
    final Color fg = selected ? Colors.white : (muted ? PlanoColors.textSecondary : PlanoColors.greenMid);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 62,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: fg, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? PlanoColors.greenMid : PlanoColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip de tipo (usado na planilha de "mais tipos").
class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? PlanoColors.green : PlanoColors.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: selected ? PlanoColors.green : PlanoColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: selected ? Colors.white : PlanoColors.greenMid),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : PlanoColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
