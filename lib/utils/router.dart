/// {@category Utils}
library router;

import 'package:go_router/go_router.dart';
import 'package:save_card/screens/validate_card.dart';
import 'package:save_card/screens/validated_cards_list.dart';

///Router that is used to navigate through screens.
class MyRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SavedCardsList(),
      ),
      GoRoute(
        path: '/${SaveCard.route}/:id',
        name: SaveCard.route,
        builder: (context, state) => SaveCard(id: int.parse(state.pathParameters['id'] ?? '0'),),
      ),
    ],
    initialLocation: '/',
  );
}
