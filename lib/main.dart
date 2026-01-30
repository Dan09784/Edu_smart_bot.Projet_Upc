import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/admin/admin_home.dart';
import 'screens/login/login_screen.dart';
import 'screens/student/student_home.dart';
import 'screens/teacher/teacher_home.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      title: 'EduSmartBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,useMaterial3: true
      ),
      initialRoute: '/',
      routes: {
        '/':(context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/student': (context) => const StudentHome(),
        '/teacher' :(context) => const TeacherHome(),
        '/admin' : (context) => const AdminHome(),
      },
    );
  }
}
