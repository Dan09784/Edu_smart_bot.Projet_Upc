import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return ;
      Navigator.pushReplacementNamed(context, '/login');
    });
      
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: 
        Lottie.asset(
          'lib/assets/lottie/CMS computer animation.json',
          width: 300,
          height: 300,
          fit: BoxFit.fill,
        )
      ),
    );
  }

}
