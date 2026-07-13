# Plano — Front-end (Flutter)

Front-end do app **Plano** para iOS e Android, em Flutter. Sem backend: os dados são de exemplo (mock) para validar o design e o fluxo.

## Ver sem instalar nada

Abra **`../Preview_Plano.html`** no navegador — é uma réplica interativa do app (navegação, busca, participar de plano, contagem regressiva, benefícios, ajustes).

## Rodar o app

1. Instale o [Flutter SDK](https://docs.flutter.dev/get-started/install)
2. No terminal:

```bash
cd plano_app
flutter create . --project-name plano_app --org com.plano   # só na 1ª vez (gera android/ e ios/)
flutter pub get
flutter run
```

## Estrutura

| Arquivo | Papel |
|---|---|
| `lib/main.dart` | Entrada do app |
| `lib/shell.dart` | Shell com as 3 abas + barra de navegação suspensa (blur/transparência) |
| `lib/theme.dart` | Paleta e tema |
| `lib/models.dart` | Modelos, categorias, formatação de datas pt-BR, dados de exemplo |
| `lib/state.dart` | Estado (planos que entrou, "a caminho", criar plano) |
| `lib/widgets.dart` | Componentes compartilhados (cards, avatares, pílulas) |
| `lib/screens/home.dart` | Home: avatar, busca, "Criar meu próprio plano", categorias, exemplos |
| `lib/screens/plan_detail.dart` | Detalhe: tipo, data/hora, local, descrição, membros, participar |
| `lib/screens/my_plans.dart` | Meus Planos: verde profundo, countdown, "Já estou a caminho" |
| `lib/screens/benefits.dart` | Benefícios: parcerias com resgate de código |
| `lib/screens/settings.dart` | Ajustes (única tela sem a barra inferior) |

## Design

Minimalismo: nada rouba a atenção de **encontrar ou criar um plano**.

| Token | Cor |
|---|---|
| Fundo | `#FAFAF8` |
| Superfície / borda | `#FFFFFF` / `#E7EAE7` |
| Texto | `#20261F` / `#8B928A` |
| Verde acento | `#5FAE7F` (soft `#E8F3EC`, mid `#4C9C6D`) |
| Verde profundo (plano ativo) | `#275E43` |

Decisões: barra inferior suspensa com bordas arredondadas e leve transparência (visível em todas as telas, exceto Ajustes); Ajustes abre pelo ícone no canto superior direito da Home; ao participar de um plano, o usuário é levado a Meus Planos, que vira a tela de acompanhamento do evento.
