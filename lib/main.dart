import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/loginpage.dart';
import 'screens/firstpage.dart';
import 'screens/dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase before app runs
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AvoidPlasticApp());
}

class AvoidPlasticApp extends StatelessWidget {
  const AvoidPlasticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avoid Plastic App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        fontFamily: 'Poppins',
      ),

      // 👇 Set FirstPage as the start screen
      home: const FirstPage(),

      routes: {
        '/login': (context) => const LoginPage(),
        //'/signup': (context) => const SignupPage(),
        '/home': (context) => const FirstPage(),
         '/dashboard': (context) => const Dashboard(),
      },
    );
  }
}
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          // ✅ User already logged in
          return const FirstPage();
        } else {
          // 🚪 Not logged in → go to login
          return const Dashboard();
        }
      },
    );
  }
}