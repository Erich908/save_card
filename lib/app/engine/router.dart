/// {@category Utils}
library my_router;

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import '../../presentation/history/history_page.dart';
import '../../presentation/validate/validate_page.dart';

part 'router.gr.dart';

///Router that is used to navigate through screens.
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class MyRouter extends _$MyRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ValidateRoute.page),
    AutoRoute(page: HistoryRoute.page, initial: true)
  ];
}
