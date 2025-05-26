import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/config/router/app_router.gr.dart';
import 'package:habit_tracker/constant/text_strings.dart';
import 'package:habit_tracker/services/shared_preferences.dart';

class SplashService {
  void isLogin(BuildContext context){
    Timer(const Duration(seconds: 3), () { 
       bool isLogin = SharedprefUtils.getBool(isSignin);
       if(isLogin) {
        AutoRouter.of(context).replaceAll([DashboardRoute()]);
       } else {
          AutoRouter.of(context).replaceAll([LoginRoute()]);
       }
      // AutoRouter.of(context).push( !isLogin ?  DashboardRoute() : const LoginRoute());
    });
  }
}