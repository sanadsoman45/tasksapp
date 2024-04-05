import 'package:assignmenttask/core/routes/routeconstants.dart';
import 'package:assignmenttask/features/Home/presentation/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouteConfig {
  GoRouter router = GoRouter(routes: [
    GoRoute(
        path: "/",
        name: RouteConstants.homeRoute,
        pageBuilder: (context, state) {
          return MaterialPage(child: HomePage());
        }),
  ]);
}
