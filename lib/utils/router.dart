import 'package:go_router/go_router.dart';
import 'package:save_card/screens/save_card.dart';
import 'package:save_card/screens/saved_cards_list.dart';

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
