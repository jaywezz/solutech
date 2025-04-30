import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solutench/features/reports/screens/reports_screen.dart';
import 'package:solutench/features/visits/models/visits_model.dart';
import 'package:solutench/features/visits/screens/visits_form.dart';
import 'package:solutench/features/visits/screens/visits_screen.dart';
import 'package:solutench/splash_screen.dart';



final rootNavigatorKey = GlobalKey<NavigatorState>();

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
      name: SplashScreen.routeName,
      pageBuilder: (context, state) =>  const NoTransitionPage(
        child:SplashScreen(),
      ),
    ),
    
    GoRoute(
      path: "/reports",
      name: ReportsScreen.routeName,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: ReportsScreen(),
      ),
      routes: [
        GoRoute(
          path: "/visits",
          name: VisitsScreen.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: VisitsScreen(),
          ),
          routes: [
            GoRoute(
              path: "form",
              name: VisitsForm.routeName,
              pageBuilder: (context, state) =>  NoTransitionPage(
                child: VisitsForm(visit: state.extra as Visits),
              )
            )
          ]
        ),
      ]
    ),
    
    

  ],
);
