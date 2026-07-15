import 'package:flutter/material.dart';

// ============================== Modelos ==============================

class Member {
  final String name;
  const Member(this.name);

  String get firstName => name.split(' ').first;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class Plan {
  final String id;
  final String title;
  final String category;
  final IconData icon;
  final DateTime dateTime;
  final String location;
  final String description;
  final List<Member> members;
  final bool createdByMe;

  Plan({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.dateTime,
    required this.location,
    required this.description,
    required this.members,
    this.createdByMe = false,
  });
}

class Benefit {
  final String partner;
  final String offer;
  final String tag;
  final IconData icon;
  final String code;
  const Benefit(this.partner, this.offer, this.tag, this.icon, this.code);
}

// ============================ Categorias ============================

/// Principais tipos de plano (Home).
const planCategories = <(String, IconData)>[
  ('Trilhas', Icons.terrain_rounded),
  ('Praias', Icons.beach_access_rounded),
  ('Cafés', Icons.local_cafe_rounded),
  ('Social', Icons.groups_rounded),
];

/// Outros tipos ("buscar mais tipos").
const morePlanCategories = <(String, IconData)>[
  ('Esportes', Icons.sports_soccer_rounded),
  ('Parques', Icons.park_rounded),
  ('Cinema', Icons.theaters_rounded),
  ('Música', Icons.music_note_rounded),
  ('Gastronomia', Icons.restaurant_rounded),
  ('Cultura', Icons.museum_rounded),
  ('Jogos', Icons.extension_rounded),
  ('Voluntariado', Icons.volunteer_activism_rounded),
];

IconData iconForCategory(String label) {
  for (final c in [...planCategories, ...morePlanCategories]) {
    if (c.$1 == label) return c.$2;
  }
  return Icons.event_rounded;
}

// ===================== Datas em pt-BR (sem libs) =====================

const _weekdaysShort = ['seg', 'ter', 'qua', 'qui', 'sex', 'sáb', 'dom'];
const _weekdaysFull = [
  'segunda-feira',
  'terça-feira',
  'quarta-feira',
  'quinta-feira',
  'sexta-feira',
  'sábado',
  'domingo',
];
const _monthsShort = [
  'jan',
  'fev',
  'mar',
  'abr',
  'mai',
  'jun',
  'jul',
  'ago',
  'set',
  'out',
  'nov',
  'dez',
];
const _monthsFull = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

String two(int n) => n.toString().padLeft(2, '0');

/// Ex.: "sáb, 18 jul · 09:00"
String formatShort(DateTime d) => '${_weekdaysShort[d.weekday - 1]}, ${d.day} ${_monthsShort[d.month - 1]} · ${formatTime(d)}';

/// Ex.: "sábado, 18 de julho"
String formatFullDate(DateTime d) => '${_weekdaysFull[d.weekday - 1]}, ${d.day} de ${_monthsFull[d.month - 1]}';

/// Ex.: "09:00"
String formatTime(DateTime d) => '${two(d.hour)}:${two(d.minute)}';

String capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// Ex.: "Ana, Pedro, Marina e mais 2"
String membersLine(List<Member> members) {
  final names = members.map((m) => m.firstName).toList();
  if (names.isEmpty) return 'Ninguém ainda — seja a primeira pessoa!';
  if (names.length == 1) return names.first;
  if (names.length <= 3) {
    return '${names.sublist(0, names.length - 1).join(', ')} e ${names.last}';
  }
  return '${names.take(3).join(', ')} e mais ${names.length - 3}';
}

// ========================= Dados de exemplo =========================

List<Plan> buildMockPlans() {
  final now = DateTime.now();
  DateTime at(int days, int hour, [int minute = 0]) =>
      DateTime(now.year, now.month, now.day, hour, minute).add(Duration(days: days));

  return [
    Plan(
      id: 'p1',
      title: 'Trilha ao amanhecer',
      category: 'Trilhas',
      icon: Icons.terrain_rounded,
      dateTime: at(1, 6, 30),
      location: 'Pedra Grande — Atibaia, SP',
      description: 'Subida tranquila de 3 km para ver o nascer do sol lá de cima. '
          'Ritmo leve, café compartilhado no topo. Leve água e um agasalho.',
      members: [
        const Member('Ana Souza'),
        const Member('Pedro Lima'),
        const Member('Marina Reis'),
        const Member('Caio Duarte'),
      ],
    ),
    Plan(
      id: 'p2',
      title: 'Café & conversa',
      category: 'Cafés',
      icon: Icons.local_cafe_rounded,
      dateTime: at(2, 16, 0),
      location: 'Café Alma — Vila Madalena, SP',
      description: 'Um fim de tarde sem pressa: cafés especiais, boas conversas '
          'e zero celular na mesa.',
      members: [
        const Member('Júlia Antunes'),
        const Member('Rafael Costa'),
        const Member('Bianca Melo'),
      ],
    ),
    Plan(
      id: 'p3',
      title: 'Vôlei de praia casual',
      category: 'Praias',
      icon: Icons.beach_access_rounded,
      dateTime: at(3, 9, 0),
      location: 'Praia de Icaraí — Niterói, RJ',
      description: 'Jogo leve pra quem quer se mexer e conhecer gente nova. '
          'Todos os níveis são bem-vindos.',
      members: [
        const Member('Thiago Nunes'),
        const Member('Larissa Prado'),
        const Member('Felipe Ramos'),
        const Member('Camila Ohara'),
        const Member('Bruno Sales'),
      ],
    ),
    Plan(
      id: 'p4',
      title: 'Noite de jogos de tabuleiro',
      category: 'Social',
      icon: Icons.extension_rounded,
      dateTime: at(4, 19, 30),
      location: 'Ludoteca Central — Pinheiros, SP',
      description: 'Catan, Dixit e o que mais aparecer. Ambiente descontraído, '
          'entrada livre.',
      members: [
        const Member('Nina Torres'),
        const Member('Diego Farias'),
        const Member('Alice Bittencourt'),
      ],
    ),
    Plan(
      id: 'p5',
      title: 'Piquenique no parque',
      category: 'Social',
      icon: Icons.park_rounded,
      dateTime: at(6, 10, 0),
      location: 'Parque do Ibirapuera — São Paulo, SP',
      description: 'Cada um leva algo pra compartilhar. Música baixa, jogos de '
          'gramado e boa companhia.',
      members: [
        const Member('Sofia Lemos'),
        const Member('Gabriel Pontes'),
        const Member('Helena Dias'),
        const Member('Otávio Brito'),
      ],
    ),
  ];
}

const mockBenefits = <Benefit>[
  Benefit('Café Alma', '20% de desconto em qualquer bebida', 'Cafés', Icons.local_cafe_rounded, 'PLANO-ALMA20'),
  Benefit('Studio Gaia', 'Aula experimental de yoga gratuita', 'Atividades', Icons.self_improvement_rounded, 'PLANO-GAIA1'),
  Benefit('Casa Boulder', '2x1 na diária de escalada', 'Atividades', Icons.fitness_center_rounded, 'PLANO-BOULDER'),
  Benefit('Restaurante Raiz', '15% no almoço de sábado', 'Restaurantes', Icons.restaurant_rounded, 'PLANO-RAIZ15'),
  Benefit('Onda Surf School', 'Primeira aula de surf grátis', 'Atividades', Icons.surfing_rounded, 'PLANO-ONDA1'),
  Benefit('Cine Vila', 'Ingresso duplo com 30% de desconto', 'Cultura', Icons.theaters_rounded, 'PLANO-CINE30'),
];
