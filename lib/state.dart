import 'package:flutter/foundation.dart';
import 'models.dart';

// TODO: trocar esse typedef por uma classe email com validação
typedef Email = String;

class UserData extends Member {
  Email email;

  UserData(super.name, this.email, {super.photo, super.banner});
}

/// Estado do app (front-end apenas — sem backend).
class AppState extends ChangeNotifier {
  AppState() : discover = buildMockPlans();

  /// Planos disponíveis para explorar.
  final List<Plan> discover; // TODO: trocar por uma função para integrar melhor a API depois

  /// Planos em que o usuário entrou (ordenados pelo mais próximo).
  final List<Plan> myPlans = [];

  /// Planos para os quais o usuário marcou "Já estou a caminho".
  final Set<String> onTheWayIds = {}; // TODO: remover esse set INÚTIL

  static final user = UserData(
    'Bibi Satãnhayu',
    'israelprimeminister@hotmail.com.br',
    photo: "https://cms.forbesafrica.com/wp-content/uploads/2024/10/GettyImages-1473939945.jpg",
    banner: "https://upload.wikimedia.org/wikipedia/commons/d/d4/Flag_of_Israel.svg",
  );

  bool isJoined(Plan plan) => myPlans.any((p) => p.id == plan.id);

  void joinPlan(Plan plan) {
    if (isJoined(plan)) return;
    if (!plan.members.any((m) => m.name == user.name)) {
      plan.members.add(user);
    }
    myPlans
      ..add(plan)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  void leavePlan(Plan plan) {
    myPlans.removeWhere((p) => p.id == plan.id);
    plan.members.removeWhere((m) => m.name == user.name);
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
