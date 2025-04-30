import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solutench/splash_screen.dart';



final rootNavigatorKey = GlobalKey<NavigatorState>();
enum AppRoutes{
  confirmStockLift,
}
final goRouter = GoRouter(
  redirect: (BuildContext context, GoRouterState state) async{
    // Replace this method depends on how you are managing your user's
    // Sign in status, then return the appropriate route you want to redirect to,
    // make sure your login/authentication bloc is provided at the top level
    // of your app
    // state.
    return;
  },
  initialLocation: '/splash',
  // * Passing a navigatorKey causes an issue on hot reload:
  // * https://github.com/flutter/flutter/issues/113757#issuecomment-1518421380
  // * However it's still necessary otherwise the navigator pops back to
  // * root on hot reload
  navigatorKey: rootNavigatorKey,

  // debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: "/splash",
      name: SplashScreenPage.routeName,
      pageBuilder: (context, state) =>  const NoTransitionPage(
        child:SplashScreenPage(),
      ),
    ),
    

  ],
);
