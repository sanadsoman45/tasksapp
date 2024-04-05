import 'package:assignmenttask/core/routes/route_config.dart';
import 'package:flutter/material.dart';
import 'package:assignmenttask/task_injection.dart' as packageDI;
import 'package:url_strategy/url_strategy.dart';

void main() async{
  //will wait till the below file has initialized all the required dependencies.
  await packageDI.init();

  setPathUrlStrategy();// to remove the # from route generated by gorouter.
  runApp(MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: AppRouteConfig().router, //will implement and map the information obtained from info. parser.
  ));
 
}