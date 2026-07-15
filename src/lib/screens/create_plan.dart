import 'package:flutter/material.dart';

import '../models.dart';
import '../shell.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

/// Formulário para criar um plano próprio (mock — sem backend).
class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final _title = TextEditingController();
  final _location = TextEditingController();
  final _description = TextEditingController();
  String _category = 'Social';
  DateTime? _date;
  TimeOfDay? _time;

  static final _allCategories = [...planCategories, ...morePlanCategories];

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null && mounted) setState(() => _time = picked);
  }

  void _create() {
    if (_title.text.trim().isEmpty || _location.text.trim().isEmpty || _date == null || _time == null) {
      showToast(context, 'Preencha título, local, data e hora.');
      return;
    }
    final plan = Plan(
      id: 'me-${DateTime.now().millisecondsSinceEpoch}',
      title: _title.text.trim(),
      category: _category,
      icon: iconForCategory(_category),
      dateTime: DateTime(_date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute),
      location: _location.text.trim(),
      description: _description.text.trim().isEmpty ? 'Plano criado por você. Convide quem quiser!' : _description.text.trim(),
      members: [const Member(AppState.userName)],
      createdByMe: true,
    );
    final shell = RootShell.of(context);
    appState.createPlan(plan);
    showToast(context, 'Plano criado!');
    shell.switchTab(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlanoColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          children: [
            const Row(
              children: [
                BackCircle(),
                SizedBox(width: 14),
                Text('Criar plano', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 24),
            _label('Título'),
            _textField(_title, 'Ex: Café e conversa no sábado'),
            const SizedBox(height: 18),
            _label('Tipo'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in _allCategories)
                  GestureDetector(
                    onTap: () => setState(() => _category = c.$1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                      decoration: BoxDecoration(
                        color: _category == c.$1 ? PlanoColors.green : PlanoColors.surface,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: _category == c.$1 ? PlanoColors.green : PlanoColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(c.$2, size: 15, color: _category == c.$1 ? Colors.white : PlanoColors.greenMid),
                          const SizedBox(width: 6),
                          Text(
                            c.$1,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _category == c.$1 ? Colors.white : PlanoColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Data'),
                      _pickerField(
                        icon: Icons.calendar_today_outlined,
                        text: _date == null ? 'Escolher data' : '${_date!.day}/${two(_date!.month)}/${_date!.year}',
                        filled: _date != null,
                        onTap: _pickDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Hora'),
                      _pickerField(
                        icon: Icons.schedule_rounded,
                        text: _time == null ? 'Escolher hora' : '${two(_time!.hour)}:${two(_time!.minute)}',
                        filled: _time != null,
                        onTap: _pickTime,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _label('Local'),
            _textField(_location, 'Ex: Parque do Ibirapuera, São Paulo'),
            const SizedBox(height: 18),
            _label('Descrição'),
            _textField(_description, 'Conte o que vocês vão fazer…', maxLines: 4),
            const SizedBox(height: 26),
            Container(
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
                  onPressed: _create,
                  style: FilledButton.styleFrom(
                    backgroundColor: PlanoColors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: const Text('Criar plano', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      );

  Widget _textField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: PlanoColors.textSecondary, fontSize: 14),
        filled: true,
        fillColor: PlanoColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: PlanoColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: PlanoColors.green, width: 1.4),
        ),
      ),
    );
  }

  Widget _pickerField({
    required IconData icon,
    required String text,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: PlanoColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PlanoColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 17, color: filled ? PlanoColors.greenMid : PlanoColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: filled ? FontWeight.w600 : FontWeight.w400,
                  color: filled ? PlanoColors.textPrimary : PlanoColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
