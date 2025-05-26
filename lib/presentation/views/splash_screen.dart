import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/constant/image_strings.dart';
import 'package:habit_tracker/services/splash_service.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashService splashService = SplashService();
  @override
  void initState() {
    super.initState();
    splashService.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(login_image),
                fit: BoxFit.cover,
              ),
              color: Colors.white,
            ),
            // child: const Center(child: Text('Splash Screen', style: TextStyle(color: AppColors.primaryBlue,fontSize: 24),)),
      ),
    );
  }
}