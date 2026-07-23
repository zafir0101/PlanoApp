import 'package:flutter/foundation.dart';
import 'models.dart';

/// Estado do app (front-end apenas — sem backend).
class AppState extends ChangeNotifier {
  AppState() : discover = buildMockPlans();

  /// Planos disponíveis para explorar.
  final List<Plan> discover;

  /// Planos em que o usuário entrou (ordenados pelo mais próximo).
  final List<Plan> myPlans = [];

  /// Planos para os quais o usuário marcou "Já estou a caminho".
  final Set<String> onTheWayIds = {};

  static const userName = 'João';

  bool isJoined(Plan plan) => myPlans.any((p) => p.id == plan.id);

  void joinPlan(Plan plan) {
    if (isJoined(plan)) return;
    if (!plan.members.any((m) => m.name == userName)) {
      plan.members.add(const Member(userName));
    }
    myPlans
      ..add(plan)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  void leavePlan(Plan plan) {
    myPlans.removeWhere((p) => p.id == plan.id);
    plan.members.removeWhere((m) => m.name == userName);
    onTheWayIds.remove(plan.id);
    notifyListeners();
  }

  /// Cria um plano próprio e já entra nele.
  void createPlan(Plan plan) {
    discover.insert(0, plan);
    joinPlan(plan); // notifica os listeners
  }

  void markOnTheWay(Plan plan) {
    onTheWayIds.add(plan.id);
    notifyListeners();
  }
}

final appState = AppState();
