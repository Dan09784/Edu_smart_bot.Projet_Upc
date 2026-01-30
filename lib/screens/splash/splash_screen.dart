import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
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
          'assets/lottie/CMS computer animation',
          width: 300,
          height: 300,
          fit: BoxFit.fill,
        )
      ),
    );
  }

}
